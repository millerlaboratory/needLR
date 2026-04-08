# Make a custom cohort

## To prepare a custom cohort to be used in needLR:

>[!NOTE] 
>We recommend using the following sniffles parameters to call structural variants if creating a cohort to compare to the 1KGP dataset provided as part of needLR. If comparing a custom query cohort to a custom control cohort, this doesn't apply. NeedLR expects the fields SVLEN,SUPPORT,and SVTYPE to be part of the INFO tag and for variants to be genotyped. SVTYPEs are only considered if they are INS,DEL,INV,or BND. If a VCF can be merged with Truvari it likely will work with needLR but using any caller other than sniffles is at this time considered experimental.

The 1KGP dataset was called using Sniffles v 2.6.2

```
        sniffles \
            --input sample.bam \
            --reference hg38_reference.fa \
            --output-rnames \
            --vcf sample.vcf \
            --allow-overwrite \
            --tandem-repeats human_GRCh38_no_alt_analysis_set.trf.bed
```


### 1) Filter
Prepare all of the individual vcfs to include SVs that are >=50bp and are on full-length chromosomes 1-22, X, Y, and M

```
bcftools view -i '(INFO/SVTYPE="BND") || (INFO/SVTYPE="INS" || INFO/SVTYPE="DEL" || INFO/SVTYPE="DUP" || INFO/SVTYPE="INV") && (INFO/SVLEN > 49 || INFO/SVLEN < -49) && GT!="0/0" && GT!="0|0"' -r chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22,chrX,chrY,chrM -o preprocessed.vcf.gz -Oz --write-index=tbi original.vcf
```
### 2) Merge
Merge the preprocessed vcfs using bcftools merge and tabix the output (where sample_path_list.txt is a list of all of the sample vcfs to merge in the order they should be in). This merge only merges exact variant matches and outputs a multisample vcf
```
bcftools merge \
-m none \
--force-samples \
-l sample_path_list.txt \
-Oz -o bcftools_merged.vcf.gz
--write-index=tbi
```

### 3) Truvari
Use Truvari to further merge the bcftools-merged vcf. Below are the parameters used in needLR_v3.5 itself (these can be customized). Sort, gzip, and tabix the Truvari merged output

```
truvari collapse \
-i bcftools_merged.vcf.gz \
-o truvari_merged.vcf \
-c truvari_collapsed.vcf \
-f reference_gemome.fa \
-k common \
-s 50 \
-S 10000000 \
-r 2000 \
-p 0 \
-P 0.2 \
-O 0.2

bcftools sort truvari_merged.vcf > truvari_merged_sorted.vcf

bgzip truvari_merged_sorted.vcf

tabix -p vcf truvari_merged_sorted.vcf.gz
```

### *) Optional
If you wish to combine your control sample set with the 1KGP 500 sample control vcf, you can do another Truvari merge (where sample_path_list2.txt is a file with the full file path to truvari_merged_sorted.vcf.gz and /needLR_v3.5_local/backend_files/UWONT_500_sniffles_2.6.2_preproc2_T31_v4.2.2.vcf.gz) 
>[!NOTE] 
>Ancestry-specific population/allele frequencies will not be output after the 1KGP 500 set is combined with a custom control set. 

```
bcftools merge \
-m none \
--force-samples \
-l sample_path_list2.txt \
-Oz -o bcftools_merged2.vcf.gz \
--write-index=tbi

truvari collapse -i bcftools_merged2.vcf.gz \
-o truvari_merged2.vcf \
-c truvari_collapsed2.vcf \
-f reference_gemome.fa \
-k common \
-s 50 \
-S 10000000 \
-r 2000 \
-p 0 \
-P 0.2 \
-O 0.2

bcftools sort truvari_merged2.vcf > truvari_merged2_sorted.vcf

bgzip truvari_merged2_sorted.vcf

tabix truvari_merged2_sorted.vcf.gz
```