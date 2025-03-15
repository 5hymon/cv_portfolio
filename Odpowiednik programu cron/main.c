#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include <signal.h>
#include <mqueue.h>
#include <pthread.h>
#include <errno.h>

#define MQ_NAME "/mq_queue"
#define MAX_MSG_SIZE 1024
#define MAX_CMD_SIZE 512

typedef enum {
    CMD_ADD,
    CMD_LIST,
    CMD_CANCEL,
    CMD_STOP
} command_t;

typedef struct {
    command_t cmd;
    char schedule_type;   // 'r', 'a', 'p'
    long time_sec;        // 'r' i 'p': sekundy; 'a':  czas
    char command_line[MAX_CMD_SIZE];
    int task_id;
} mq_msg_t;

typedef struct task {
    int id;
    char schedule_type;
    long time_sec;
    timer_t timer;
    char command_line[MAX_CMD_SIZE];
    int periodic;         // 1, 0
    struct task *next;
} task_t;

static task_t *task_list = NULL;
static int next_task_id = 1;
static pthread_mutex_t tasks_mutex = PTHREAD_MUTEX_INITIALIZER;
static mqd_t server_mq;
static int server_running = 1;

void log_message(const char *msg) {
    FILE *f = fopen("tasks.log", "a");
    if (f) {
        time_t now = time(NULL);
        char timestr[64];
        strftime(timestr, sizeof(timestr), "%Y-%m-%d %H:%M:%S", localtime(&now));
        fprintf(f, "[%s] %s\n", timestr, msg);
        fclose(f);
    }
}

void timer_thread(union sigval sv) {
    task_t *task = (task_t *)sv.sival_ptr;
    char logbuf[256];
    snprintf(logbuf, sizeof(logbuf), "Wykonywanie zadania ID %d: %s", task->id, task->command_line);
    log_message(logbuf);
    printf("\nZadanie ID %d wykonane: %s\n", task->id, task->command_line);

    pid_t pid = fork();
    if (pid == 0) {
        system(task->command_line);
        exit(0);
    } else if (pid < 0) {
        perror("fork");
    }

    if (task->schedule_type != 'p') {
        pthread_mutex_lock(&tasks_mutex);
        task_t **ptr = &task_list;
        while(*ptr) {
            if((*ptr)->id == task->id) {
                task_t *tmp = *ptr;
                *ptr = (*ptr)->next;
                free(tmp);
                break;
            }
            ptr = &(*ptr)->next;
        }
        pthread_mutex_unlock(&tasks_mutex);
    }
}

int add_task(char schedule_type, long time_spec, const char *cmd_line) {
    task_t *new_task = malloc(sizeof(task_t));
    if (!new_task)
        return -1;
    new_task->id = next_task_id++;
    new_task->schedule_type = schedule_type;
    strncpy(new_task->command_line, cmd_line, MAX_CMD_SIZE - 1);
    new_task->command_line[MAX_CMD_SIZE - 1] = '\0';
    new_task->next = NULL;
    new_task->periodic = (schedule_type == 'p') ? 1 : 0;

    if (schedule_type == 'a') {
        time_t now = time(NULL);
        if (time_spec <= now) {
            free(new_task);
            return -2;
        }
        new_task->time_sec = time_spec - now;
    } else {
        new_task->time_sec = time_spec;
    }

    struct sigevent sev;
    sev.sigev_notify = SIGEV_THREAD;
    sev.sigev_value.sival_ptr = new_task;
    sev.sigev_notify_function = timer_thread;
    sev.sigev_notify_attributes = NULL;
    if (timer_create(CLOCK_REALTIME, &sev, &(new_task->timer)) != 0) {
        free(new_task);
        return -3;
    }

    struct itimerspec its;
    its.it_value.tv_sec = new_task->time_sec;
    its.it_value.tv_nsec = 0;
    if(new_task->periodic) {
        its.it_interval.tv_sec = new_task->time_sec;
        its.it_interval.tv_nsec = 0;
    } else {
        its.it_interval.tv_sec = 0;
        its.it_interval.tv_nsec = 0;
    }
    if(timer_settime(new_task->timer, 0, &its, NULL) != 0) {
        free(new_task);
        return -4;
    }

    pthread_mutex_lock(&tasks_mutex);
    new_task->next = task_list;
    task_list = new_task;
    pthread_mutex_unlock(&tasks_mutex);

    char logbuf[256];
    snprintf(logbuf, sizeof(logbuf), "Dodano zadanie ID %d: Typ czasu %c, Opoznienie %ld sekund, Polecenie: %s",
             new_task->id, schedule_type, new_task->time_sec, new_task->command_line);
    log_message(logbuf);
    return new_task->id;
}

void list_tasks() {
    pthread_mutex_lock(&tasks_mutex);
    task_t *cur = task_list;
    if (!cur)
        printf("\nBrak zadan\n");
    else
        printf("\nZlecone zadania:\n");
    while(cur) {
        printf("Zadanie ID: %d, Typ czasu: %c, Opoznienie: %ld sekund, Polecenie: %s\n",
               cur->id, cur->schedule_type, cur->time_sec, cur->command_line);
        cur = cur->next;
    }
    pthread_mutex_unlock(&tasks_mutex);
}

int cancel_task(int id) {
    pthread_mutex_lock(&tasks_mutex);
    task_t **ptr = &task_list;
    while(*ptr) {
        if((*ptr)->id == id) {
            timer_delete((*ptr)->timer);
            task_t *tmp = *ptr;
            *ptr = (*ptr)->next;
            free(tmp);
            pthread_mutex_unlock(&tasks_mutex);
            char logbuf[256];
            snprintf(logbuf, sizeof(logbuf), "Anulowano zadanie ID %d", id);
            log_message(logbuf);
            return 0;
        }
        ptr = &(*ptr)->next;
    }
    pthread_mutex_unlock(&tasks_mutex);
    return -1;
}

void cancel_all_tasks() {
    pthread_mutex_lock(&tasks_mutex);
    task_t *cur = task_list;
    while(cur) {
        timer_delete(cur->timer);
        task_t *tmp = cur;
        cur = cur->next;
        free(tmp);
    }
    task_list = NULL;
    pthread_mutex_unlock(&tasks_mutex);
    log_message("\nAnulowanie wszystkich zadan");
}

void server_loop() {
    mq_msg_t msg;
    unsigned int prio;
    while(server_running) {
        ssize_t bytes_read = mq_receive(server_mq, (char *)&msg, sizeof(msg), &prio);
        if(bytes_read >= 0) {
            switch(msg.cmd) {
                case CMD_ADD: {
                    int task_id = add_task(msg.schedule_type, msg.time_sec, msg.command_line);
                    if(task_id < 0) {
                        printf("\nNiepowodzenie: Dodanie zadania (error %d)\n", task_id);
                    } else {
                        printf("\nDodano zadanie ID %d\n", task_id);
                    }
                    break;
                }
                case CMD_LIST: {
                    list_tasks();
                    break;
                }
                case CMD_CANCEL: {
                    if(cancel_task(msg.task_id) == 0) {
                        printf("\nZadanie ID %d anulowane\n", msg.task_id);
                    } else {
                        printf("\nZadanie ID %d nie znalezione\n", msg.task_id);
                    }
                    break;
                }
                case CMD_STOP: {
                    printf("\nZatrzymywanie serwera\n");
                    server_running = 0;
                    break;
                }
                default:
                    break;
            }
        } else {
            if(errno == EINTR)
                continue;
            perror("mq_receive");
        }
    }
    cancel_all_tasks();
}

void client_mode(int argc, char *argv[]) {
    mqd_t mq = mq_open(MQ_NAME, O_WRONLY);
    if(mq == (mqd_t)-1) {
        perror("mq_open w kliencie");
        exit(EXIT_FAILURE);
    }
    mq_msg_t msg;
    memset(&msg, 0, sizeof(msg));
    if(argc < 2) {
        fprintf(stderr, "Dostepne operacje: add|list|cancel|stop\n");
        exit(EXIT_FAILURE);
    }
    if(strcmp(argv[1], "dodaj") == 0) {
        if(argc < 5) {
            fprintf(stderr, "dodaj <typ czasu> <czas> <polecenie>\n");
            exit(EXIT_FAILURE);
        }
        msg.cmd = CMD_ADD;
        msg.schedule_type = argv[2][0];
        msg.time_sec = atol(argv[3]);

        char command_buffer[MAX_CMD_SIZE] = "";
        for(int i = 4; i < argc; i++){
            strcat(command_buffer, argv[i]);
            if(i < argc-1)
                strcat(command_buffer, " ");
        }
        strncpy(msg.command_line, command_buffer, MAX_CMD_SIZE - 1);
    } else if(strcmp(argv[1], "lista") == 0) {
        msg.cmd = CMD_LIST;
    } else if(strcmp(argv[1], "przerwij") == 0) {
        if(argc < 3) {
            fprintf(stderr, "przerwij <zadanie ID>\n");
            exit(EXIT_FAILURE);
        }
        msg.cmd = CMD_CANCEL;
        msg.task_id = atoi(argv[2]);
    } else if(strcmp(argv[1], "zatrzymaj") == 0) {
        msg.cmd = CMD_STOP;
    } else {
        fprintf(stderr, "\nNieznane polecenie\n");
        exit(EXIT_FAILURE);
    }
    if(mq_send(mq, (const char *)&msg, sizeof(msg), 0) == -1) {
        perror("mq_send");
        exit(EXIT_FAILURE);
    }
    mq_close(mq);
}

int main(int argc, char *argv[]) {
    struct mq_attr attr;
    attr.mq_maxmsg = 10;
    attr.mq_msgsize = sizeof(mq_msg_t);
    attr.mq_flags = 0;
    mqd_t mq = mq_open(MQ_NAME, O_RDWR | O_CREAT | O_EXCL, 0666, &attr);
    if(mq != (mqd_t)-1) {
        server_mq = mq;
        printf("Serwer uruchomiony. PID: %d\n", getpid());
        printf("Dostepne komendy:\n");
        printf("  - dodaj <typ czasu> <czas> <polecenie>  (typ: 'r', 'a', 'p')\n  - lista\n  - przerwij <zadanie ID>\n  - zatrzymaj\n\n");
        server_loop();
        mq_close(server_mq);
        mq_unlink(MQ_NAME);
    } else {
        client_mode(argc, argv);
    }
    return 0;
}
