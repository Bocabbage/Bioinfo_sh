#!/usr/env/bin bash
# title:            6_homer_anno_motif.sh
# recommand usage:  nohup bash 6_homer_anno_motif.sh > homer_anno_motif.log 2>&1 &
# author:           Zhuofan Zhang
# date:             2019/5/18
#                   2019/5/29(Add SU-ID and divide the samples)
#                   2019/6/2
cd $HOME/zzf

SU_ID=(SU444 SU484 SU496)
INPUTPATH="./callpeaks/Merge"
OUTPATH="./anno_motif"
TOOLPATH="./tools"

export PATH=$TOOLPATH/HOMER/bin:$PATH

# If there is no hg19-anno-ref, you need to install it first:
# perl $TOOLPATH/HOMER/configureHomer.pl -install hg19

if [ ! -d "$OUTPATH" ];then
    mkdir $OUTPATH
else
    rm $OUTPATH/*
fi

for su in "${SU_ID[@]}"
do
    mkdir $OUTPATH/${su}
    annotatePeaks.pl $INPUTPATH/${su}/${su}_merge.bed hg19 > \
                     $OUTPATH/${su}/${su}_merge_peaks.annotated

    mkdir $OUTPATH/${su}/Motif-Finding

    findMotifsGenome.pl $INPUTPATH/${su}/${su}_merge.bed hg19 $OUTPATH/${su}/Motif-Finding
done


echo "Annotated finish! Motif-Finding finish!"