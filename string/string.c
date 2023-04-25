#include "string.h"

int strlen(const char* ptr) {
    int i = 0;
    while (*ptr++ != 0) {
       i++;
    }
    return i;
}

int strnlen(const char* ptr, int max) {
    int i = 0;
    for (; i < max; i++) {
       if (ptr[i] == 0)
        break;
    }
    
    return i;
}

bool isdigit(char c) {
    return c >= 48 && c <= 57;
}

int tonumericdigit(char c) {
    return c - 48;
}