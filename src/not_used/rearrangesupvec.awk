#! /bin/awk -f

#expects start end step and suppvecc

BEGIN{
    chr=1;
    pos=2;
    ref=3;
    alt=4;
    svlen=5;
    svtype=6;
    svgt=7;
    svvarreads=8;
    svrefreads=9
    totalreads=10
    ctrlgenotypes=11
    OFS="\t"
}
{
    printf("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t",
         $chr, $pos, "temp", $ref, $alt, $svlen, $svtype, $suppvecc, $svgt, $svvarreads, $svrefreads, $totalreads)
    # Now print the variable columns in a loop
    for (i = start; i <= end; i += step) {
        printf("%s\t", $i)
    }
    printf("\n")
}
