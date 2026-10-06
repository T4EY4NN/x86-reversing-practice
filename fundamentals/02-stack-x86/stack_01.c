__attribute__((noinline))
void foo(void)
{
    volatile int x = 0x11223344;
}

int main(void)
{
    foo();
    return 0;
}