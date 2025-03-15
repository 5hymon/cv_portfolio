#include "file_reader.h"
#include "tested_declarations.h"
#include "rdebug.h"
#include "tested_declarations.h"
#include "rdebug.h"

int main(void) {
    disk_open_from_file(NULL);
    disk_read(NULL, 0, NULL, 0);
    disk_close(NULL);

    fat_open(NULL, 0);
    fat_close(NULL);

    file_open(NULL, NULL);
    file_close(NULL);
    file_read(NULL, 0, 0, NULL);
    file_seek(NULL, 0, 0);

    dir_open(NULL, NULL);
    dir_read(NULL, NULL);
    dir_close(NULL);
    return 0;
}


