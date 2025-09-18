/* driver.c */
#include <stdio.h>

/* manager is assembly and returns a double in xmm0 */
extern double manager(void);

int main(void) {
    puts("Welcome to Arrays of Integers");
    puts("Bought to you by Davielle Gilzean");
    puts("This program will manage your arrays of 64-bit floats");

    double kept = manager();
    printf("Main received %.10f., and will keep it for future use.\n", kept);
    puts("Main will return 0 to the operating system. Bye.");
    return 0;
}
