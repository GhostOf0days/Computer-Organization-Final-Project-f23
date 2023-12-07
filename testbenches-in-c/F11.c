#include <stdio.h>

int main() {
    int first = 0, second = 1, next = 0, i = 2;

    for (i = 2; i <= 11; i++) {
        next = first + second;
        first = second;
        second = next;
    }

    printf("F11 is %d\n", second);
    return 0;
}