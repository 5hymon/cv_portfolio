#ifndef HEAP_H
#define HEAP_H

#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

struct memory_manager_t {
    void *memory_start;
    size_t memory_size;
    struct memory_chunk_t *first_memory_chunk;
    bool init;
};

struct memory_chunk_t {
    struct memory_chunk_t *prev;
    struct memory_chunk_t *next;
    size_t size;
    bool free;
    uint32_t crc;
};

enum pointer_type_t {
    pointer_null,
    pointer_heap_corrupted,
    pointer_control_block,
    pointer_inside_fences,
    pointer_inside_data_block,
    pointer_unallocated,
    pointer_valid
};

enum pointer_type_t get_pointer_type(const void *pointer);

int heap_validate(void);

size_t heap_get_largest_used_block_size(void);

int heap_setup(void);

void heap_clean(void);

void *heap_malloc(size_t size);

void *heap_calloc(size_t number, size_t size);

void *heap_realloc(void* memblock, size_t size);

void heap_free(void* memblock);

#endif