#!/usr/bin/env bash
# title:            3_sra2fastq.sh
# recommand usage:  nohup bash 3_sra2fastq.sh > sra2fastq.log 2>&1 &
# author:           Zhuofan Zhang
# date:             2019/5/15
#                   2019/5/31(Add FASTQC for QC)

cd $HOME/zzf
TOOLPATH='./tools'
INPUTPATH='./sra/rna_seq'
OUTPATH='./fastq/rna_seq'
SRA_LIST=(SRR2753135 SRR2753137 SRR2753139 SRR2753140 SRR2753141 SRR2753143)
export PATH=$TOOLPATH:$PATH

if [ ! -d "./fastq" ];then
    mkdir ./fastq
else
    rm ./fastq/*
fi


if [ ! -d "$OUTPATH" ];then
    mkdir $OUTPATH
else
    rm $OUTPATH/*
fi


ls $INPUTPATH/*.sra | while read i; do $TOOLPATH/sratoolkit.2.8.2-1-ubuntu64/bin/fastq-dump --split-3 -O $OUTPATH $i; done

echo "TRANSFORM Finish!"

# Most reads are at the quality level above 25, so we skip the QC step. #
# for sra in "${SRA_LIST[@]}"
# do
#     ./tools/fastp -i $OUTPATH/${sra}_1.fastq -I $OUTPATH/${sra}_2.fastq \
#           -o $OUTPATH/${sra}_1.fastp.fastq -O $OUTPATH/${sra}_2.fastp.fastq \
#           -h $OUTPATH/${sra}.html &
# done
for sra in "${SRA_LIST[@]}"
do
    $TOOLPATH/FastQC/fastqc -o $REPORT -t 10 $OUTPATH/${sra}_1.fastq
    $TOOLPATH/FastQC/fastqc -o $REPORT -t 10 $OUTPATH/${sra}_2.fastq
done
echo "FastQC finish!"

