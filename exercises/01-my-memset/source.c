#include <stdio.h>

void *my_memset(void *dst, int value, unsigned long count) {
    unsigned char *p = dst;
    for (unsigned long i = 0; i < count; i++) {
        *(p+i) = (unsigned char)value;
    }
    return dst;
}
int main() {
    unsigned char buffer[8] = {0};
    my_memset(buffer, 'A', 8);

    for (int i = 0; i < 8; i++) {
        printf("%02x ", *(buffer+i));
    }
    return 0;
}