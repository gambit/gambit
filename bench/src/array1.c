#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
        int i, j, k, n;
        int *ip, *jp;

        if (argc == 1)
                n = 200000;
        else
                n = atoi(argv[1]);

        for (k=0; k<100; k++)
            {
                ip = (int *) malloc(n * sizeof(int));
                jp = (int *) malloc(n * sizeof(int));

                for (i = 0; i < n; i++)
                    ip[i] = i ;
                for (j = n-1; j >= 0; j--)
                    jp[j] = ip[j];
            }
        return 0;
}
