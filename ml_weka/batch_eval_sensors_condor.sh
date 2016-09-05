#!/bin/bash

## CONDOR
func="batch_eval"

num_jobs=200
cnt=0

## DAG
rm tmp.${func}.dag*
echo "" > tmp.${func}.dag


TYPES=("norm.fix")
MONTHS=(201604 201605)
DUPS=(200 0 100)
FEATURES=(10 30 50)
RNG=100
SENSORS=("" "lora_" "light_")
# CLASSIFIER="NaiveBayes"
# CLASSIFIER="C45"
# CLASSIFIER="SVM"
# CLASSIFIERS=("NaiveBayes" "C45" "SVM")
# CLASSIFIERS=("NaiveBayes")
# CLASSIFIERS=("C45")
CLASSIFIERS=("SVM")

NT=${#TYPES[@]}
NM=${#MONTHS[@]}
ND=${#DUPS[@]}
NF=${#FEATURES[@]}
NC=${#CLASSIFIERS[@]}
NS=${#SENSORS[@]}

for (( nci = 0; nci < ${NC}; nci++ )); do
    CLASSIFIER=${CLASSIFIERS[${nci}]}

    for (( nsi = 0; nsi < ${NS}; nsi++ )); do
        SENSOR=${SENSORS[${nsi}]}

        VALID=""
        if [[ ${SENSOR} != "" ]]; then
            VALID=".valid"
        fi


        i=0 ## MONTHS
        j=0 ## DUPS
        t=0 ## TYPES
        for (( i = 0; i < ${NM}; i++ )); do
            FILENAME="weka_${SENSOR}${MONTHS[${i}]}.${TYPES[${t}]}"
            echo "-----------------"
            echo "FILE=${FILENAME}"


            BAL=""
            if [[ ${DUPS[${j}]} > 0 ]]; then
                BAL=".bal${DUPS[${j}]}"
            fi

            echo "  > all"
            # bash eval.sh -C=\"${CLASSIFIER}\" -t="${FILENAME}${VALID}${BAL}" -T="${FILENAME}" -r=${RNG}
            cnt=$((${cnt} + 1))
            echo "bash eval.sh -C=\"${CLASSIFIER}\" -m=\"${MONTHS[${i}]}\" -t=\"${TYPES[${t}]}\" -d=${DUPS[${j}]} -v=\"${VALID}\" -M=\"${MONTHS[${i}]}\" -T=\"${TYPES[${t}]}\" -s=\"${SENSOR}\" -r=${RNG}" > tmp.job${cnt}.sh
            sed "s/CODENAME/tmp.job${cnt}.sh/g; s/JOBNAME/job${cnt}/g" condor.${func}.mother.condor > tmp.job${cnt}.condor
            echo JOB J${cnt} tmp.job${cnt}.condor >> tmp.${func}.dag

            echo "  > FCBF"
            # bash eval.sh -C=\"${CLASSIFIER}\" -E="SymmetricalUncertAttributeSetEval" -S="FCBFSearch" -t="${FILENAME}${VALID}${BAL}" -T="${FILENAME}" -r=${RNG} -N=30
            cnt=$((${cnt} + 1))
            echo "bash eval.sh -C=\"${CLASSIFIER}\" -E=\"SymmetricalUncertAttributeSetEval\" -S=\"FCBFSearch\" -m=\"${MONTHS[${i}]}\" -t=\"${TYPES[${t}]}\" -d=${DUPS[${j}]} -v=\"${VALID}\" -M=\"${MONTHS[${i}]}\" -T=\"${TYPES[${t}]}\" -s=\"${SENSOR}\" -r=${RNG} -N=30" > tmp.job${cnt}.sh
            sed "s/CODENAME/tmp.job${cnt}.sh/g; s/JOBNAME/job${cnt}/g" condor.${func}.mother.condor > tmp.job${cnt}.condor
            echo JOB J${cnt} tmp.job${cnt}.condor >> tmp.${func}.dag

            echo "  > Cfs, BesttFirst"
            # bash eval.sh -C=\"${CLASSIFIER}\" -E="CfsSubsetEval" -S="BestFirst" -t="${FILENAME}${VALID}${BAL}" -T="${FILENAME}" -r=${RNG} -N=30
            cnt=$((${cnt} + 1))
            echo "bash eval.sh -C=\"${CLASSIFIER}\" -E=\"CfsSubsetEval\" -S=\"BestFirst\" -m=\"${MONTHS[${i}]}\" -t=\"${TYPES[${t}]}\" -d=${DUPS[${j}]} -v=\"${VALID}\" -M=\"${MONTHS[${i}]}\" -T=\"${TYPES[${t}]}\" -s=\"${SENSOR}\" -r=${RNG} -N=30" > tmp.job${cnt}.sh
            sed "s/CODENAME/tmp.job${cnt}.sh/g; s/JOBNAME/job${cnt}/g" condor.${func}.mother.condor > tmp.job${cnt}.condor
            echo JOB J${cnt} tmp.job${cnt}.condor >> tmp.${func}.dag

            for (( k = 0; k < ${NF}; k++ )); do
                echo "  > Ranker: ${FEATURES[${k}]}"

                # bash eval.sh -C=\"${CLASSIFIER}\" -E="GainRatioAttributeEval" -S="Ranker" -t="${FILENAME}${VALID}${BAL}" -T="${FILENAME}" -r=${RNG} -N=${FEATURES[${k}]}
                cnt=$((${cnt} + 1))
                echo "bash eval.sh -C=\"${CLASSIFIER}\" -E=\"GainRatioAttributeEval\" -S=\"Ranker\" -m=\"${MONTHS[${i}]}\" -t=\"${TYPES[${t}]}\" -d=${DUPS[${j}]} -v=\"${VALID}\" -M=\"${MONTHS[${i}]}\" -T=\"${TYPES[${t}]}\" -s=\"${SENSOR}\" -r=${RNG} -N=${FEATURES[${k}]}" > tmp.job${cnt}.sh
                sed "s/CODENAME/tmp.job${cnt}.sh/g; s/JOBNAME/job${cnt}/g" condor.${func}.mother.condor > tmp.job${cnt}.condor
                echo JOB J${cnt} tmp.job${cnt}.condor >> tmp.${func}.dag
            done
        done

        ###########
        ## Wrapper -- too slow..
        # bash eval.sh -C=\"${CLASSIFIER}\" -E="WrapperSubsetEval" -S="BestFirst" -t="${FILENAME}${VALID}${BAL}" -T="${FILENAME}" -r=${RNG} -N=30
        ###########



        #######################################################
        ## Varying Duplications
        echo "================================"
        echo "Varying Duplications"

        i=0 ## MONTHS
        j=0 ## DUPS
        t=0 ## TYPES

        FILENAME="weka_${SENSOR}${MONTHS[${i}]}.${TYPES[${t}]}"
        echo "FILE=${FILENAME}"

        for (( j = 1; j < ${ND}; j++ )); do
            BAL=""
            if [[ ${DUPS[${j}]} > 0 ]]; then
                BAL=".bal${DUPS[${j}]}"
            fi

            # bash eval.sh -C=\"${CLASSIFIER}\" -t="${FILENAME}${VALID}${BAL}" -T="${FILENAME}" -r=${RNG}
            cnt=$((${cnt} + 1))
            echo "bash eval.sh -C=\"${CLASSIFIER}\" -m=\"${MONTHS[${i}]}\" -t=\"${TYPES[${t}]}\" -d=${DUPS[${j}]} -v=\"${VALID}\" -M=\"${MONTHS[${i}]}\" -T=\"${TYPES[${t}]}\" -s=\"${SENSOR}\" -r=${RNG}" > tmp.job${cnt}.sh
            sed "s/CODENAME/tmp.job${cnt}.sh/g; s/JOBNAME/job${cnt}/g" condor.${func}.mother.condor > tmp.job${cnt}.condor
            echo JOB J${cnt} tmp.job${cnt}.condor >> tmp.${func}.dag
        done


        #######################################################
        ## Varying Time
        echo "================================"
        echo "Varying Time"

        TRAIN_MONTHS=(201604 201605)
        TEST_MONTHS=(201604 201605)
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

                FILENAME1="weka_${SENSOR}${TRAIN_MONTHS[${m}]}.${TYPES[${t}]}"
                FILENAME2="weka_${SENSOR}${TEST_MONTHS[${n}]}.${TYPES[${t}]}"

                BAL=""
                if [[ ${DUPS[${j}]} > 0 ]]; then
                    BAL=".bal${DUPS[${j}]}"
                fi

                cnt=$((${cnt} + 1))
                echo "bash eval.sh -C=\"${CLASSIFIER}\" -m=\"${TRAIN_MONTHS[${m}]}\" -t=\"${TYPES[${t}]}\" -d=${DUPS[${j}]} -v=\"${VALID}\" -M=\"${TEST_MONTHS[${n}]}\" -T=\"${TYPES[${t}]}\" -s=\"${SENSOR}\" -r=${RNG}" > tmp.job${cnt}.sh
                sed "s/CODENAME/tmp.job${cnt}.sh/g; s/JOBNAME/job${cnt}/g" condor.${func}.mother.condor > tmp.job${cnt}.condor
                echo JOB J${cnt} tmp.job${cnt}.condor >> tmp.${func}.dag
            done
        done

    done
done



echo $cnt / $num_jobs
# condor_submit_dag -maxjobs ${num_jobs} tmp.${func}.dag
condor_submit_dag tmp.${func}.dag
