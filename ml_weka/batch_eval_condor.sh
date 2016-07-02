#!/bin/bash

## CONDOR
func="batch_eval"

num_jobs=200
cnt=0

## DAG
rm tmp.${func}.dag*
echo "" > tmp.${func}.dag


TYPES=("norm.fix.fltr" "fix" "norm.fix" "fix.fltr")
MONTHS=(4567 4 5 6 7 45 456 201605)
DUPS=(200 0 100 150)
FEATURES=(10 30 50)
RNG=100
CLASSIFIER="NaiveBayes"
# CLASSIFIER="C45"
# CLASSIFIER="SVM"

NT=${#TYPES[@]}
NM=${#MONTHS[@]}
ND=${#DUPS[@]}
NF=${#FEATURES[@]}


i=0 ## MONTHS
j=0 ## DUPS
t=0 ## TYPES
for (( i = 0; i < ${NM}; i++ )); do
    FILENAME="weka_${MONTHS[${i}]}.${TYPES[${t}]}"
    echo "-----------------"
    echo "FILE=${FILENAME}"


    BAL=""
    if [[ ${DUPS[${j}]} > 0 ]]; then
        BAL=".bal${DUPS[${j}]}"
    fi

    echo "  > all"
    # bash eval.sh -C=\"${CLASSIFIER}\" -t="${FILENAME}${BAL}" -T="${FILENAME}" -r=${RNG}
    cnt=$((${cnt} + 1))
    echo "bash eval.sh -C=\"${CLASSIFIER}\" -t=\"${FILENAME}${BAL}\" -T=\"${FILENAME}\" -r=${RNG}" > tmp.job${cnt}.sh
    sed "s/CODENAME/tmp.job${cnt}.sh/g; s/JOBNAME/job${cnt}/g" condor.${func}.mother.condor > tmp.job${cnt}.condor
    echo JOB J${cnt} tmp.job${cnt}.condor >> tmp.${func}.dag

    echo "  > FCBF"
    # bash eval.sh -C=\"${CLASSIFIER}\" -E="SymmetricalUncertAttributeSetEval" -S="FCBFSearch" -t="${FILENAME}${BAL}" -T="${FILENAME}" -r=${RNG} -N=30
    cnt=$((${cnt} + 1))
    echo "bash eval.sh -C=\"${CLASSIFIER}\" -E=\"SymmetricalUncertAttributeSetEval\" -S=\"FCBFSearch\" -t=\"${FILENAME}${BAL}\" -T=\"${FILENAME}\" -r=${RNG} -N=30" > tmp.job${cnt}.sh
    sed "s/CODENAME/tmp.job${cnt}.sh/g; s/JOBNAME/job${cnt}/g" condor.${func}.mother.condor > tmp.job${cnt}.condor
    echo JOB J${cnt} tmp.job${cnt}.condor >> tmp.${func}.dag

    echo "  > Cfs, BesttFirst"
    # bash eval.sh -C=\"${CLASSIFIER}\" -E="CfsSubsetEval" -S="BestFirst" -t="${FILENAME}${BAL}" -T="${FILENAME}" -r=${RNG} -N=30
    cnt=$((${cnt} + 1))
    echo "bash eval.sh -C=\"${CLASSIFIER}\" -E=\"CfsSubsetEval\" -S=\"BestFirst\" -t=\"${FILENAME}${BAL}\" -T=\"${FILENAME}\" -r=${RNG} -N=30" > tmp.job${cnt}.sh
    sed "s/CODENAME/tmp.job${cnt}.sh/g; s/JOBNAME/job${cnt}/g" condor.${func}.mother.condor > tmp.job${cnt}.condor
    echo JOB J${cnt} tmp.job${cnt}.condor >> tmp.${func}.dag

    for (( k = 0; k < ${NF}; k++ )); do
        echo "  > Ranker: ${FEATURES[${k}]}"

        # bash eval.sh -C=\"${CLASSIFIER}\" -E="GainRatioAttributeEval" -S="Ranker" -t="${FILENAME}${BAL}" -T="${FILENAME}" -r=${RNG} -N=${FEATURES[${k}]}
        cnt=$((${cnt} + 1))
        echo "bash eval.sh -C=\"${CLASSIFIER}\" -E=\"GainRatioAttributeEval\" -S=\"Ranker\" -t=\"${FILENAME}${BAL}\" -T=\"${FILENAME}\" -r=${RNG} -N=${FEATURES[${k}]}" > tmp.job${cnt}.sh
        sed "s/CODENAME/tmp.job${cnt}.sh/g; s/JOBNAME/job${cnt}/g" condor.${func}.mother.condor > tmp.job${cnt}.condor
        echo JOB J${cnt} tmp.job${cnt}.condor >> tmp.${func}.dag
    done
done

###########
## Wrapper -- too slow..
# bash eval.sh -C=\"${CLASSIFIER}\" -E="WrapperSubsetEval" -S="BestFirst" -t="${FILENAME}${BAL}" -T="${FILENAME}" -r=${RNG} -N=30
###########



#######################################################
## Varying Duplications
echo "================================"
echo "Varying Duplications"

i=0 ## MONTHS
j=0 ## DUPS
t=0 ## TYPES

FILENAME="weka_${MONTHS[${i}]}.${TYPES[${t}]}"
echo "FILE=${FILENAME}"

for (( j = 1; j < ${ND}; j++ )); do
    BAL=""
    if [[ ${DUPS[${j}]} > 0 ]]; then
        BAL=".bal${DUPS[${j}]}"
    fi

    # bash eval.sh -C=\"${CLASSIFIER}\" -t="${FILENAME}${BAL}" -T="${FILENAME}" -r=${RNG}
    cnt=$((${cnt} + 1))
    echo "bash eval.sh -C=\"${CLASSIFIER}\" -t=\"${FILENAME}${BAL}\" -T=\"${FILENAME}\" -r=${RNG}" > tmp.job${cnt}.sh
    sed "s/CODENAME/tmp.job${cnt}.sh/g; s/JOBNAME/job${cnt}/g" condor.${func}.mother.condor > tmp.job${cnt}.condor
    echo JOB J${cnt} tmp.job${cnt}.condor >> tmp.${func}.dag
done


#######################################################
## Varying Types
echo "================================"
echo "Varying Types"

i=0 ## MONTHS
j=0 ## DUPS
t=0 ## TYPES

for (( t = 1; t < ${NT}; t++ )); do
    FILENAME="weka_${MONTHS[${i}]}.${TYPES[${t}]}"
    echo "FILE=${FILENAME}"

    BAL=""
    cnt=$((${cnt} + 1))
    echo "bash eval.sh -C=\"${CLASSIFIER}\" -t=\"${FILENAME}${BAL}\" -T=\"${FILENAME}\" -r=${RNG}" > tmp.job${cnt}.sh
    sed "s/CODENAME/tmp.job${cnt}.sh/g; s/JOBNAME/job${cnt}/g" condor.${func}.mother.condor > tmp.job${cnt}.condor
    echo JOB J${cnt} tmp.job${cnt}.condor >> tmp.${func}.dag

    BAL=".bal200"
    cnt=$((${cnt} + 1))
    echo "bash eval.sh -C=\"${CLASSIFIER}\" -t=\"${FILENAME}${BAL}\" -T=\"${FILENAME}\" -r=${RNG}" > tmp.job${cnt}.sh
    sed "s/CODENAME/tmp.job${cnt}.sh/g; s/JOBNAME/job${cnt}/g" condor.${func}.mother.condor > tmp.job${cnt}.condor
    echo JOB J${cnt} tmp.job${cnt}.condor >> tmp.${func}.dag
done


#######################################################
## Varying Time
echo "================================"
echo "Varying Time"

TRAIN_MONTHS=(4 5 6 7 45 456 4567)
TEST_MONTHS=(4 5 6 7)
NT1=${#TRAIN_MONTHS[@]}
NT2=${#TEST_MONTHS[@]}

j=0 ## DUPS
t=0 ## TYPES

# for mon in 4 5 6 7 8; do
for (( m = 0; m < ${NT1}; m++ )); do
    for (( n = 0; n < ${NT2}; n++ )); do

        if [[ ${TRAIN_MONTHS[${m}]} == ${TEST_MONTHS[${n}]} ]]; then
            ## cross-validation: should have been done above
            continue
        fi

        FILENAME1="weka_${TRAIN_MONTHS[${m}]}.${TYPES[${t}]}"
        FILENAME2="weka_${TEST_MONTHS[${n}]}.${TYPES[${t}]}"

        BAL=""
        if [[ ${DUPS[${j}]} > 0 ]]; then
            BAL=".bal${DUPS[${j}]}"
        fi

        # bash eval.sh -C=\"${CLASSIFIER}\" -t="weka_4.norm.fix.fltr.bal200" \
        #     -T="weka_${SIN_MONTHS[${i}]}.norm.fix.fltr" -r=${RNG}
        # bash eval.sh -C=\"${CLASSIFIER}\" -t="weka_45.norm.fix.fltr.bal200" \
        #     -T="weka_${SIN_MONTHS[${i}]}.norm.fix.fltr" -r=${RNG}
        # bash eval.sh -C=\"${CLASSIFIER}\" -t="weka_456.norm.fix.fltr.bal200" \
        #     -T="weka_${SIN_MONTHS[${i}]}.norm.fix.fltr" -r=${RNG}
        # bash eval.sh -C=\"${CLASSIFIER}\" -t="weka_4567.norm.fix.fltr.bal200" \
        #     -T="weka_${SIN_MONTHS[${i}]}.norm.fix.fltr" -r=${RNG}
        # bash eval.sh -C=\"${CLASSIFIER}\" -t="weka_45678.norm.fix.fltr.bal200" \
        #     -T="weka_${SIN_MONTHS[${i}]}.norm.fix.fltr" -r=${RNG}
        cnt=$((${cnt} + 1))
        echo "bash eval.sh -C=\"${CLASSIFIER}\" -t=\"${FILENAME1}${BAL}\" -T=\"${FILENAME2}\" -r=${RNG}" > tmp.job${cnt}.sh
        sed "s/CODENAME/tmp.job${cnt}.sh/g; s/JOBNAME/job${cnt}/g" condor.${func}.mother.condor > tmp.job${cnt}.condor
        echo JOB J${cnt} tmp.job${cnt}.condor >> tmp.${func}.dag
    done
done



echo $cnt / $num_jobs
# condor_submit_dag -maxjobs ${num_jobs} tmp.${func}.dag
condor_submit_dag tmp.${func}.dag
