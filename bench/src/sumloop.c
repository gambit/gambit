#include <stdio.h>

int main(int argc, char **argv)
{
        int i, sum = 0;
        int n = 100000000;
        if (argc > 1)
                n = atoi(argv[1]);
        for (i = 0; i < n; i++)
                sum++;
        printf("%d\n", sum);
        return 0;
}
