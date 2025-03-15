#include "heap.h"
#include "custom_unistd.h"
#include <string.h>
#include <stdint.h>
#include <stdbool.h>
#include "tested_declarations.h"
#include "rdebug.h"
#include "tested_declarations.h"
#include "rdebug.h"
#include "tested_declarations.h"
#include "rdebug.h"

struct memory_manager_t memory_manager;

enum pointer_type_t get_pointer_type(const void *pointer){
    if(!pointer) return pointer_null;

    size_t str = sizeof(struct memory_manager_t);
    size_t plot = 16;

    for(struct memory_chunk_t *chunk=memory_manager.first_memory_chunk; chunk; chunk=chunk->next){
        uint8_t* ptr = (uint8_t *) pointer;
        uint8_t* chk = (uint8_t *) chunk;
        if(ptr>=chk && ptr<chk+str) return pointer_control_block;
        if(chunk->free && ptr>=chk+str && ptr<chk+str+chunk->size) return pointer_unallocated;
        if(!chunk->free && ptr>=chk+str && ptr<chk+str+plot) return pointer_inside_fences;
        if(!chunk->free && ptr==chk+str+plot) return pointer_valid;
        if(!chunk->free && ptr>chk+str+plot && ptr<chk+str+plot+chunk->size) return pointer_inside_data_block;
        if(!chunk->free && ptr>=chk+str+plot+chunk->size && ptr<chk+str+chunk->size+2*plot) return pointer_inside_fences;
        if(!chunk->free && chunk->next && ptr<(uint8_t*)chunk->next) return pointer_unallocated;
    }
    return pointer_unallocated;
}

size_t heap_get_largest_used_block_size(void){
    if(heap_validate()) return false;

    size_t max = 0;
    for(struct memory_chunk_t* chunk=memory_manager.first_memory_chunk; chunk; chunk=chunk->next) if(!chunk->free && chunk->size>max) max = chunk->size;
    return max;
}

int heap_setup(void){
    if(memory_manager.init) return false;

    memory_manager.memory_start = custom_sbrk(0);
    if(memory_manager.memory_start==(void*)-1) return -1;

    memory_manager.init = true;
    memory_manager.first_memory_chunk = NULL;
    memory_manager.memory_size = 0;

    return false;
}

void heap_clean(void){
    if(!memory_manager.init) return;

    custom_sbrk(-((int)memory_manager.memory_size));

    memory_manager.init = false;
    memory_manager.memory_start = NULL;
    memory_manager.first_memory_chunk = NULL;
    memory_manager.memory_size = 0;
}

int heap_validate(void){
    if(!memory_manager.init) return 2;

    struct memory_chunk_t* chunk = memory_manager.first_memory_chunk;

    for(;chunk; chunk=chunk->next){
        uint8_t* ptr = (uint8_t*) chunk;
        size_t check = 0;
        for(size_t i=1; ptr!=(uint8_t*)&(chunk->crc); i++, ptr++) check += *ptr * i;

        if(chunk->crc!=check) return 3;

        ptr = (uint8_t*)chunk + sizeof(struct memory_chunk_t);
        if(!chunk->free){
            size_t plot = 16;
            for(size_t i=0; i<plot; i++)
                if(*(ptr+i) != '#' || *(ptr+plot+chunk->size+i) != '#') return 1;
        }
    }

    return false;
}

void *heap_malloc(size_t size){
    if(size==0 || heap_validate()) return NULL;

    struct memory_chunk_t* chunk = memory_manager.first_memory_chunk;
    size_t padding = 0, mem_padding = 8, plot = 16;

    for(; chunk; chunk=chunk->next){
        if(chunk->free && chunk->size >= size+2*plot){
            chunk->size = size;
            chunk->free = false;

            uint8_t* ptr = (uint8_t*)chunk;
            size_t check = 0;
            for(int k=1; ptr!=(uint8_t*)&(chunk->crc); k++, ptr++) check += *ptr * k;
            chunk->crc = check;

            memset((uint8_t*)chunk+sizeof(struct memory_chunk_t), '#', plot);
            memset((uint8_t*)chunk+sizeof(struct memory_chunk_t)+plot+chunk->size, '#', plot);
            return (void*)((uint8_t*)chunk+sizeof(struct memory_chunk_t)+plot);
        }

        if(!chunk->next){
            padding = ((size_t)((uint8_t*)memory_manager.memory_start+memory_manager.memory_size))%mem_padding;
            if(padding) padding = mem_padding - padding;
        }
    }

    size_t dif = padding+sizeof(struct memory_chunk_t)+size+2*plot;
    if(custom_sbrk((int)dif)==(void*)-1) return NULL;

    memory_manager.memory_size += dif;
    if(!memory_manager.first_memory_chunk){
        memory_manager.first_memory_chunk = memory_manager.memory_start;
        chunk = memory_manager.first_memory_chunk;
        chunk->prev = NULL;
        chunk->next = NULL;
        chunk->size = size;
        chunk->free = false;

        uint8_t* ptr = (uint8_t*)chunk;
        size_t check = 0;
        for(int k=1; ptr!=(uint8_t*)&(chunk->crc); k++, ptr++) check += *ptr * k;
        chunk->crc = check;
    }else{
        chunk = memory_manager.first_memory_chunk;

        for(;chunk->next;chunk = chunk->next);

        chunk->next = (void*)((uint8_t*)memory_manager.first_memory_chunk+memory_manager.memory_size-dif+padding);

        uint8_t* ptr = (uint8_t*)chunk;
        size_t check = 0;
        for(int k=1; ptr!=(uint8_t*)&(chunk->crc); k++, ptr++) check += *ptr * k;
        chunk->crc = check;

        struct memory_chunk_t *tmp = chunk;
        chunk = chunk->next;
        chunk->prev = tmp;
        chunk->next = NULL;
        chunk->size = size;
        chunk->free = false;

        ptr = (uint8_t*)chunk;
        check = 0;
        for(int k=1; ptr!=(uint8_t*)&(chunk->crc); k++, ptr++) check += *ptr * k;
        chunk->crc = check;
    }

    memset((uint8_t*)chunk+sizeof(struct memory_chunk_t), '#', plot);
    memset((uint8_t*)chunk+sizeof(struct memory_chunk_t)+plot+chunk->size, '#', plot);
    return (void*)((uint8_t*)chunk+sizeof(struct memory_chunk_t)+plot);
}

void *heap_calloc(size_t number, size_t size){
    size *= number;
    void *stack = heap_malloc(size);
    if(!stack) return NULL;
    memset(stack, '\0', size);
    return stack;
}

void *heap_realloc(void* memblock, size_t size){
    if((!memblock && size == 0) || heap_validate() || (get_pointer_type(memblock)!=pointer_valid && get_pointer_type(memblock)!=pointer_null)) return NULL;
    if(!memblock) return heap_malloc(size);
    if(size==0){
        heap_free(memblock);
        return NULL;
    }

    size_t mem_padding = 8, plot = 16, check, dif, sub;
    uint8_t* ptr = NULL;

    struct memory_chunk_t *chunk = (void*)((uint8_t*)memblock-sizeof(struct memory_chunk_t)-plot);

    if(size==chunk->size) return memblock;

    uint8_t *tmp_ptr = (uint8_t*)memblock+chunk->size+plot;
    size_t free_space = chunk->size;

    if(chunk->next) for(;tmp_ptr!=(uint8_t*)chunk->next; free_space++, tmp_ptr++);

    if(size<=free_space){
        chunk->size = size;

        ptr = (uint8_t*)chunk;
        check = 0;
        for(int k=1; ptr!=(uint8_t*)&(chunk->crc); k++, ptr++) check += *ptr * k;
        chunk->crc = check;

        memset((uint8_t*)memblock+chunk->size, '#', plot);
        return memblock;
    }

    dif = ((size_t)((uint8_t*)memblock+size+plot))%mem_padding;
    if(dif) dif = mem_padding-dif;

    sub = size + dif - free_space;
    if(chunk->next && chunk->next->free && chunk->next->size+sizeof(struct memory_chunk_t)>=sub) {
        if(chunk->next->size >= sub){
            struct memory_chunk_t *cnn = chunk->next->next;
            size_t left = chunk->next->size - sub;
            chunk->size = size;

            ptr = (uint8_t*)chunk;
            check = 0;
            for(int k=1; ptr!=(uint8_t*)&(chunk->crc); k++, ptr++) check += *ptr * k;
            chunk->crc = check;

            memset((uint8_t*)memblock+chunk->size, '#', plot);
            struct memory_chunk_t *nc = (void*)((uint8_t*)memblock+chunk->size+plot+dif);
            chunk->next = nc;

            ptr = (uint8_t*)chunk;
            check = 0;
            for(int k=1; ptr != (uint8_t*)&(chunk->crc); k++, ptr++) check += *ptr * k;
            chunk->crc = check;

            nc->next = cnn;
            if(cnn){
                cnn->prev = nc;

                ptr = (uint8_t*)cnn;
                check = 0;
                for(int k=1; ptr!=(uint8_t*)&(cnn->crc); k++, ptr++) check += *ptr * k;
                cnn->crc = check;
            }
            nc->prev = chunk;
            nc->size = left;
            nc->free = true;

            ptr = (uint8_t*)nc;
            check = 0;
            for(int k=1; ptr!=(uint8_t*)&(nc->crc); k++, ptr++) check += *ptr * k;
            nc->crc = check;
        }else{
            chunk->size = size;
            chunk->next=chunk->next->next;

            ptr = (uint8_t*)chunk;
            check = 0;
            for(int k=1; ptr!=(uint8_t*)&(chunk->crc); k++, ptr++) check += *ptr * k;
            chunk->crc = check;

            if(chunk->next){
                chunk->next->prev = chunk;

                ptr = (uint8_t*)chunk->next;
                check = 0;
                for(int k=1; ptr!=(uint8_t*)&(chunk->next->crc); k++, ptr++) check += *ptr * k;
                chunk->next->crc = check;
            }
            memset((uint8_t *)memblock+chunk->size, '#', plot);
        }
    }else if(!chunk->next){
        sub -= dif;
        if(custom_sbrk((int)sub)==(void*)-1) return NULL;

        memory_manager.memory_size += sub;
        chunk->size = size;

        ptr = (uint8_t*)chunk;
        check = 0;
        for(int k=1; ptr!=(uint8_t*)&(chunk->crc); k++, ptr++) check += *ptr * k;
        chunk->crc = check;

        memset((uint8_t*)memblock+chunk->size, '#', plot);
    }else{
        void *stack = heap_malloc(size);
        if(!stack) return NULL;
        memcpy(stack, memblock, chunk->size);
        heap_free(memblock);
        return stack;
    }
    return memblock;
}

void heap_free(void* memblock){
    if(heap_validate() || get_pointer_type(memblock)!=pointer_valid) return;

    size_t plot = 16, check;
    uint8_t* ptr = NULL;
    struct memory_chunk_t *chunk = (void*)((uint8_t*)memblock-sizeof(struct memory_chunk_t)-plot);
    chunk->free = true;


    ptr = (uint8_t*)chunk;
    check = 0;
    for(int k=1; ptr!=(uint8_t*)&(chunk->crc); k++, ptr++) check += *ptr * k;
    chunk->crc = check;

    if(!chunk->next) chunk->size += 2 * plot;
    else{
        size_t size = chunk->size + 2 * plot;
        for(uint8_t *tmp=(uint8_t*)memblock+chunk->size+plot; tmp!=(uint8_t*)chunk->next; tmp++, size++)
        chunk->size = size;
    }

    ptr = (uint8_t*)chunk;
    check = 0;
    for(int k=1; ptr!=(uint8_t*)&(chunk->crc); k++, ptr++) check += *ptr * k;
    chunk->crc = check;

    if(chunk->prev && chunk->prev->free){
        chunk = chunk->prev;
        chunk->size += sizeof(struct memory_chunk_t)+chunk->next->size;
        chunk->next = chunk->next->next;

        ptr = (uint8_t*)chunk;
        check = 0;
        for(int k=1; ptr!=(uint8_t*)&(chunk->crc); k++, ptr++) check += *ptr * k;
        chunk->crc = check;

        if(chunk->next){
            chunk->next->prev = chunk;

            ptr = (uint8_t*)chunk->next;
            check = 0;
            for(int k=1; ptr!=(uint8_t*)&(chunk->next->crc); k++, ptr++) check += *ptr * k;
            chunk->next->crc = check;
        }
    }
    if(chunk->next && chunk->next->free){
        chunk->size += sizeof(struct memory_chunk_t) + chunk->next->size;
        chunk->next = chunk->next->next;

        ptr = (uint8_t*)chunk;
        check = 0;
        for(int k=1; ptr!=(uint8_t*)&(chunk->crc); k++, ptr++) check += *ptr * k;
        chunk->crc = check;

        if(chunk->next){
            chunk->next->prev = chunk;

            ptr = (uint8_t*)chunk->next;
            check = 0;
            for(int k=1; ptr!=(uint8_t*)&(chunk->next->crc); k++, ptr++) check += *ptr * k;
            chunk->next->crc = check;
        }
    }
    if(!chunk->next){
        size_t left = sizeof(struct memory_chunk_t) + chunk->size;
        if(!chunk->prev) memory_manager.first_memory_chunk = NULL;
        else{
            uint8_t *tmp = (uint8_t*)chunk->prev + sizeof(struct memory_chunk_t) + chunk->prev->size + 2 * plot;
            size_t dif = 0;
            for (;tmp!=(uint8_t*)chunk; dif++, tmp++);
            left += dif;
            chunk = chunk->prev;
            chunk->next = NULL;

            ptr = (uint8_t*)chunk;
            check = 0;
            for(int k=1; ptr!=(uint8_t*)&(chunk->crc); k++, ptr++) check += *ptr * k;
            chunk->crc = check;
        }
        custom_sbrk(-((int)left));
        memory_manager.memory_size -= left;
    }
}
int main(){
    return 0;
}


