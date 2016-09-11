#include <stdio.h>

#define IN      1    /* inside a word */
#define OUT     0    /* outside a word */

/* count lines, words, and characters in input */
int main(int argc, char *argv[]) {
        int c, nl, nw, nc, state;
        FILE *fp;
        char *infile = "../../src/bib";
        if (argc > 1)
                infile = argv[1];
        fp = fopen(infile, "r");
        if (fp == NULL) {
                fprintf(stderr, "can't open %s\n", infile);
                exit(1);
        }

        state = OUT;
        nl = nw = nc = 0;
        while ((c = getc(fp)) != EOF) {
                ++nc;
                if (c == '\n')
                        ++nl;
                if (c == ' ' || c == '\n' || c == '\t')
                        state = OUT;
                else if (state == OUT) {
                        state = IN;
                        ++nw;
                }
        }
        printf("%d %d %d\n", nl, nw, nc);
        return 0;
}
