#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
        int c;
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
        if (outfp == NULL) {
                fprintf(stderr, "can't open %s\n", outfile);
                exit(1);
        }
        while ((c = getc(infp)) != EOF)
                putc(c, outfp);
        return 0;
}
