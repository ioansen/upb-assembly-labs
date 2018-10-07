#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

int main ()
{
    int v[] = {21, 45, 67, 98, 12, 87, 32};
    int i = 0, n = 7, max = -6000;

loop_start:
    if (v[i] >= max)
        max =v[i];
    i++;
    if (i < n)
        goto loop_start;

    printf("max is %d\n", max);
    return 0;
}