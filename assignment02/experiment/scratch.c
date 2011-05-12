#include <stdio.h>

int id(int x)
{
    return x;
}

int main(int argc, char *argv[])
{
    int a = 10;
    while (a > 0)
    {
        a = a - 2;
    }

    int d = a;
    printf("d is %ld\n", d);
    return d;
}


