#include <stdio.h>
#include <stdlib.h>
#include <time.h>

FILE *file1;
FILE *file2;

extern double antifactorial();

int main(int argc, char **argv) {
    time_t start, finish;
    start = time(NULL);
    int n;
    if (argc == 3) {
        file1 = fopen(*(argv+1), "r");
        n = fgetc(file1) - '0';
        printf("%d\n", n);
    } else {
        scanf("%d", &n);
    }
    if (n == 0) {
        n = rand()%7 + 6;
    }
    if (n < 6) {
        n = 6;
    } else if (n > 12) {
        n = 12;
    }
    double res = 0;
    for (int j = 0; j < 100000000; ++j) {
        res = 0;
        for (int i = 0; i < n; ++i) {
            res += antifactorial(i);
        }
    }
    finish = time(NULL);
    if (argc == 3) {
        file2 = fopen(*(argv+2), "w");
        fprintf(file2, "%d\n", n);
        fprintf(file2, "%.8f\n", res);
        fprintf(file2, "Time: %.1f", difftime(finish, start));
    } else {
        printf("%.8f\n", res);
        printf("Time: %.1f", difftime(finish, start));
    }
    return 0;
}
