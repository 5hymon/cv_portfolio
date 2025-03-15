#ifndef MAIN_H
#define MAIN_H

typedef enum { LOG_MIN, LOG_STANDARD, LOG_MAX } log_level_t;

static void signal_handler(int);

void init(const char* log_filename);

void cleanup(void);

void log_message(log_level_t cur_level, const char* data_czas, const char* komunikat);

void dump_state();

void toggle_logging(void);

void change_log_level(void);

#endif