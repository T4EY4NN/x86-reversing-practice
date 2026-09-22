int main(void) {
    unsigned int value = 0x11223344;
    unsigned char *cp = (unsigned char *)&value;

    *((unsigned short *)cp + 1) = 0xBEEF;

    return value;
}