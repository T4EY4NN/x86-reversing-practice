__attribute__((noinline))
long inspect(long a, long b, long c,
            long d, long e, long f,
            long g, long h, long i)
{
    volatile long result = g + h + i;
    return result;
}

int main(void) {
    return (int)inspect(
        0x11, 0x22, 0x33,
        0x44, 0x55, 0x66,
        0x77, 0x88, 0x99
    );
}