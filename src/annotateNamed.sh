#!/bin/bash

set -eo pipefail
temp=$(mktemp -u -t annotatenamed.XXXXX)

# no requirements

SERVER="McClintock"
OFS='\t'
GENECOL=17 #this is for vep
infocols="1-"
printheader=1

while getopts "i:o:a:h:F:g:c:" option; do
  case $option in
    i) FILE="$OPTARG" ;;
    g) GENECOL="$OPTARG" ;;
    o) OUTPUT="$OPTARG" ;;
    a) annotation="$OPTARG" ;;
    h) headerline="$OPTARG" ;;
    c) infocols="$OPTARG" ;;
    F) OFS="$OPTARG" ;;
  esac
done


if [[ -z ${FILE+x} ]]
then
    >&2 echo "No file input provided, quitting"
    exit 1
elif [[ -z ${annotation+x} ]]
then
    >&2 echo "No annotation file provided, quitting"
    exit 1
elif [[ -z ${headerline+x} ]]
then
    >&2 echo "no header line provided, using line of input for breaks and omitting header from output"
    headerline=$( head -n1 $annotation | cut -d ',' -f2- | cut -d ',' -f $infocols )
    printheader=0
elif [[ -z ${OUTPUT+x } ]]
then
    >&2 echo "no output provided, outputing to STDOUT"
fi


blankline=$(echo $headerline | sed 's/[A-Za-z0-9_-]/./g' | tr -s '.')



# read annotations into associative array from file

readarray -t genlist < $annotation

declare -A GENEDB



for line in ${genlist[@]:1}
do 
    gene=${line%%,*}
    info=$( echo ${line#*,} | cut -d ',' -f $infocols )
    GENEDB[$gene]=$info
done

dbkeys=${!GENEDB[@]}


if [[ ${OFS} == '\t' ]]
then
    genes=( $(cat $FILE | cut -f $GENECOL ))

else
    genes=( $(cat $FILE | cut -d $OFS -f $GENECOL ))
fi

if [[ $printheader -eq 1 ]]
then
    echo "$headerline" | tr ',' $OFS > $temp.txt
fi

for gene in ${genes[@]}
do
  infoline=${GENEDB[$gene]}
  if [[ $infoline == "" || $gene == "." ]]
  then
      infoline="$blankline"
  fi
  echo $infoline >> $temp.txt
done

if [[ -z ${OUTPUT+x} ]]
then
    paste -d $OFS <(cat $FILE) <(cat $temp.txt | tr ',' $OFS ) | tr -s $OFS
else
    paste -d $OFS <(cat $FILE) <(cat $temp.txt | tr ',' $OFS ) | tr -s $OFS > $OUTPUT
fi

#rm -rf temp.bed
#rm -rf temp.intersect.bed
#rm -rf temp.intersect.2.bed