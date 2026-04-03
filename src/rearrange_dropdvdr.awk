#! /bin/awk -f

#expects step, ncontrols, ncohort

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
    totalreads=10 #at end
    qend=9
    if(ncohort>1){
        qstart=7
        qend=qstart+(ncohort*3)-1 #trio=15
    }
    controlstart=qend+1
    controlend=controlstart+(ncontrols*3)-1
    genotypes=11
    OFS="\t"
}
{
    if(ncohort==1){
        tr=$svvarreads+$svrefreads
        $svrefreads=$svrefreads"\t"tr
    }else{
        for (i=qstart;i<=(qend-2);i+=step){
            $(i+1)=""
            $(i+2)=""
        }
    }
    for(i=controlstart;i<=(controlend-2);i+=step){
        $(i+1)=""
        $(i+2)=""
    }
    $2=$2"\t."
    #printf(%s\t%s\t%s\t%s\t%s\t%s",
    #     $chr, $pos, $ref, $alt, $svlen, $svtype, $svgt)
    # Now print the variable columns in a loop
    #for (i = qstart; i <= qend; i += step) {
    #    printf("\t%s", $i)
    #}
    # And print the control variable columns in a loop (gt only)
    #for (i = start; i <= end; i += step) {
    #    printf("\t%s", $i)
    #}
    #printf("\n")
    print $0
}
