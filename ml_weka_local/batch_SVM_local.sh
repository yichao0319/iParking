#!/bin/bash

rm all.sh

while getopts m:M option
do
    case "${option}"
    in
    m) trainMonth=${OPTARG};;
    M) testMonth=${OPTARG};;
    esac
done

cnt=0
TYPES=("norm.fix" "fix")
MONTHS_train=(${trainMonth})
MONTHS_test=(${testMonth})
DUPS=(200 0 100)
#DUPS=(10 30 50 70 90)
## 108 * 10%, 20%, 40%, 80%
FEATURES=(11 22 43 86)
RNG=100
CLASSIFIER="LibSVM"


SENSOR=""
VALID=""
if [[ ${SENSOR} != "" ]]; then
    VALID=".valid"
fi

NT=${#TYPES[@]}
NM_t=${#MONTHS_train[@]}
NM_T=${#MONTHS_test[@]}
ND=${#DUPS[@]}
NF=${#FEATURES[@]}
NC=${#CLASSIFIERS[@]}


for (( ti = 0; ti < ${NM_t}; ti++ )); do

    i=0 ## MONTHS
    j=0 ## DUPS
    t=0 ## TYPES
    GRIDSEARCH_FILEPATH="../../data/sensor/SVM_sampling/${MONTHS_train}/gridSearch_bestResult.txt"
    exec < $GRIDSEARCH_FILEPATH
    read line
    cost=${line}
    read line
    gamma=${line}
    echo "cost: ${cost}"
    for (( tj = 0; tj < ${NM_T}; tj++ )); do
        FILENAME="weka_${SENSOR}${MONTHS[${i}]}.${TYPES[${t}]}"
        echo "-----------------"
        echo "FILE=${FILENAME}"


        BAL=""
        if [[ ${DUPS[${j}]} > 0 ]]; then
            BAL=".bal${DUPS[${j}]}"
        fi

        echo "  > all"
        cnt=$((${cnt} + 1))
        echo "bash eval_SVM.sh -C=\"${CLASSIFIER}\" -c=\"${cost}\" -g=\"${gamma}\" -m=\"${MONTHS_train[${ti}]}\" -t=\"${TYPES[${t}]}\" -d=${DUPS[${j}]} -M=\"${MONTHS_test[${tj}]}\" -T=\"${TYPES[${t}]}\" -r=${RNG} -N=108" > tmp.job${cnt}.sh
        echo "./tmp.job${cnt}.sh" >> all.sh



        echo "  > FCBF"
        # bash eval.sh -C=\"${CLASSIFIER}\" -E="SymmetricalUncertAttributeSetEval" -S="FCBFSearch" -t="${FILENAME}${BAL}" -T="${FILENAME}" -r=${RNG} -N=30
        cnt=$((${cnt} + 1))
        echo "bash eval_SVM.sh -C=\"${CLASSIFIER}\" -c=\"${cost}\" -g=\"${gamma}\" -E=\"SymmetricalUncertAttributeSetEval\" -S=\"FCBFSearch\" -m=\"${MONTHS_train[${ti}]}\" -t=\"${TYPES[${t}]}\" -d=${DUPS[${j}]} -M=\"${MONTHS_test[${tj}]}\" -T=\"${TYPES[${t}]}\" -r=${RNG} -N=30" > tmp.job${cnt}.sh
        echo "./tmp.job${cnt}.sh" >> all.sh



        echo "  > Cfs, BesttFirst"
        # bash eval.sh -C=\"${CLASSIFIER}\" -E="CfsSubsetEval" -S="BestFirst" -t="${FILENAME}${BAL}" -T="${FILENAME}" -r=${RNG} -N=30
        cnt=$((${cnt} + 1))
        echo "bash eval_SVM.sh -C=\"${CLASSIFIER}\" -c=\"${cost}\" -g=\"${gamma}\" -E=\"CfsSubsetEval\" -S=\"BestFirst\" -m=\"${MONTHS_train[${ti}]}\" -t=\"${TYPES[${t}]}\" -d=${DUPS[${j}]} -M=\"${MONTHS_test[${tj}]}\" -T=\"${TYPES[${t}]}\" -r=${RNG} -N=30" > tmp.job${cnt}.sh
        echo "./tmp.job${cnt}.sh" >> all.sh


        for (( k = 0; k < ${NF}; k++ )); do
            echo "  > Ranker: ${FEATURES[${k}]}"

            # bash eval.sh -C=\"${CLASSIFIER}\" -E="GainRatioAttributeEval" -S="Ranker" -t="${FILENAME}${BAL}" -T="${FILENAME}" -r=${RNG} -N=${FEATURES[${k}]}
            cnt=$((${cnt} + 1))
            echo "bash eval_SVM.sh -C=\"${CLASSIFIER}\" -c=\"${cost}\" -g=\"${gamma}\" -E=\"GainRatioAttributeEval\" -S=\"Ranker\" -m=\"${MONTHS_train[${ti}]}\" -t=\"${TYPES[${t}]}\" -d=${DUPS[${j}]} -M=\"${MONTHS_test[${tj}]}\" -T=\"${TYPES[${t}]}\" -r=${RNG} -N=${FEATURES[${k}]}" > tmp.job${cnt}.sh
        echo "./tmp.job${cnt}.sh" >> all.sh
        done
    done
done
