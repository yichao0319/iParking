#!/bin/bash

func="batch_eval"

num_jobs=200
cnt=0
NJ=16

## DAG
rm tmp.${func}.dag*
echo "" > tmp.${func}.dag

for (( i = 0; i <= ${NJ}; i++ )); do
    FILENAME="batch_eval${i}.sh"

    sed "s/XXX/${FILENAME}/g;" condor.${func}.mother.condor > tmp.${FILENAME}.condor

    echo JOB J${cnt} tmp.${FILENAME}.condor >> tmp.${func}.dag
    cnt=$((${cnt} + 1))
done

echo $cnt / $num_jobs
condor_submit_dag -maxjobs ${num_jobs} tmp.${func}.dag
