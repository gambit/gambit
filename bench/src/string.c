#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{
        int j, len, n = 500000;
        char *s = NULL, *p;

        if (argc > 1)
                n = atoi(argv[1]);

        for (j = 0; j < 10; j++) {
                free(s);
                s = strdup("abcdef");
                while ((len = strlen(s)) <= n) {
                        p = (char *) malloc(2 * len + 10);
                        sprintf(p, "123%s456%s789", s, s);
                        free(s);
                        s = p;
                        len = strlen(s);
                        p = (char *) malloc(len + 2);
                        strcpy(p, s + len/2);
                        strncat(p + len/2, s, len/2+1);
                        free(s);
                        s = p;
                }
        }
        printf("%d\n", strlen(s));
        return 0;
}
