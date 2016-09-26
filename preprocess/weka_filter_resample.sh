#!/bin/bash

DATA_PATH="../../data/sensor"

## Original Files
FILES=(201504 201505 201506 201507 201508 201509 201510 201511 201512 201601 201604 201605 201608)
## Attach 1
FILE1=(201504 54-5   54-6   54-7   54-8   54-9   54-10  54-11  54-12  54-61  54-64  54-65)
## Attach 2
FILE2=(201505 201506 201507 201508 201509 201510 201511 201512 201601 201604 201605 201608)
## Attach result
FILE3=(54-5   54-6   54-7   54-8   54-9   54-10  54-11  54-12  54-61  54-64  54-65  54-68)
DUPS=(100 200)
SENSORS=("" "lora_" "light_")
## DEBUG
# FILES=(201506  201507)
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
# echo "Remove Attributes"

# for (( i = 0; i < ${N1}; i++ )); do
#     echo "  Month " ${FILES[${i}]}

#     java weka.filters.unsupervised.attribute.Remove \
#             -R 13-15,28-30,34-36,49,64-69,73-84,88-93,103-108 \
#             -i ${DATA_PATH}/weka_${FILES[${i}]}.fix.arff.gz \
#             -o ${DATA_PATH}/weka_${FILES[${i}]}.fix.fltr.arff
#     gzip -f ${DATA_PATH}/weka_${FILES[${i}]}.fix.fltr.arff

#     java weka.filters.unsupervised.attribute.Remove \
#             -R 13-15,28-30,34-36,49,64-69,73-84,88-93,103-108 \
#             -i ${DATA_PATH}/weka_${FILES[${i}]}.norm.fix.arff.gz \
#             -o ${DATA_PATH}/weka_${FILES[${i}]}.norm.fix.fltr.arff
#     gzip -f ${DATA_PATH}/weka_${FILES[${i}]}.norm.fix.fltr.arff
# done


########################################
## Append Magnet Data
########################################
echo "Append Magnet Data"

for (( i = 0; i < ${N2}; i++ )); do
    echo "  " ${FILE1[${i}]}, ${FILE2[${i}]}, ${FILE3[${i}]}

    java weka.core.Instances append \
        ${DATA_PATH}/weka_${FILE1[${i}]}.fix.arff.gz \
        ${DATA_PATH}/weka_${FILE2[${i}]}.fix.arff.gz \
        > ${DATA_PATH}/weka_${FILE3[${i}]}.fix.arff
    gzip -f ${DATA_PATH}/weka_${FILE3[${i}]}.fix.arff


    java weka.core.Instances append \
        ${DATA_PATH}/weka_${FILE1[${i}]}.norm.fix.arff.gz \
        ${DATA_PATH}/weka_${FILE2[${i}]}.norm.fix.arff.gz \
        > ${DATA_PATH}/weka_${FILE3[${i}]}.norm.fix.arff
    gzip -f ${DATA_PATH}/weka_${FILE3[${i}]}.norm.fix.arff

    # java weka.core.Instances append \
    #     ${DATA_PATH}/weka_${FILE1[${i}]}.fix.fltr.arff.gz \
    #     ${DATA_PATH}/weka_${FILE2[${i}]}.fix.fltr.arff.gz \
    #     > ${DATA_PATH}/weka_${FILE3[${i}]}.fix.fltr.arff
    # gzip -f ${DATA_PATH}/weka_${FILE3[${i}]}.fix.fltr.arff

    # java weka.core.Instances append \
    #     ${DATA_PATH}/weka_${FILE1[${i}]}.norm.fix.fltr.arff.gz \
    #     ${DATA_PATH}/weka_${FILE2[${i}]}.norm.fix.fltr.arff.gz \
    #     > ${DATA_PATH}/weka_${FILE3[${i}]}.norm.fix.fltr.arff
    # gzip -f ${DATA_PATH}/weka_${FILE3[${i}]}.norm.fix.fltr.arff
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
            if [[ -e ${FILE_PREFIX}.arff.gz ]]; then
                java weka.filters.supervised.instance.Resample \
                    -i ${FILE_PREFIX}.arff.gz \
                    -o ${FILE_PREFIX}.bal${DUPS[${j}]}.arff \
                    -c last -Z ${DUPS[${j}]} -B 1
                gzip -f ${FILE_PREFIX}.bal${DUPS[${j}]}.arff
            fi

            ## normalized fixed
            FILE_PREFIX="${DATA_PATH}/weka_${SENSORS[${k}]}${FILES[${i}]}.norm.fix"
            if [[ -e ${FILE_PREFIX}.arff.gz ]]; then
                java weka.filters.supervised.instance.Resample \
                    -i ${FILE_PREFIX}.arff.gz \
                    -o ${FILE_PREFIX}.bal${DUPS[${j}]}.arff \
                    -c last -Z ${DUPS[${j}]} -B 1
                gzip -f ${FILE_PREFIX}.bal${DUPS[${j}]}.arff
            fi

            # ## fixed filtered
            # FILE_PREFIX="${DATA_PATH}/weka_${SENSORS[${k}]}${FILES[${i}]}.fix.fltr"
            # if [[ -e ${FILE_PREFIX}.arff.gz ]]; then
            #     java weka.filters.supervised.instance.Resample \
            #         -i ${FILE_PREFIX}.arff.gz \
            #         -o ${FILE_PREFIX}.bal${DUPS[${j}]}.arff \
            #         -c last -Z ${DUPS[${j}]} -B 1
            #     gzip -f ${FILE_PREFIX}.bal${DUPS[${j}]}.arff
            # fi

            # ## normalized fixed filtered
            # FILE_PREFIX="${DATA_PATH}/weka_${SENSORS[${k}]}${FILES[${i}]}.norm.fix.fltr"
            # if [[ -e ${FILE_PREFIX}.arff.gz ]]; then
            #     java weka.filters.supervised.instance.Resample \
            #         -i ${FILE_PREFIX}.arff.gz \
            #         -o ${FILE_PREFIX}.bal${DUPS[${j}]}.arff \
            #         -c last -Z ${DUPS[${j}]} -B 1
            #     gzip -f ${FILE_PREFIX}.bal${DUPS[${j}]}.arff
            # fi

            ## normalized fixed valid
            FILE_PREFIX="${DATA_PATH}/weka_${SENSORS[${k}]}${FILES[${i}]}.norm.fix.valid"
            if [[ -e ${FILE_PREFIX}.arff.gz ]]; then
                java weka.filters.supervised.instance.Resample \
                    -i ${FILE_PREFIX}.arff.gz \
                    -o ${FILE_PREFIX}.bal${DUPS[${j}]}.arff \
                    -c last -Z ${DUPS[${j}]} -B 1
                gzip -f ${FILE_PREFIX}.bal${DUPS[${j}]}.arff
            fi
        done
    done
done

for (( i = 0; i < ${N2}; i++ )); do
    for (( j = 0; j < ${ND}; j++ )); do
        echo "  Month " ${FILE3[${i}]} ", dup =" ${DUPS[${j}]}

        java weka.filters.supervised.instance.Resample \
            -i ${DATA_PATH}/weka_${FILE3[${i}]}.fix.arff.gz \
            -o ${DATA_PATH}/weka_${FILE3[${i}]}.fix.bal${DUPS[${j}]}.arff \
            -c last -Z ${DUPS[${j}]} -B 1
        gzip -f ${DATA_PATH}/weka_${FILE3[${i}]}.fix.bal${DUPS[${j}]}.arff

        java weka.filters.supervised.instance.Resample \
            -i ${DATA_PATH}/weka_${FILE3[${i}]}.norm.fix.arff.gz \
            -o ${DATA_PATH}/weka_${FILE3[${i}]}.norm.fix.bal${DUPS[${j}]}.arff \
            -c last -Z ${DUPS[${j}]} -B 1
        gzip -f ${DATA_PATH}/weka_${FILE3[${i}]}.norm.fix.bal${DUPS[${j}]}.arff

        # java weka.filters.supervised.instance.Resample \
        #     -i ${DATA_PATH}/weka_${FILE3[${i}]}.fix.fltr.arff.gz \
        #     -o ${DATA_PATH}/weka_${FILE3[${i}]}.fix.fltr.bal${DUPS[${j}]}.arff \
        #     -c last -Z ${DUPS[${j}]} -B 1
        # gzip -f ${DATA_PATH}/weka_${FILE3[${i}]}.fix.fltr.bal${DUPS[${j}]}.arff

        # java weka.filters.supervised.instance.Resample \
        #     -i ${DATA_PATH}/weka_${FILE3[${i}]}.norm.fix.fltr.arff.gz \
        #     -o ${DATA_PATH}/weka_${FILE3[${i}]}.norm.fix.fltr.bal${DUPS[${j}]}.arff \
        #     -c last -Z ${DUPS[${j}]} -B 1
        # gzip -f ${DATA_PATH}/weka_${FILE3[${i}]}.norm.fix.fltr.bal${DUPS[${j}]}.arff

    done
done
