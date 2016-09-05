#!/bin/bash

DATA_PATH="../../data/sensor"

## Original Files
FILES=(201504 201505    201506     201507  201604  201605)
## Attach 1
FILE1=(201504 545    5456   54567   5456764)
## Attach 2
FILE2=(201505 201506 201507 201604  201605)
## Attach result
FILE3=(545    5456   54567  5456764 54567645)
DUPS=(100 200)
SENSORS=("" "lora_" "light_")
# FILES=(201604  201605)
# FILE1=()
# FILE2=()
# FILE3=()
# DUPS=(200)
# SENSORS=("" "lora_" "light_")

N1=${#FILES[@]}
N2=${#FILE1[@]}
ND=${#DUPS[@]}
NS=${#SENSORS[@]}


########################################
## Remove Attributes
########################################
echo "Remove Attributes"

for (( i = 0; i < ${N1}; i++ )); do
    echo "  Month " ${FILES[${i}]}

    java weka.filters.unsupervised.attribute.Remove \
            -R 13-15,28-30,34-36,49,64-69,73-84,88-93,103-108 \
            -i ${DATA_PATH}/weka_${FILES[${i}]}.fix.arff \
            -o ${DATA_PATH}/weka_${FILES[${i}]}.fix.fltr.arff

    java weka.filters.unsupervised.attribute.Remove \
            -R 13-15,28-30,34-36,49,64-69,73-84,88-93,103-108 \
            -i ${DATA_PATH}/weka_${FILES[${i}]}.norm.fix.arff \
            -o ${DATA_PATH}/weka_${FILES[${i}]}.norm.fix.fltr.arff
done


########################################
## Append Magnet Data
########################################
echo "Append Magnet Data"

for (( i = 0; i < ${N2}; i++ )); do
    echo "  " ${FILE1[${i}]}, ${FILE2[${i}]}, ${FILE3[${i}]}

    java weka.core.Instances append \
        ${DATA_PATH}/weka_${FILE1[${i}]}.fix.arff \
        ${DATA_PATH}/weka_${FILE2[${i}]}.fix.arff \
        > ${DATA_PATH}/weka_${FILE3[${i}]}.fix.arff

    java weka.core.Instances append \
        ${DATA_PATH}/weka_${FILE1[${i}]}.norm.fix.arff \
        ${DATA_PATH}/weka_${FILE2[${i}]}.norm.fix.arff \
        > ${DATA_PATH}/weka_${FILE3[${i}]}.norm.fix.arff

    java weka.core.Instances append \
        ${DATA_PATH}/weka_${FILE1[${i}]}.fix.fltr.arff \
        ${DATA_PATH}/weka_${FILE2[${i}]}.fix.fltr.arff \
        > ${DATA_PATH}/weka_${FILE3[${i}]}.fix.fltr.arff

    java weka.core.Instances append \
        ${DATA_PATH}/weka_${FILE1[${i}]}.norm.fix.fltr.arff \
        ${DATA_PATH}/weka_${FILE2[${i}]}.norm.fix.fltr.arff \
        > ${DATA_PATH}/weka_${FILE3[${i}]}.norm.fix.fltr.arff
done


########################################
## Balance
########################################
echo "Balance"

for (( i = 0; i < ${N1}; i++ )); do
    for (( j = 0; j < ${ND}; j++ )); do
        for (( k = 0; k < ${NS}; k++ )); do
            echo "  Sensor " ${SENSORS[${k}]} ", Month " ${FILES[${i}]} ", dup =" ${DUPS[${j}]}

            ## fixed
            FILE_PREFIX="${DATA_PATH}/weka_${SENSORS[${k}]}${FILES[${i}]}.fix"
            if [[ -e ${FILE_PREFIX}.arff ]]; then
                java weka.filters.supervised.instance.Resample \
                    -i ${FILE_PREFIX}.arff \
                    -o ${FILE_PREFIX}.bal${DUPS[${j}]}.arff \
                    -c last -Z ${DUPS[${j}]} -B 1
            fi

            ## normalized fixed
            FILE_PREFIX="${DATA_PATH}/weka_${SENSORS[${k}]}${FILES[${i}]}.norm.fix"
            if [[ -e ${FILE_PREFIX}.arff ]]; then
                java weka.filters.supervised.instance.Resample \
                    -i ${FILE_PREFIX}.arff \
                    -o ${FILE_PREFIX}.bal${DUPS[${j}]}.arff \
                    -c last -Z ${DUPS[${j}]} -B 1
            fi

            ## fixed filtered
            FILE_PREFIX="${DATA_PATH}/weka_${SENSORS[${k}]}${FILES[${i}]}.fix.fltr"
            if [[ -e ${FILE_PREFIX}.arff ]]; then
                java weka.filters.supervised.instance.Resample \
                    -i ${FILE_PREFIX}.arff \
                    -o ${FILE_PREFIX}.bal${DUPS[${j}]}.arff \
                    -c last -Z ${DUPS[${j}]} -B 1
            fi

            ## normalized fixed filtered
            FILE_PREFIX="${DATA_PATH}/weka_${SENSORS[${k}]}${FILES[${i}]}.norm.fix.fltr"
            if [[ -e ${FILE_PREFIX}.arff ]]; then
                java weka.filters.supervised.instance.Resample \
                    -i ${FILE_PREFIX}.arff \
                    -o ${FILE_PREFIX}.bal${DUPS[${j}]}.arff \
                    -c last -Z ${DUPS[${j}]} -B 1
            fi

            ## normalized fixed valid
            FILE_PREFIX="${DATA_PATH}/weka_${SENSORS[${k}]}${FILES[${i}]}.norm.fix.valid"
            if [[ -e ${FILE_PREFIX}.arff ]]; then
                java weka.filters.supervised.instance.Resample \
                    -i ${FILE_PREFIX}.arff \
                    -o ${FILE_PREFIX}.bal${DUPS[${j}]}.arff \
                    -c last -Z ${DUPS[${j}]} -B 1
            fi
        done
    done
done

for (( i = 0; i < ${N2}; i++ )); do
    for (( j = 0; j < ${ND}; j++ )); do
        echo "  Month " ${FILE3[${i}]} ", dup =" ${DUPS[${j}]}

        java weka.filters.supervised.instance.Resample \
            -i ${DATA_PATH}/weka_${FILE3[${i}]}.fix.arff \
            -o ${DATA_PATH}/weka_${FILE3[${i}]}.fix.bal${DUPS[${j}]}.arff \
            -c last -Z ${DUPS[${j}]} -B 1

        java weka.filters.supervised.instance.Resample \
            -i ${DATA_PATH}/weka_${FILE3[${i}]}.norm.fix.arff \
            -o ${DATA_PATH}/weka_${FILE3[${i}]}.norm.fix.bal${DUPS[${j}]}.arff \
            -c last -Z ${DUPS[${j}]} -B 1

        java weka.filters.supervised.instance.Resample \
            -i ${DATA_PATH}/weka_${FILE3[${i}]}.fix.fltr.arff \
            -o ${DATA_PATH}/weka_${FILE3[${i}]}.fix.fltr.bal${DUPS[${j}]}.arff \
            -c last -Z ${DUPS[${j}]} -B 1

        java weka.filters.supervised.instance.Resample \
            -i ${DATA_PATH}/weka_${FILE3[${i}]}.norm.fix.fltr.arff \
            -o ${DATA_PATH}/weka_${FILE3[${i}]}.norm.fix.fltr.bal${DUPS[${j}]}.arff \
            -c last -Z ${DUPS[${j}]} -B 1

    done
done
