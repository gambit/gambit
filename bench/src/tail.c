#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{
        int i, j;
        char buf[5000];
        char **lp = (char **) malloc(100 * sizeof(char *));
        int nbuf = 100;
        FILE *infp;
        FILE *outfp;
        char *infile = "../../src/bib";
        char *outfile = "foo";
        if (argc > 1)
                infile = argv[1];
        if (argc > 2)
                outfile = argv[2];
        infp = fopen(infile, "r");
        if (infp == NULL) {
                fprintf(stderr, "can't open %s\n", infile);
                exit(1);
        }
        outfp = fopen(outfile, "w");
        for (i = 0; fgets(buf, sizeof buf, infp) != NULL; i++) {
                if (i >= nbuf) {
                        nbuf *= 2;
                        lp = (char **) realloc(lp, nbuf * (sizeof(char *)));
                }
                lp[i] = strdup(buf);
        }
        for (j = i-1; j >= 0; j--)
                fprintf(outfp, "%s", lp[j]);
        return 0;
}
