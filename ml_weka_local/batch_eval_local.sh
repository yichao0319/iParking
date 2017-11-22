#!/bin/bash

cnt=0
TYPES=("norm.fix" "fix")
#MONTHS=(201504 201505 201506 201507 201508 201509 201510 201511 201512 201601 201604 201605 201608 54-5 54-6 54-7 54-8 54-9)
MONTHS=(201509)
#DUPS=(200 0 100)
#DUPS=(10 30 50 70 90)
## 108 * 10%, 20%, 40%, 80%
DUPS=(100)
#FEATURES=(11 22 43 86)
FEATURES=(100)
RNG=100
# CLASSIFIERS=("NaiveBayes" "C45" "SVM")
#CLASSIFIERS=("C45" "NaiveBayes")
# CLASSIFIERS=("NaiveBayes")
# CLASSIFIERS=("C45")
# CLASSIFIERS=("SVM")
CLASSIFIERS=("NaiveBayes")

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


for (( nci = 0; nci < ${NC}; nci++ )); do
    CLASSIFIER=${CLASSIFIERS[${nci}]}

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
        cnt=$((${cnt} + 1))
        echo "bash eval.sh -C=\"${CLASSIFIER}\" -m=\"${MONTHS[${i}]}\" -t=\"${TYPES[${t}]}\" -d=${DUPS[${j}]} -v=\"${VALID}\" -M=\"${MONTHS[${i}]}\" -T=\"${TYPES[${t}]}\" -s=\"${SENSOR}\" -r=${RNG}" > tmp.job${cnt}.sh



        echo "  > FCBF"
        # bash eval.sh -C=\"${CLASSIFIER}\" -E="SymmetricalUncertAttributeSetEval" -S="FCBFSearch" -t="${FILENAME}${BAL}" -T="${FILENAME}" -r=${RNG} -N=30
        cnt=$((${cnt} + 1))
        echo "bash eval.sh -C=\"${CLASSIFIER}\" -E=\"SymmetricalUncertAttributeSetEval\" -S=\"FCBFSearch\" -m=\"${MONTHS[${i}]}\" -t=\"${TYPES[${t}]}\" -d=${DUPS[${j}]} -v=\"${VALID}\" -M=\"${MONTHS[${i}]}\" -T=\"${TYPES[${t}]}\" -s=\"${SENSOR}\" -r=${RNG} -N=30" > tmp.job${cnt}.sh



        echo "  > Cfs, BesttFirst"
        # bash eval.sh -C=\"${CLASSIFIER}\" -E="CfsSubsetEval" -S="BestFirst" -t="${FILENAME}${BAL}" -T="${FILENAME}" -r=${RNG} -N=30
        cnt=$((${cnt} + 1))
        echo "bash eval.sh -C=\"${CLASSIFIER}\" -E=\"CfsSubsetEval\" -S=\"BestFirst\" -m=\"${MONTHS[${i}]}\" -t=\"${TYPES[${t}]}\" -d=${DUPS[${j}]} -v=\"${VALID}\" -M=\"${MONTHS[${i}]}\" -T=\"${TYPES[${t}]}\" -s=\"${SENSOR}\" -r=${RNG} -N=30" > tmp.job${cnt}.sh



        for (( k = 0; k < ${NF}; k++ )); do
            echo "  > Ranker: ${FEATURES[${k}]}"

            # bash eval.sh -C=\"${CLASSIFIER}\" -E="GainRatioAttributeEval" -S="Ranker" -t="${FILENAME}${BAL}" -T="${FILENAME}" -r=${RNG} -N=${FEATURES[${k}]}
            cnt=$((${cnt} + 1))
            echo "bash eval.sh -C=\"${CLASSIFIER}\" -E=\"GainRatioAttributeEval\" -S=\"Ranker\" -m=\"${MONTHS[${i}]}\" -t=\"${TYPES[${t}]}\" -d=${DUPS[${j}]} -v=\"${VALID}\" -M=\"${MONTHS[${i}]}\" -T=\"${TYPES[${t}]}\" -s=\"${SENSOR}\" -r=${RNG} -N=${FEATURES[${k}]}" > tmp.job${cnt}.sh


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

    FILENAME="weka_${SENSOR}${MONTHS[${i}]}.${TYPES[${t}]}"
    echo "FILE=${FILENAME}"

    for (( j = 0; j < ${ND}; j++ )); do
        BAL=""
        if [[ ${DUPS[${j}]} > 0 ]]; then
            BAL=".bal${DUPS[${j}]}"
        fi

        # bash eval.sh -C=\"${CLASSIFIER}\" -t="${FILENAME}${BAL}" -T="${FILENAME}" -r=${RNG}
        cnt=$((${cnt} + 1))
        echo "bash eval.sh -C=\"${CLASSIFIER}\" -m=\"${MONTHS[${i}]}\" -t=\"${TYPES[${t}]}\" -d=${DUPS[${j}]} -v=\"${VALID}\" -M=\"${MONTHS[${i}]}\" -T=\"${TYPES[${t}]}\" -s=\"${SENSOR}\" -r=${RNG}" > tmp.job${cnt}.sh

    done

    #######################################################
    ## Varying Types
    echo "================================"
    echo "Varying Types"

    i=0 ## MONTHS
    j=0 ## DUPS
    t=0 ## TYPES

    for (( t = 0; t < ${NT}; t++ )); do
        FILENAME="weka_${SENSOR}${MONTHS[${i}]}.${TYPES[${t}]}"
        echo "FILE=${FILENAME}"

        BAL=""
        cnt=$((${cnt} + 1))
        echo "bash eval.sh -C=\"${CLASSIFIER}\" -m=\"${MONTHS[${i}]}\" -t=\"${TYPES[${t}]}\" -d=0 -v=\"${VALID}\" -M=\"${MONTHS[${i}]}\" -T=\"${TYPES[${t}]}\" -s=\"${SENSOR}\" -r=${RNG}" > tmp.job${cnt}.sh

        BAL=".bal200"
        cnt=$((${cnt} + 1))
        echo "bash eval.sh -C=\"${CLASSIFIER}\" -m=\"${MONTHS[${i}]}\" -t=\"${TYPES[${t}]}\" -d=200 -v=\"${VALID}\" -M=\"${MONTHS[${i}]}\" -T=\"${TYPES[${t}]}\" -s=\"${SENSOR}\" -r=${RNG}" > tmp.job${cnt}.sh

    done


    #######################################################
    ## Varying Time
    echo "================================"
    echo "Varying Time"

    # TRAIN_MONTHS=(4 5 6 7 45 456 4567)
    # TEST_MONTHS=(4 5 6 7)
    TRAIN_MONTHS=(201509)
    # TRAIN_MONTHS=(201504 201505 201506 201507 201508 201509 201510 201511 201512 201601 201604 201605 201608 54-5 54-6 54-7 54-8 54-9)
    #TEST_MONTHS=(201504 201505 201506 201507 201508 201509 201510 201511 201512 201601 201604 201605 201608)
    TEST_MONTHS=(201509)
    TYPES2=("norm.fix")
    NT1=${#TRAIN_MONTHS[@]}
    NT2=${#TEST_MONTHS[@]}
    NT3=${#TYPES2[@]}


    j=0 ## DUPS
    t=0 ## TYPES

    for (( t = 0; t < ${NT3}; t++ )); do
        for (( m = 0; m < ${NT1}; m++ )); do
            for (( n = 0; n < ${NT2}; n++ )); do

                if [[ ${TRAIN_MONTHS[${m}]} == ${TEST_MONTHS[${n}]} ]]; then
                    if [[ ${TYPES2[${t}]} == ${TYPES[0]} ]]; then
                        ## cross-validation: should have been done above
                        continue
                    fi
                fi
                FILENAME1="weka_${SENSOR}${TRAIN_MONTHS[${m}]}.${TYPES2[${t}]}"
                FILENAME2="weka_${SENSOR}${TEST_MONTHS[${n}]}.${TYPES2[${t}]}"
                BAL=""
                if [[ ${DUPS[${j}]} > 0 ]]; then
                    BAL=".bal${DUPS[${j}]}"
                fi
                cnt=$((${cnt} + 1))
                # echo "bash eval.sh -C=\"${CLASSIFIER}\" -t=\"${FILENAME1}${BAL}\" -T=\"${FILENAME2}\" -r=${RNG}" > tmp.job${cnt}.sh
                echo "bash eval.sh -C=\"${CLASSIFIER}\" -m=\"${TRAIN_MONTHS[${m}]}\" -t=\"${TYPES2[${t}]}\" -d=${DUPS[${j}]} -v=\"${VALID}\" -M=\"${TEST_MONTHS[${n}]}\" -T=\"${TYPES2[${t}]}\" -s=\"${SENSOR}\" -r=${RNG}" > tmp.job${cnt}.sh
            done
        done
    done
done





