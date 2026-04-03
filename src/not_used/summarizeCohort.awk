#! /bin/awk -f

#expects ncontrols, ncohort, step (for cohort, not controls), controlcounts

BEGIN{
    nsubpops=split(controlcounts, pop_totals,  ",");
    chr=1;
    pos=2;
    tempcol=3;
    ref=4;
    alt=5;
    svlen=6;
    svtype=7;
    suppvecc=8;
    svgt=9;
    svvarreads=10;
    svrefreads=11
    totalreads=12
    sample_col_end=12
    if(ncohort>1){
      qsupportvec=8
      suppvecc=9
      cohort_start=10
      cohort_end=cohort_start+(ncohort*step)-1
      cohort_pop=cohort_end+1
      cohort_pop_freq=cohort_end+2
      cohort_allele=cohort_end+3
      cohort_allele_freq=cohort_end+4
      gt_coh_homwt=cohort_end+5
      gt_coh_het=cohort_end+6
      gt_coh_homvar=cohort_end+7
      sample_col_end=gt_coh_homvar
    }
    pop_control_start=sample_col_end+1
    pop_control_end=pop_control_start+(ncontrols)-1
    subpop_start=pop_control_end+1
    subpop_end=subpop_start+(nsubpops*2)-1
    pop_all=subpop_end+1
    pop_all_freq=subpop_end+2
    subpop_allele_start=pop_all_freq+1
    subpop_allele_end=subpop_allele_start+(nsubpops*2)-1
    allele_all=subpop_allele_end+1
    allele_all_freq=subpop_allele_end+2
    
    
    OFS="\t"
}
NR==1{
    gt_homwt=NF-8
    gt_het=NF-7
    gt_homvar=NF-6
    hwe_p=NF-5
    hwe_q=NF-4
    hwe_bin=NF-3
}
{
    if(ncohort>1){
        for(i=$cohort_start;i<=$cohort_end;i++){
            $i=""
        }
    }else{
        for(i=$pop_control_start;i<=$pop_control_end;i++){
            $i=""
        }
    }
    print $0
}
