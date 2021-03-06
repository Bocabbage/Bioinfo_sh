#!/usr/bin/bash
# Script: testing.sh
# Description: Do alignment using blast+/blat/usearch
# Update date: 2019/07/10
# Author: Zhuofan Zhang

WORKPATH=/hwfssz1/BIGDATA_COMPUTING/liwenhui/1.Etools/1.SAtools
BLAST=$WORKPATH/1.BLAST/ncbi-blast-2.9.0+/bin
BLAT=$WORKPATH/2.BLAT/bin/x86_64
USEARCH=$WORKPATH/3.USEARCH
DATA=$WORKPATH/TEST-DEMO/Sample-Result
LOG=$WORKPATH/TEST-DEMO/Test-Log
RESULT=$WORKPATH/TEST-DEMO/Align-Results
QUERY=$WORKPATH/TEST-DEMO/Sample-Result/query_mu_fix.fa


#if [ ! -d "$LOG" ];then
#    mkdir $LOG
#fi

if [ ! -d "$RESULT" ];then
    mkdir $RESULT
fi

#### BLAST+ TESTING ####
echo BLAST+ test starts at `date` > $LOG/blast.log && \
#$BLAST/makeblastdb -in $DATA/database.fa -dbtype nucl && \
$BLAST/blastn -query $QUERY -out $RESULT/format6.blast -db $DATA/database.fa \
              -outfmt 6 -evalue 1e-6 -num_threads 10 && \
echo BLAST+ test ends at `date` >> $LOG/blast.log && \
echo "BLAST+ test finished!" > $LOG/blast.sign

#### BLAT TESTING ####
echo BLAT test starts at `date` > $LOG/blat.log && \
$BLAT/blat -oneOff=1 -tileSize=11  $DATA/database.fa $QUERY -out=blast8 $RESULT/result.blat && \
echo BLAT test ends at `date` >> $LOG/blat.log && \
echo "BLAT test finished!" > $LOG/blat.sign

#### USEARCH TESTING ####
echo USEARCH test starts at `date` > $LOG/usearch_local.log && 
$USEARCH/usearch -usearch_local $QUERY -db $DATA/database.fa \
                 -id 0.9 -evalue 1e-2 -blast6out $RESULT/usearch_local.b6 -strand plus \
                 -maxaccepts 100 -maxrejects 50000 && \
echo USEARCH test ends at `date` >> $LOG/usearch_local.log && \
echo "USEARCH test finished!" > $LOG/usearch_local.sign


#echo USEARCH test starts at `date` > $LOG/usearch_global.log &&
#$USEARCH/usearch -usearch_global $DATA/query.fa -db $DATA/database.fa \
#                 -id 0.9 -evalue 1e-6 -blast6out usearch_global.b6 \
#                 -strand plus -maxaccepts 100 -maxrejects 50000 && \
#echo USEARCH test ends at `date` >> $LOG/usearch_global.log && \
#echo "USEARCH test finished!" > $LOG/usearch_global.sign


