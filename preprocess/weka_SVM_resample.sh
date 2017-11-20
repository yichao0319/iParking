#!/bin/bash

DATA_PATH="../../data/sensor"
OUTPUT_PATH="../../data/sensor/SVM_sampling"
## Original Files
FILES=$1
DUPS=$2

SENSORS=""


#######################################
## Remove Attributes
########################################
echo "Remove Attributes"

echo "  Month " ${FILES}

java -classpath ../../../weka-3-8-0/weka.jar weka.filters.unsupervised.attribute.Remove \
        -R 13-15,28-30,34-36,49,64-69,73-84,88-93,103-108 \
        -i ${DATA_PATH}/weka_${FILES}.fix.arff.gz \
        -o ${OUTPUT_PATH}/weka_${FILES}.fix.fltr.arff
gzip -f ${OUTPUT_PATH}/weka_${FILES}.fix.fltr.arff

java -classpath ../../../weka-3-8-0/weka.jar weka.filters.unsupervised.attribute.Remove \
        -R 13-15,28-30,34-36,49,64-69,73-84,88-93,103-108 \
        -i ${DATA_PATH}/weka_${FILES}.norm.fix.arff.gz \
        -o ${OUTPUT_PATH}/weka_${FILES}.norm.fix.fltr.arff
gzip -f ${OUTPUT_PATH}/weka_${FILES}.norm.fix.fltr.arff


########################################
## Balance
########################################
echo "Balance"

echo "  Sensor " ${SENSORS} ", Month " ${FILES} ", dup =" ${DUPS}
            
echo "   file type: .fix"
## fixed
FILE_PREFIX="${DATA_PATH}/weka_${SENSORS}${FILES}.fix"

if [[ -e ${FILE_PREFIX}.arff.gz ]]; then
   java -classpath /home/intel_parking/weka-3-8-0/weka.jar weka.filters.supervised.instance.Resample \
   -i ${FILE_PREFIX}.arff.gz \
   -o ${FILE_PREFIX}.sample${DUPS}.arff \
   -c last -Z ${DUPS} -B 0
   gzip -f ${FILE_PREFIX}.sample${DUPS}.arff
fi

FILE_PREFIX="${DATA_PATH}/weka_${SENSORS}${FILES}.fix.sample${DUPS}"
OUTPUT_FILE_PREFIX="${OUTPUT_PATH}/weka_${SENSORS}${FILES}.fix.sample${DUPS}"
if [[ -e ${FILE_PREFIX}.arff.gz ]]; then
   java -classpath /home/intel_parking/weka-3-8-0/weka.jar weka.filters.supervised.instance.Resample \
   -i ${FILE_PREFIX}.arff.gz \
   -o ${OUTPUT_FILE_PREFIX}.balance.arff \
   -c last -B 1
   gzip -f ${OUTPUT_FILE_PREFIX}.balance.arff
fi

echo "  file type: .norm.fix"
## normalized fixed
FILE_PREFIX="${DATA_PATH}/weka_${SENSORS}${FILES}.norm.fix"
if [[ -e ${FILE_PREFIX}.arff.gz ]]; then
    java -classpath /home/intel_parking/weka-3-8-0/weka.jar weka.filters.supervised.instance.Resample \
    -i ${FILE_PREFIX}.arff.gz \
    -o ${FILE_PREFIX}.sample${DUPS}.arff \
    -c last -Z ${DUPS} -B 0
    gzip -f ${FILE_PREFIX}.sample${DUPS}.arff
fi
FILE_PREFIX="${DATA_PATH}/weka_${SENSORS}${FILES}.norm.fix.sample${DUPS}"
OUTPUT_FILE_PREIFX="${OUTPUT_PATH}/weka_${SENSORS}${FILES}.norm.fix.sample${DUPS}"
if [[ -e ${FILE_PREFIX}.arff.gz ]]; then
    java -classpath /home/intel_parking/weka-3-8-0/weka.jar weka.filters.supervised.instance.Resample \
    -i ${FILE_PREFIX}.arff.gz \
    -o ${OUTPUT_FILE_PREFIX}.balance.arff \
    -c last -B 1
    gzip -f ${OUTPUT_FILE_PREFIX}.balance.arff
fi



echo "  file type: .fix.fltr"
## fixed filtered
FILE_PREFIX="${DATA_PATH}/weka_${SENSORS}${FILES}.fix.fltr"

if [[ -e ${FILE_PREFIX}.arff.gz ]]; then
    java -classpath ../../../weka-3-8-0/weka.jar weka.filters.supervised.instance.Resample \
    -i ${FILE_PREFIX}.arff.gz \
    -o ${FILE_PREFIX}.sample${DUPS}.arff \
    -c last -Z ${DUPS} -B 0
    gzip -f ${FILE_PREFIX}.sample${DUPS}.arff
fi
FILE_PREFIX="${DATA_PATH}/weka_${SENSORS}${FILES}.fix.fltr.sample${DUPS}"
OUTPUT_FILE_PREFIX="${OUTPUT_PATH}/weka_${SENSORS}${FILES}.fix.fltr.sample${DUPS}"
if [[ -e ${FILE_PREFIX}.arff.gz ]]; then
    java -classpath /home/intel_parking/weka-3-8-0/weka.jar weka.filters.supervised.instance.Resample \
    -i ${FILE_PREFIX}.arff.gz \
    -o ${OUTPUT_FILE_PREFIX}.balance.arff \
    -c last -B 1
    gzip -f ${OUTPUT_FILE_PREFIX}.balance.arff
fi
             

echo "  file type: .norm.fix.fltr"
## normalized fixed filtered
FILE_PREFIX="${DATA_PATH}/weka_${SENSORS}${FILES}.norm.fix.fltr"
if [[ -e ${FILE_PREFIX}.arff.gz ]]; then
    java -classpath ../../../weka-3-8-0/weka.jar weka.filters.supervised.instance.Resample \
    -i ${FILE_PREFIX}.arff.gz \
    -o ${FILE_PREFIX}.sample${DUPS}.arff \
    -c last -Z ${DUPS} -B 0
    gzip -f ${FILE_PREFIX}.sample${DUPS}.arff
fi
FILE_PREFIX="${DATA_PATH}/weka_${SENSORS}${FILES}.norm.fix.fltr.sample${DUPS}"
OUTPUT_FILE_PREFIX="${OUTPUT_PATH}/weka_${SENSORS}${FILES}.norm.fix.fltr.sample${DUPS}"
if [[ -e ${FILE_PREFIX}.arff.gz ]]; then
    java -classpath /home/intel_parking/weka-3-8-0/weka.jar weka.filters.supervised.instance.Resample \
    -i ${FILE_PREFIX}.arff.gz \
    -o ${OUTPUT_FILE_PREFIX}.balance.arff \
    -c last -B 1
    gzip -f ${OUTPUT_FILE_PREFIX}.balance.arff
fi


