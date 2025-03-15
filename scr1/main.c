#include "main.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <time.h>
#include <pthread.h>
#include <signal.h>
#include <stdatomic.h>
#include <sys/utsname.h>
#include <locale.h>

#define LOG_DUMP_SIGNAL       SIGUSR1
#define LOG_TOGGLE_SIGNAL     SIGUSR2
#define LOG_LEVEL_SIGNAL      SIGURG
#define LOG_TERMINATE_SIGNAL  SIGTERM

#define DUMP_FILE_PREFIX "dump_"

static FILE* log_file = NULL;
static pthread_mutex_t log_mutex = PTHREAD_MUTEX_INITIALIZER;
static volatile sig_atomic_t log_enabled = 1;
static volatile sig_atomic_t current_log_level = LOG_STANDARD;

static volatile sig_atomic_t event_dump_requested = 0;
static volatile sig_atomic_t event_toggle_requested = 0;
static volatile sig_atomic_t event_level_requested = 0;
static volatile sig_atomic_t event_terminate_requested = 0;

void dump_state(void) {
    time_t now = time(NULL);

    char filename[256];
    snprintf(filename, sizeof(filename), "%s%ld.txt", DUMP_FILE_PREFIX, now);

    FILE* dump_file = fopen(filename, "w");

    setlocale(LC_ALL, "");
    struct utsname sysinfo;
    memset(&sysinfo, 0, sizeof(sysinfo));

    if (uname(&sysinfo) < 0) {
        perror("uname");
        return;
    }

    if (dump_file) {
        int cur_level = atomic_load(&current_log_level);
        char timestr[64];
        char hostname[256];

        struct tm tm_info;
        localtime_r(&now, &tm_info);
        strftime(timestr, sizeof(timestr), "%Y-%m-%d %H:%M:%S", &tm_info);

        fprintf(dump_file, "System Information Dump\n");
        fprintf(dump_file, "-----------------------\n");
        fprintf(dump_file, "[%s]\n", timestr);
        fprintf(dump_file, "Log Level: %d\n", cur_level);
        fprintf(dump_file, "System: %s\n", sysinfo.sysname);
        fprintf(dump_file, "Node Name: %s\n", sysinfo.nodename);
        fprintf(dump_file, "Release: %s\n", sysinfo.release);
        fprintf(dump_file, "Version: %s\n", sysinfo.version);
        fprintf(dump_file, "Machine: %s\n", sysinfo.machine);
        if (gethostname(hostname, sizeof(hostname)) == 0) {
            fprintf(dump_file, "Hostname: %s\n", hostname);
        } else {
            perror("gethostname");
        }

        fclose(dump_file);
    }
}

void toggle_logging(void) {
    log_enabled = !log_enabled;
}

void change_log_level(void) {
    int new_log_level = (atomic_load(&current_log_level) + 1) % 3;
    atomic_store(&current_log_level, new_log_level);
}

static void signal_handler(int signo) {
    switch (signo) {
        case LOG_DUMP_SIGNAL:
            atomic_store(&event_dump_requested, 1);
            break;
        case LOG_TOGGLE_SIGNAL:
            atomic_store(&event_toggle_requested, 1);
            break;
        case LOG_LEVEL_SIGNAL:
            atomic_store(&event_level_requested, 1);
            break;
        case LOG_TERMINATE_SIGNAL:
            atomic_store(&event_terminate_requested, 1);
            break;
        default:
            break;
    }
}

void init(const char* log_filename) {
    log_file = fopen(log_filename, "a");
    if (!log_file) {
        perror("Nie można otworzyć pliku log");
        exit(EXIT_FAILURE);
    }

    struct sigaction act;
    act.sa_handler = signal_handler;
    act.sa_flags = 0;
    sigemptyset(&act.sa_mask);

    if (sigaction(LOG_DUMP_SIGNAL, &act, NULL) == -1) {
        perror("Błąd przy sigaction dla LOG_DUMP_SIGNAL");
        exit(EXIT_FAILURE);
    }
    if (sigaction(LOG_TOGGLE_SIGNAL, &act, NULL) == -1) {
        perror("Błąd przy sigaction dla LOG_TOGGLE_SIGNAL");
        exit(EXIT_FAILURE);
    }
    if (sigaction(LOG_LEVEL_SIGNAL, &act, NULL) == -1) {
        perror("Błąd przy sigaction dla LOG_LEVEL_SIGNAL");
        exit(EXIT_FAILURE);
    }
    if (sigaction(LOG_TERMINATE_SIGNAL, &act, NULL) == -1) {
        perror("Błąd przy sigaction dla LOG_TERMINATE_SIGNAL");
        exit(EXIT_FAILURE);
    }
}

void cleanup(void) {
    if (log_file) {
        fclose(log_file);
        log_file = NULL;
    }
}

void log_message(log_level_t cur_level, const char* data_czas, const char* komunikat) {
    if (!atomic_load(&log_enabled))
        return;

    setlocale(LC_ALL, "");
    struct utsname sysinfo;
    memset(&sysinfo, 0, sizeof(sysinfo));

    if (uname(&sysinfo) < 0) {
        perror("uname");
        return;
    }

    pthread_mutex_lock(&log_mutex);

    if (log_file) {
        char buffer[1024];
        if (cur_level == LOG_MIN) {
            snprintf(buffer, sizeof(buffer), "[%s]\nLog Level: %d\n%s", data_czas, cur_level, komunikat);
        } else if (cur_level == LOG_STANDARD) {
            snprintf(buffer, sizeof(buffer), "[%s]\nLog Level: %d\n%s\nSystem: %s\nNode Name: %s", data_czas, cur_level, komunikat, sysinfo.sysname, sysinfo.nodename);
        } else if (cur_level == LOG_MAX) {
            snprintf(buffer, sizeof(buffer), "[%s]\nLog Level: %d\n%s\nSystem: %s\nNode Name: %s\nRelease: %s\nVersion: %s\nMachine: %s", data_czas, cur_level, komunikat, sysinfo.sysname, sysinfo.nodename, sysinfo.release, sysinfo.version, sysinfo.machine);
        }
        fprintf(log_file, "%s\n\n", buffer);
        fflush(log_file);
    }

    pthread_mutex_unlock(&log_mutex);
}

int main() {
    init("logfile.log");

    printf("Program uruchomiony. Oczekiwanie na sygnały\n");
    printf("PID: %d\n", getpid());
    printf("Sygnały:\n  Zrzut dump:              SIGUSR1\n  Przelaczenie log on/off: SIGUSR2\n  Log level up:            SIGURG\n  Zakonczenie pracy:       SIGTERM\n");

    while (1) {
        if (atomic_load(&event_dump_requested)) {
            dump_state();
            atomic_store(&event_dump_requested, 0);

            char data_czas[64];
            time_t now = time(NULL);
            strftime(data_czas, sizeof(data_czas), "%Y-%m-%d %H:%M:%S", localtime(&now));
            log_message(current_log_level, data_czas, "Wykonanie zrzutu dump");
            printf("Wykonanie zrzutu dump\n");
        }
        if (atomic_load(&event_toggle_requested)) {
            toggle_logging();
            atomic_store(&event_toggle_requested, 0);

            char data_czas[64];
            time_t now = time(NULL);
            strftime(data_czas, sizeof(data_czas), "%Y-%m-%d %H:%M:%S", localtime(&now));
            if (log_enabled) {
                log_message(current_log_level, data_czas, "Logowanie: off");
                printf("Logowanie: on\n");
            }else {
                log_message(current_log_level, data_czas, "Logowanie: on");
                printf("Logowanie: off\n");
            }
        }
        if (atomic_load(&event_level_requested)) {
            change_log_level();
            atomic_store(&event_level_requested, 0);

            char data_czas[64];
            time_t now = time(NULL);
            strftime(data_czas, sizeof(data_czas), "%Y-%m-%d %H:%M:%S", localtime(&now));
            log_message(current_log_level, data_czas, "Obsluga zdarzenia level up");
            printf("Obsluga zdarzenia level up\n");
        }
        if (atomic_exchange(&event_terminate_requested, 0)) {
            char data_czas[64];
            time_t now = time(NULL);
            strftime(data_czas, sizeof(data_czas), "%Y-%m-%d %H:%M:%S", localtime(&now));
            log_message(current_log_level, data_czas, "Otrzymano sygnał zakończenia");
            printf("Otrzymano sygnał zakończenia. Kończenie pracy...\n");
            break;
        }
        pause();
    }

    cleanup();
    return 0;
}
