#include <stdio.h>

int main(int argc, char *argv[])
{
        double s = 0, d;
        FILE *fp;
        char *infile = "../../src/rn100";
        if (argc > 1)
                infile = argv[1];
        fp = fopen(infile, "r");
        if (fp == NULL) {
                fprintf(stderr, "can't open %s\n", infile);
                exit(1);
        }

        while (fscanf(fp,"%lf", &d) != EOF)
                s += d;
        printf("%f\n", s);
        return 0;
}
