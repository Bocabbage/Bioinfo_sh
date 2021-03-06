# Script: Performance.py
# Description: For calculating the accuracy of different SA-tools.
# Update date: 2019/07/15
# Author: Zhuofan Zhang 

from Bio import SeqIO
import os 
import argparse


def ResultPreProcess(results_path):
    '''
       For Results pre-processing:
       Extract the queries id 
       of those who have the highest scores.
       Parameter: results_path -- the path of result file(s).
       Output:    Text file(s).
       Note that results are blast-format6.
    '''
    pro_results_list=[]
    for result_path in results_path:
        qSeq_list = {}
        with open(result_path,'r') as r:
            path,name = os.path.split(result_path)
            pro_result_path = path + '/pro_'+ name
            with open(pro_result_path,'w+') as w:     
                for line in r.readlines():
                    score,qSeq = line.split('\t')[-1],line.split('\t')[0]
                    if(qSeq not in qSeq_list.keys() or  float(score) > qSeq_list[qSeq][0]):
                        qSeq_list[qSeq]=(float(score),line)
                for filt_result in qSeq_list.keys():
                    w.write(qSeq_list[filt_result][1])
        pro_results_list.append(pro_result_path)
    return pro_results_list

def TrueResultsNum(id_lists,result):
    '''
       For each preprocess-result file(s),
       calculate the 'TRUE-ALIGN-RESULT' nums.
       Parameter: id_lists -- databases' id lists.(list of lists)
                  result   -- One Alignment result.
       Output:    True-ALIGN-RESULT nums, ALL-ALIGN-RESULT nums
    '''
    TrueResult = 0
    with open(result,'r') as r:
       align_num = 0
       for line in r.readlines():
            qSeq,bSeq = line.split('\t')[0:2]
            #print(qSeq,bSeq)
            for id_list in id_lists:
                qIN = qSeq in id_list
                bIN = bSeq in id_list
                #print(int(qIN),int(bIN))
                if (qIN ^ bIN):
                    break
                elif (qIN and bIN):
                    TrueResult += 1
                    break
            align_num += 1
    return TrueResult,align_num

def GetAccuracy(fasta_list,results_list):
    ''' For calculating the accuracy(ratio) of the SA-tools'''
    fasta_parse_list=[]
    TrueResults = []
    for fasta_file in fasta_list:
         fasta_parse_list.append(SeqIO.parse(fasta_file,"fasta"))
    id_lists = []
    for family in fasta_parse_list:
       id_lists.append([seq_record.id for seq_record in family])
    for result in results_list:
         TrueResults.append(TrueResultsNum(id_lists,result))
    return [(x[0]/x[1],x[0],x[1]) for x in TrueResults]    

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--fapath',help='Family Fasta file dir.')
    parser.add_argument('--repath',help='result files dir.')
    args = parser.parse_args()
    #print(args.fapath)
    fasta_list = [ args.fapath + '/' + x for x in os.listdir(args.fapath)]
    results_list = ResultPreProcess([args.repath + '/' + x for x in os.listdir(args.repath)])
    print([os.path.split(x)[1] for x in results_list])
    TrueResults = GetAccuracy(fasta_list,results_list)
    print(TrueResults)


