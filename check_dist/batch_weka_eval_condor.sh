#!/bin/bash

## CONDOR
func="batch_weka_eval"

num_jobs=50
cnt=0

## DAG
rm tmp.${func}.dag*
echo "" > tmp.${func}.dag


TYPES=("norm.fix")
# SCORES=("s1.combine" "s1.stable" "s2.combine" "s2.stable" "s3.combine" "s3.stable" "s4.combine" "s4.stable")
SCORES=("s1.stable" "s2.stable" "s3.stable" "s4.stable")
MONTHS=(201504 201505 201506 201507 201508 201509 201510 201511 201512 201601 201604 201605 201608)
DUPS=(200 0)
FEATURES=(11 22 43 86 108)
RNG=100
# CLASSIFIER="NaiveBayes"
# CLASSIFIER="C45"
# CLASSIFIER="SVM"
# CLASSIFIERS=("NaiveBayes" "C45" "SVM")
CLASSIFIERS=("C45" "NaiveBayes")
# CLASSIFIERS=("NaiveBayes")
# CLASSIFIERS=("C45")
# CLASSIFIERS=("SVM")
# CLASSIFIERS=("LIBSVM")
SENSOR=""
VALID=""
if [[ ${SENSOR} != "" ]]; then
    VALID=".valid"
fi

NT=${#TYPES[@]}
NM=${#MONTHS[@]}
ND=${#DUPS[@]}
NF=${#FEATURES[@]}
NC=${#CLASSIFIERS[@]}
NS=${#SCORES[@]}


for (( nci = 0; nci < ${NC}; nci++ )); do
  CLASSIFIER=${CLASSIFIERS[${nci}]}

  for (( ti = 0; ti < ${NT}; ti++ )); do
    TYPE=${TYPES[${ti}]}

    for (( si = 0; si < ${NS}; si++ )); do
      SCORE=${SCORES[${si}]}

      for (( di = 0; di < ${ND}; di++ )); do
        DUP=${DUPS[${di}]}

        for (( fi = 0; fi < ${NF}; fi++ )); do
          FEATURE=${FEATURES[${fi}]}

          for (( mi = 0; mi < ${NM}; mi++ )); do
            MON1=${MONTHS[${mi}]}

            for (( mj = 0; mj < ${NM}; mj++ )); do
              MON2=${MONTHS[${mj}]}

              cnt=$((${cnt} + 1))

              echo "bash weka_eval.sh -C=\"${CLASSIFIER}\" -m=\"${MON1}\" -t=\"${TYPE}\" -v=\"${VALID}\" -d=${DUP} -M=\"${MON2}\" -s=\"${SENSOR}\" -S=\"${SCORE}\" -r=${RNG} -N=${FEATURE}" > tmp.job${cnt}.sh
              sed "s/CODENAME/tmp.job${cnt}.sh/g; s/JOBNAME/job${cnt}/g" condor.${func}.mother.condor > tmp.job${cnt}.condor
              echo JOB J${cnt} tmp.job${cnt}.condor >> tmp.${func}.dag

            done
          done
        done
      done
    done
  done
done


echo $cnt / $num_jobs
condor_submit_dag -maxjobs ${num_jobs} tmp.${func}.dag
# condor_submit_dag tmp.${func}.dag
