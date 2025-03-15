// file_reader.h

#ifndef FILE_READER_H
#define FILE_READER_H

#include <stdio.h>
#include <stdint.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#define SECTOR_BYTES 512
#define FAT_NAME 8
#define FAT_EXTENSION 3
#define DIR_INFO 11
#define DIR_ENTRY 13

struct boot_sector_t {          // bootSectorFat
    uint8_t  unused[3];
    uint8_t  name[8];
    uint16_t bytes_per_sector;
    uint8_t  sectors_per_clusters;
    uint16_t size_of_reserved_area;
    uint8_t  number_of_fats;
    uint16_t maximum_number_of_files;
    uint16_t number_of_sectors;
    uint8_t  media_type;
    uint16_t size_of_fat;
    uint16_t sectors_per_track;
    uint16_t number_of_heads;
    uint32_t number_of_sectors_before_partition;
    uint32_t number_of_sectors_in_filesystem;
    uint8_t  drive_number;
    uint8_t  unused_1;
    uint8_t  boot_signature;
    uint32_t serial_number;
    uint8_t  label[11];
    uint8_t  type[8];
    uint8_t  unused_2[448];
    uint16_t signature;
} __attribute__((packed));

struct dir_entry_t {
    char   name[13];
    size_t size;
    bool   is_archived;
    bool   is_readonly;
    bool   is_system;
    bool   is_hidden;
    bool   is_directory;
};

struct disk_t {
    uint32_t sectors;
    FILE*    file;
};

struct volume_t {
    struct disk_t*       pdisk;
    struct boot_sector_t boot_sector;
    void*                first_fat;
    void*                second_fat;
    void*                root_dir;
};

struct my_time_t{                  //my_time_t
    uint16_t seconds : 5;
    uint16_t minutes : 6;
    uint16_t hours : 5;
};

struct date_t{
    uint16_t day : 5;
    uint16_t month : 4;
    uint16_t year : 7;
};

struct __attribute__((__packed__)) dir_info_t
{
    char             filename[11];
    uint8_t          file_attributes;
    uint8_t          reserved;
    uint8_t          file_creation_time;
    struct my_time_t creation_time;
    struct date_t    creation_date;
    uint16_t         access_date;
    uint16_t         high_order_address_of_first_cluster;
    struct my_time_t modified_time;
    struct date_t    modified_date;
    uint16_t         low_order_address_of_first_cluster;
    uint32_t         size;
};

struct file_t {
    struct dir_info_t        info;
    struct volume_t*         volume;
    struct clusters_chain_t* clusters_chain;
    uint16_t                 current_position;
};

struct clusters_chain_t {
    uint16_t* clusters;
    size_t    size;
};

struct dir_t {
    void*   data;
    bool REF;
    int capacity;
    int position;
};

struct disk_t* disk_open_from_file(const char* volume_file_name);
int disk_read(struct disk_t* pdisk, int32_t first_sector, void* buffer, int32_t sectors_to_read);
int disk_close(struct disk_t* pdisk);

struct volume_t* fat_open(struct disk_t* pdisk, uint32_t first_sector);
int fat_close(struct volume_t* pvolume);

struct file_t* file_open(struct volume_t* pvolume, const char* file_name);
int file_close(struct file_t* stream);
size_t file_read(void *ptr, size_t size, size_t nmemb, struct file_t *stream);
int32_t file_seek(struct file_t* stream, int32_t offset, int whence);

struct dir_t* dir_open(struct volume_t* pvolume, const char* dir_path);
int dir_read(struct dir_t* pdir, struct dir_entry_t* pentry);
int dir_close(struct dir_t* pdir);

#endif