/* display_array.c */
#include <stdio.h>

void display_array(const double *arr, long long count) {
    if (count == 0) {
        puts("(empty)");
        return;
    }
    for (long long i = 0; i < count; ++i) {
        printf("%.5f", arr[i]);
        if (i + 1 < count) putchar(' ');
    }
    putchar('\n');
}

/* convert integer to double; returns double in xmm0 per ABI */
double int_to_double(long long x) {
    return (double)x;
}
