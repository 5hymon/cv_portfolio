// file_reader.c

#include "file_reader.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "tested_declarations.h"
#include "rdebug.h"
#include "tested_declarations.h"
#include "rdebug.h"

uint16_t get_next_cluster(uint16_t current_cluster, void *buffer){
    uint8_t *tmp = buffer;
    uint16_t next = 0;

    uint16_t index = 3 * current_cluster / 2;
    uint8_t a,b;
    a = tmp[index];
    b = tmp[index + 1];

    if(current_cluster % 2){
        next += a >> 4;
        next += b << 4;
    }
    else{
        b = b << 4;
        b = b >> 4;
        next += a;
        next += b << 8;
    }

    return next;
}

struct clusters_chain_t *get_chain_fat12(void* buffer, size_t size, uint16_t first_cluster){
    uint16_t clusters = size / 3 * 2;
    if(!buffer || size < 1 || first_cluster > clusters) return NULL;

    struct clusters_chain_t *chain = malloc(sizeof(struct clusters_chain_t));
    if(!chain) return NULL;

    chain->clusters = NULL;
    chain->size = 1;

    for(uint16_t next=first_cluster; chain->size<(size_t)clusters+2;) {
        next = get_next_cluster(next, buffer);

        if(next >= 0xff8 && next<=0xfff) break;
        if(next >= clusters || chain->size > clusters){
            free(chain);
            return NULL;
        }
        chain->size++;
    }

    chain->clusters = malloc(chain->size * sizeof(uint16_t));
    if(!chain->clusters){
        free(chain);
        return NULL;
    }

    for(size_t i=0, next=first_cluster; i<chain->size; ++i, next=get_next_cluster(next, buffer)) chain->clusters[i] = next;

    return chain;
}

struct disk_t* disk_open_from_file(const char* volume_file_name){
    if(!volume_file_name){
        errno = EFAULT;
        return NULL;
    }

    struct disk_t* pdisk = malloc(sizeof(struct disk_t));
    if(!pdisk){
        errno = ENOMEM;
        return NULL;
    }

    pdisk->file = fopen(volume_file_name, "rb");
    if(!pdisk->file){
        free(pdisk);
        errno = ENOENT;
        return NULL;
    }

    pdisk->sectors = 0;
    uint8_t buffer[SECTOR_BYTES];
    while(fread(buffer, SECTOR_BYTES, 1, pdisk->file)) pdisk->sectors++;

    return pdisk;
}

int disk_read(struct disk_t* pdisk, int32_t first_sector, void* buffer, int32_t sectors_to_read){
    if(!pdisk || !buffer){
        errno = EFAULT;
        return -1;
    }

    if((uint32_t)(first_sector + sectors_to_read) > pdisk->sectors){
        errno = ERANGE;
        return -1;
    }

    fseek(pdisk->file, first_sector * SECTOR_BYTES, SEEK_SET);
    fread(buffer, SECTOR_BYTES, sectors_to_read, pdisk->file);

    return sectors_to_read;
}

int disk_close(struct disk_t* pdisk){
    if(!pdisk){
        errno = EFAULT;
        return -1;
    }
    fclose(pdisk->file);
    free(pdisk);
    return 0;
}

struct volume_t* fat_open(struct disk_t* pdisk, uint32_t first_sector){
    if(!pdisk){
        errno = EFAULT;
        return NULL;
    }

    struct volume_t *pvolume = calloc(1,sizeof(struct volume_t));
    if(!pvolume){
        free(pvolume);
        errno = ENOMEM;
        return NULL;
    }

    pvolume->pdisk = pdisk;
    if(disk_read(pdisk, (int) first_sector, &pvolume->boot_sector, 1) == -1){
        free(pvolume);
        return NULL;
    }
    if(pvolume->boot_sector.signature != 0xaa55){
        free(pvolume);
        errno = EINVAL;
        return NULL;
    }

    size_t bytes_per_fat = pvolume->boot_sector.bytes_per_sector * pvolume->boot_sector.size_of_fat;
    pvolume->first_fat = malloc(bytes_per_fat);
    pvolume->second_fat = malloc(bytes_per_fat);
    pvolume->root_dir = malloc(sizeof(struct dir_info_t) * pvolume->boot_sector.maximum_number_of_files);

    if(!pvolume->first_fat || !pvolume->second_fat || !pvolume->root_dir){
        if(pvolume->second_fat) free(pvolume->second_fat);
        if(pvolume->first_fat) free(pvolume->first_fat);
        if(pvolume->root_dir) free(pvolume->root_dir);
        free(pvolume);
        errno = ENOMEM;
        return NULL;
    }

    disk_read(pdisk, pvolume->boot_sector.size_of_reserved_area, pvolume->first_fat, pvolume->boot_sector.size_of_fat);
    disk_read(pdisk, pvolume->boot_sector.size_of_reserved_area + pvolume->boot_sector.size_of_fat, pvolume->second_fat, pvolume->boot_sector.size_of_fat);


    if(memcmp(pvolume->first_fat, pvolume->second_fat, pvolume->boot_sector.bytes_per_sector * pvolume->boot_sector.size_of_fat)){
        free(pvolume->first_fat);
        free(pvolume->second_fat);
        free(pvolume->root_dir);
        free(pvolume);
        errno = EINVAL;
        return NULL;
    }

    disk_read(pdisk, pvolume->boot_sector.size_of_reserved_area + pvolume->boot_sector.size_of_fat * 2, pvolume->root_dir, (int) sizeof(struct dir_info_t) * pvolume->boot_sector.maximum_number_of_files / pvolume->boot_sector.bytes_per_sector);

    return pvolume;
}

int fat_close(struct volume_t* pvolume){
    if(!pvolume){
        errno = EFAULT;
        return -1;
    }

    free(pvolume->first_fat);
    free(pvolume->second_fat);
    free(pvolume->root_dir);
    free(pvolume);

    return 0;
}

struct file_t* file_open(struct volume_t* pvolume, const char* file_name){
    if(!pvolume || !file_name){
        errno = EFAULT;
        return NULL;
    }

    struct dir_info_t* root_dir = pvolume->root_dir;
    struct file_t* pfile = malloc(sizeof(struct file_t));
    if(!pfile){
        errno = ENOMEM;
        return NULL;
    }

    bool flag = false;
    char fixedName[11]="           ";

    for(int32_t i=0; i<11; ++i){
        if(file_name[i]=='.'){
            ++i;
            for(int32_t j=8; j<11; ++j, ++i){
                if(file_name[i]=='\0') break;
                fixedName[j]=file_name[i];
            }
            break;
        }
        else if(file_name[i]=='\0') break;
        fixedName[i]=file_name[i];
    }

    for(uint16_t i=0; i<pvolume->boot_sector.maximum_number_of_files; ++i){

        const char *first_word = root_dir->filename, *second_word = fixedName;
        for(int32_t j=0; j<11; ++j) if(first_word[j] != second_word[j]) goto jump;

        if((root_dir->file_attributes & (1 << 4)) >> 4 == 1){
            errno = EISDIR;
            free(pfile);
            return NULL;
        }
        flag = true;
        pfile->info = *root_dir;
        break;

        jump: root_dir++;
    }


    if(!flag){
        errno = ENOENT;
        free(pfile);
        return NULL;
    }

    pfile->current_position = 0;
    pfile->volume = pvolume;

    pfile->clusters_chain = get_chain_fat12(pvolume->first_fat, pvolume->boot_sector.size_of_fat * pvolume->boot_sector.bytes_per_sector, pfile->info.low_order_address_of_first_cluster);

    if(!pfile->clusters_chain){
        free(pfile);
        errno = ENOMEM;
        return NULL;
    }

    return pfile;
}

int32_t file_seek(struct file_t* stream, int32_t offset, int whence){
    if(!stream || stream->volume == NULL || stream->volume->pdisk == NULL){
        errno = EFAULT;
        return -1;
    }

    if(whence == SEEK_SET) stream->current_position = offset;
    else if(whence == SEEK_CUR) stream->current_position += offset;
    else if(whence == SEEK_END) stream->current_position = stream->info.size + offset;
    else{
        errno = EINVAL;
        return -1;
    }

    return 0;
}

size_t file_read(void *ptr, size_t size, size_t nmemb, struct file_t *stream){
    if(!ptr || !stream || size < 1 || nmemb < 1){
        errno = EFAULT;
        return -1;
    }

    int32_t bytes_per_cluster = stream->volume->boot_sector.bytes_per_sector * stream->volume->boot_sector.sectors_per_clusters;
    int8_t *cluster = malloc(bytes_per_cluster);
    if(!cluster){
        errno = ENOMEM;
        return -1;
    }

    int32_t num_cluster;
    int32_t pos_cluster;
    int32_t elements_read = 0;
    int32_t elements_to_read = 0;
    int32_t pos = 0;
    int8_t* tmp = ptr;

    while (1) {
        if(stream->current_position + (unsigned)1 > stream->info.size || elements_read==(int32_t)nmemb) break;

        num_cluster = stream->current_position / bytes_per_cluster;
        int32_t sector = 0;
        sector += (stream->volume->boot_sector.size_of_reserved_area);
        sector += (stream->volume->boot_sector.size_of_fat * stream->volume->boot_sector.number_of_fats);
        sector += (stream->volume->boot_sector.maximum_number_of_files * (int32_t)sizeof(struct dir_info_t) / stream->volume->boot_sector.bytes_per_sector);
        sector += ((stream->clusters_chain->clusters[num_cluster] - 2) * stream->volume->boot_sector.sectors_per_clusters);

        if(disk_read(stream->volume->pdisk, sector, cluster, stream->volume->boot_sector.sectors_per_clusters) == -1){
            errno = ERANGE;
            free(cluster);
            return -1;
        }
        if(elements_to_read){
            pos_cluster = stream->current_position % bytes_per_cluster;
            tmp[pos] = cluster[pos_cluster];
            pos++;
            stream->current_position++;
            elements_to_read--;

            if(!elements_to_read) elements_read++;
        }
        else elements_to_read = (int32_t)size;
    }

    free(cluster);

    return elements_read;
}

int file_close(struct file_t* stream){
    if(stream){
        free(stream->clusters_chain->clusters);
        free(stream->clusters_chain);
        free(stream);
        return 0;
    }else{
        errno = EFAULT;
        return -1;
    }
}

struct dir_t* dir_open(struct volume_t* pvolume, const char* dir_path){
    if(!pvolume || !dir_path){
        errno = EFAULT;
        return NULL;
    }

    if(strcmp("\\", dir_path)){
        errno = ENOENT;
        return NULL;
    }

    // Utworzenie i zainicjalizowanie struktury dir_t
    struct dir_t* pdir = (struct dir_t*)malloc(sizeof(struct dir_t));
    if(!pdir){
        errno = ENOMEM;
        return NULL;
    }

    pdir->data = pvolume->root_dir;
    pdir->REF = false;
    pdir->capacity = pvolume->boot_sector.maximum_number_of_files;
    pdir->position = 0;

    return pdir;
}

int dir_close(struct dir_t* pdir){
    if(pdir){
        free(pdir);
        return 0;
    }else{
        errno = EFAULT;
        return -1;
    }
}

int dir_read(struct dir_t* pdir, struct dir_entry_t* pentry){
    if(!pdir || !pentry){
        errno = EFAULT;
        return -1;
    }

    bool found = false;
    struct dir_info_t *directory=pdir->data;
    while(pdir->position < pdir->capacity){
        if  ((directory[pdir->position].filename[0] != 0x0 &&
            directory[pdir->position].filename[0] != (char)0xe5) &&
            ((directory[pdir->position].size != 0 && pdir->REF == false) ||
            (pdir->REF && directory[pdir->position].size == 0)) &&
            (((directory[pdir->position].file_attributes & (1 << 3)) >> 3) != 1))
            found = true;

        pdir->position++;
        if((pdir->position == pdir->capacity) && !pdir->REF){
            pdir->REF = true;
            pdir->position=0;
        }

        if(found) break;
    }
    if(!found) return 1;

    directory += pdir->position - 1;
    pentry->size = directory->size;

    int32_t j=0;
    for(int32_t i=0; i<11 ;++i, ++j){
        if(directory->filename[i] == ' ' || (i == 8 && directory->filename[i+1] != ' ')){
            if((i == 8 && directory->filename[i+1] != ' ')) i--;
            for(int z=i+1; z<11; z++){
                if(directory->filename[z] != ' '){
                    pentry->name[j++] = '.';
                    for(int32_t k=z; k<11; k++){
                        if(directory->filename[k] == ' ') break;
                        pentry->name[j] = directory->filename[k];
                        j++;
                    }
                    break;
                }
            }
            break;
        }
        pentry->name[j] = directory->filename[i];
    }

    pentry->name[j] = '\0';
    pentry->is_archived = ((directory->file_attributes & (1 << 5)) >> 5) == 1;
    pentry->is_directory = ((directory->file_attributes & (1 << 4)) >> 4) == 1;
    pentry->is_hidden = ((directory->file_attributes & (1 << 1)) >> 1) == 1;
    pentry->is_readonly = ((directory->file_attributes & (1 << 0)) >> 0) == 1;
    pentry->is_system = ((directory->file_attributes & (1 << 2)) >> 2) == 1;

    return 0;
}


