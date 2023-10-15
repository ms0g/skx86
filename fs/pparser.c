#include "pparser.h"
#include "config.h"
#include "string.h"
#include "kheap.h"
#include "memory.h"
#include "status.h"

static int pp_path_valid_format(const char* filename) {
    int len = strnlen(filename, SKX86_MAX_PATH);
    return (len >= 3 && isdigit(filename[0])) && memcmp((void*)&filename[1], ":/", 2) == 0;
}

static int pp_get_drive_by_path(const char** path) {
    if (!pp_path_valid_format(*path)) {
        return -EBADPATH;
    }

    int drive_no = tonumericdigit(*path[0]);
    // 0:/test.txt --> test.txt
    *path += 3;

    return drive_no;
}

static struct path_root* pp_create_root(int drive_num) {
    struct path_root* pr = kzalloc(sizeof(struct path_root));
    pr->drive_no = drive_num;
    pr->first = 0;
    return pr;
}

static const char* pp_get_path_part(const char** path) {
    char* res_path_part = kzalloc(SKX86_MAX_PATH);
    int i = 0;

    while (**path != '/' && **path != 0x00) {
        res_path_part[i] = **path;
        *path += 1;
        i++;
    }

    if (**path == '/') {
        *path += 1;
    }

    if (i == 0) {
        kfree((void*)res_path_part);
        res_path_part = 0;
    }

    return res_path_part;
}

struct path_part* pp_parse_path_part(struct path_part* last_part, const char** path) {
    const char* path_part_str = pp_get_path_part(path);
    if (!path_part_str) {
        return 0;
    }

    struct path_part* part = kzalloc(sizeof(struct path_part));
    part->part = path_part_str;
    part->next = 0;

    if (last_part) {
        last_part->next = part;
    }

    return part;
}

void pp_free(struct path_root* root) {
    struct path_part* part = root->first;

    while (part) {
       struct path_part* next_part = part->next;
       kfree((void*)part->part);
       kfree((void*)part);
       part = next_part;
    }

    kfree((void*) root);
    
}

struct path_root* pp_parse(const char* path, const char* current_directory_path) {
    int res = 0;
    const char* tmp_path = path;
    struct path_root* path_root = 0;

    if ( strlen(path) > SKX86_MAX_PATH) {
        goto out;
    }

    res = pp_get_drive_by_path(&tmp_path);
    if (res < 0) {
        goto out;
    }

    path_root = pp_create_root(res);
    if (!path_root) {
        goto out;
    }

    struct path_part* first_part = pp_parse_path_part(NULL, &tmp_path);
    if (!first_part) {
        goto out;
    }

    path_root->first = first_part;
    struct path_part* part = pp_parse_path_part(first_part, &tmp_path);
    while (part) {
        part = pp_parse_path_part(part, &tmp_path);
    }
out:

    return path_root;
}