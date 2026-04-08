#! /bin/awk -f

#expects number of samples for each group in the form:
# afr amr eas eur sas

BEGIN{
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
    ctrlgenotypes=13
    OFS="\t"
    
    total_samples=AFR+AMR+EAS+EUR+SAS
    tempall=total_samples+totalreads

    tempamr=afr+1
    tempeas=tempamr+amr
    tempeur=tempeas+east
    tempsas=tempeur+eur
    
    tempafrc=afr+totalreads
    
    tempamrb=tempafrc+1
    tempamrc=tempafrc+amr

    tempeasb=tempamrc+1
    tempeasc=tempafrc+eas

    tempeurb=tempeasc+1
    tempeurc=tempeasc+eur

    tempsasb=temperuc+1
    tempsasc=temperuc+sas
}
{
   substring_AFR = substr($suppvecc, 1, afr)
   substring_AMR = substr($suppvecc, tempamr, amr)
   substring_EAS = substr($suppvecc, tempeas, eas)
   substring_EUR = substr($suppvecc, tempeur, eur)
   substring_SAS = substr($suppvecc, tempsas, sas)
   substring_ALL = substr($suppvecc, 1, total_samples)
   
   ## Count the number of 1s in the substring
   Pop_AFR = gsub("1", "", substring_AFR)
   Pop_AMR = gsub("1", "", substring_AMR)
   Pop_EAS = gsub("1", "", substring_EAS)
   Pop_EUR = gsub("1", "", substring_EUR)
   Pop_SAS = gsub("1", "", substring_SAS)
   Pop_ALL = gsub("1", "", substring_ALL)

  ## 13 is the first column of the control genotypes
   Allele_AFR = 0;
   Allele_AMR = 0;
   Allele_EAS = 0;
   Allele_EUR = 0;
   Allele_SAS = 0;
   Allele_ALL = 0;
   GT_homWT = 0;
   GT_het = 0;
   GT_homVAR = 0;
   for (i = ctrlgenotypes; i <= tempafrc; i++) {
       n = split($i, arr, "");
       for (j = 1; j <=n; j++) {
          if (arr[j] == "1") {
           Allele_AFR++;
       }
     }
   }
   for (i = tempamrb; i <= tempamrc; i++) {
       n = split($i, arr, "");
       for (j = 1; j <=n; j++) {
          if (arr[j] == "1") {
           Allele_AMR++;
       }
     }
   }
   for (i = tempeasb; i <= tempeasc; i++) {
       n = split($i, arr, "");
       for (j = 1; j <=n; j++) {
          if (arr[j] == "1") {
           Allele_EAS++;
       }
     }
   }
   for (i = tempeurb; i <= tempeurc; i++) {
       n = split($i, arr, "");
       for (j = 1; j <=n; j++) {
          if (arr[j] == "1") {
           Allele_EUR++;
       }
     }
   }
   for (i = tempsasb; i <= tempsasc; i++) {
       n = split($i, arr, "");
       for (j = 1; j <=n; j++) {
          if (arr[j] == "1") {
           Allele_SAS++;
       }
     }
   }
   for (i = ctrlgenotypes; i <= tempall; i++) {
      n = split($i, arr, "");
       for (j = 1; j <=n; j++) {
          if (arr[j] == "1") {
           Allele_ALL++;
       }
     }
   }
   for (i = ctrlgenotypes; i <= tempall; i++) {
     if ($i == "./." || $i == ".|." || $i == "0/0" || $i == "0|0") {
           GT_homWT++;
       }
     }
   for (i = ctrlgenotypes; i <= tempall; i++) {
     if ($i == "0/1" || $i == "0|1" || $i == "1/0" || $i == "1|0") {
           GT_het++;
       }
     }
   for (i = ctrlgenotypes; i <= tempall; i++) {
     if ($i == "1/1" || $i == "1|1") {
          GT_homVAR++;
       }
     }

   print $chr, $pos, $tempcol, $ref, $alt, $svlen, $svtype, $suppvecc, $svgt, $svvarreads, $svrefreads, $totalreads, Pop_AFR, Pop_AMR, Pop_EAS, Pop_EUR, Pop_SAS, Pop_ALL, Allele_AFR, Allele_AMR, Allele_EAS, Allele_EUR, Allele_SAS, Allele_ALL, GT_homWT, GT_het, GT_homVAR
}
