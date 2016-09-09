#include <stdio.h>

int ack(int m, int n) {
        if (m == 0)
                return n+1;
        else if (n == 0)
                return ack(m-1, 1);
        else
                return ack(m-1, ack(m, n-1));
}

int main(int argc, char **argv)
{
        int m = 3, n = 9;

        if (argc > 1)
                m = atoi(argv[1]);
        if (argc > 2)
                n = atoi(argv[2]);
        printf("%d\n", ack(m, n));
        return 0;
}
