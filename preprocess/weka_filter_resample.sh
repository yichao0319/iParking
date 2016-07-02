#!/bin/bash

DATA_PATH="../../data/sensor"

# FILE1=(4  45  456  4567 )
# FILE2=(5  6   7    8    )
# FILE3=(45 456 4567 45678)
FILES=(4  5   6   7  201605)
FILE1=(4  45  456)
FILE2=(5  6   7)
FILE3=(45 456 4567)
N1=${#FILES[@]}
N2=${#FILE1[@]}
DUPS=(100 150 200)
ND=${#DUPS[@]}

## Remove Attributes
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


## Append
echo "Append"

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


## unbias
echo "Balance"

for (( i = 0; i < ${N1}; i++ )); do
    for (( j = 0; j < ${ND}; j++ )); do
        echo "  Month " ${FILES[${i}]} ", dup =" ${DUPS[${j}]}

        java weka.filters.supervised.instance.Resample \
            -i ${DATA_PATH}/weka_${FILES[${i}]}.fix.arff \
            -o ${DATA_PATH}/weka_${FILES[${i}]}.fix.bal${DUPS[${j}]}.arff \
            -c last -Z ${DUPS[${j}]} -B 1

        java weka.filters.supervised.instance.Resample \
            -i ${DATA_PATH}/weka_${FILES[${i}]}.norm.fix.arff \
            -o ${DATA_PATH}/weka_${FILES[${i}]}.norm.fix.bal${DUPS[${j}]}.arff \
            -c last -Z ${DUPS[${j}]} -B 1

        java weka.filters.supervised.instance.Resample \
            -i ${DATA_PATH}/weka_${FILES[${i}]}.fix.fltr.arff \
            -o ${DATA_PATH}/weka_${FILES[${i}]}.fix.fltr.bal${DUPS[${j}]}.arff \
            -c last -Z ${DUPS[${j}]} -B 1

        java weka.filters.supervised.instance.Resample \
            -i ${DATA_PATH}/weka_${FILES[${i}]}.norm.fix.fltr.arff \
            -o ${DATA_PATH}/weka_${FILES[${i}]}.norm.fix.fltr.bal${DUPS[${j}]}.arff \
            -c last -Z ${DUPS[${j}]} -B 1

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
