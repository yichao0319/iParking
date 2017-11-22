#!/bin/bash
##################
##
## example:
##   bash eval.sh -C="LibSVM" -c=1 -g=2 -t="norm.fix" -d=200 -M="201604" -T="norm.fix" -r=80 -N=20
##################

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.


## Inputs
echo "Inputs"

DATA_PATH="/home/intel_parking/iParking/data/sensor"
MODEL_PATH="/home/intel_parking/iParking/data/model"
PRED_PATH="/home/intel_parking/iParking/data/ml_weka"

CLASSIFIER="LibSVM"
TRAIN_MON="201604"
TRAIN_TYPE="norm.fix"
DUP=200
TEST_MON="201604"
TEST_TYPE="norm.fix"
DET_RNG=100
WEKA_EVAL=""
WEKA_SEARCH=""
N=20
D=1
COST=""
GAMMA=0


for i in "$@"; do
    case $i in
        -C=*|--Classifier=*)
        CLASSIFIER="${i#*=}"
        ;;
        -c=*|--Cost=*)
        COST="${i#*=}"
        ;;
        -g=*|--gamma=*)
        GAMMA="${i#*=}"
        ;;
        -N=*|--NumFeatures=*)
        N="${i#*=}"
        ;;
        -m=*|--train_mon=*)
        TRAIN_MON="${i#*=}"
        ;;
        -t=*|--train_type=*)
        TRAIN_TYPE="${i#*=}"
        ;;
        -d=*|--duplicate=*)
        DUP="${i#*=}"
        ;;
        -M=*|--Test_mon=*)
        TEST_MON="${i#*=}"
        ;;
        -T=*|--Test_type=*)
        TEST_TYPE="${i#*=}"
        ;;
        -r=*|--range=*)
        DET_RNG="${i#*=}"
        ;;
        *)
                # unknown option
        ;;
    esac
done

BAL=""
if [[ ${DUP} > 0 ]]; then
    BAL=".bal${DUP}"
fi

if [[ ${TRAIN_TYPE} == "" ]]; then
    TRAIN_FILE="weka_${SENSOR}${TRAIN_MON}${BAL}"
else
    TRAIN_FILE="weka_${SENSOR}${TRAIN_MON}.${TRAIN_TYPE}${BAL}"
fi


TEST_FILE="weka_${SENSOR}${TEST_MON}.${TEST_TYPE}"
TEST_TYPE2=${TEST_TYPE}


## Classifier name
if [[ -z ${COST} ]]; then
    WEKA_CLS_TRAIN="weka.classifiers.functions.LibSVM -B"
    WEKA_CLS_TEST="weka.classifiers.functions.LibSVM"
    WEKA_CLS_WRAP="weka.classifiers.functions.LibSVM"
else
    WEKA_CLS_TRAIN="weka.classifiers.functions.LibSVM -G ${GAMMA} -C ${COST} -B"
    WEKA_CLS_TEST="weka.classifiers.functions.LibSVM"
    WEKA_CLS_WRAP="weka.classifiers.functions.LibSVM"
fi

## Train/Test output name
 TRAIN_FILE2=${TRAIN_FILE}
 TEST_FILE2=${TEST_FILE}
 OUTPUT_FILE=${CLASSIFIER}.${TRAIN_FILE}.${TEST_FILE}
 MODEL_FILE=${CLASSIFIER}.${TRAIN_FILE}
 if [[ ${WEKA_SEARCH} != "" ]]; then
     TRAIN_FILE2=${CLASSIFIER}.${TRAIN_FILE}.${WEKA_SEARCH}_${WEKA_EVAL}_N${N}_D${D}
     TEST_FILE2=${CLASSIFIER}.${TEST_FILE}.${TRAIN_FILE}.${WEKA_SEARCH}_${WEKA_EVAL}_N${N}_D${D}
     OUTPUT_FILE=${CLASSIFIER}.${TRAIN_FILE}.${TEST_FILE}.${WEKA_SEARCH}_${WEKA_EVAL}_N${N}_D${D}
     MODEL_FILE=${CLASSIFIER}.${TRAIN_FILE}.${WEKA_SEARCH}_${WEKA_EVAL}_N${N}_D${D}

     if [[ ${TEST_TYPE} == "" ]]; then
         TEST_TYPE2=${WEKA_SEARCH}_${WEKA_EVAL}_N${N}_D${D}
     else
         TEST_TYPE2=${TEST_TYPE}.${WEKA_SEARCH}_${WEKA_EVAL}_N${N}_D${D}
     fi
 fi
OUTPUT_FILE=${CLASSIFIER}.${TRAIN_FILE}.${TEST_FILE}
TRAIN_FILE2_ORIG=${TRAIN_FILE}
TEST_FILE2_ORIG=${TEST_FILE}
MODEL_FILE_ORIG=${CLASSIFIER}.${TRAIN_FILE}
if [[ ${WEKA_SEARCH} != "" ]]; then
    OUTPUT_FILE=${CLASSIFIER}.${TRAIN_FILE}.${TEST_FILE}.${WEKA_SEARCH}_${WEKA_EVAL}_N${N}_D${D}

    if [[ ${TEST_TYPE} == "" ]]; then
        TEST_TYPE2=${WEKA_SEARCH}_${WEKA_EVAL}_N${N}_D${D}
    else
        TEST_TYPE2=${TEST_TYPE}.${WEKA_SEARCH}_${WEKA_EVAL}_N${N}_D${D}
    fi

    TRAIN_FILE2_ORIG=${CLASSIFIER}.${TRAIN_FILE}.${WEKA_SEARCH}_${WEKA_EVAL}_N${N}_D${D}
    TEST_FILE2_ORIG=${CLASSIFIER}.${TEST_FILE}.${TRAIN_FILE}.${WEKA_SEARCH}_${WEKA_EVAL}_N${N}_D${D}
    MODEL_FILE_ORIG=${CLASSIFIER}.${TRAIN_FILE}.${WEKA_SEARCH}_${WEKA_EVAL}_N${N}_D${D}
fi

TRAIN_FILE2=$(LC_ALL=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 32;)
TEST_FILE2=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 32;)
MODEL_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 32;)

if [ -f ${PRED_PATH}/${OUTPUT_FILE}.result.txt ]; then
  echo "${PRED_PATH}/${OUTPUT_FILE}.result.txt exists"
  exit
fi


echo "  (-N) weka num features: " ${N}
echo "  (-m) train month: " ${TRAIN_MON}
echo "  (-t) train type: " ${TRAIN_TYPE}
echo "  (-d) duplicate: " ${DUP}
echo "  (-M) test month: " ${TEST_MON}
echo "  (-T) test type: " ${TEST_TYPE}
echo "  (-r) range: " ${DET_RNG}
echo "  train complete: " ${TRAIN_FILE2}
echo "  test complete: " ${TEST_FILE2}

cp ${DATA_PATH}/${TRAIN_FILE}.arff.gz ${DATA_PATH}/${TRAIN_FILE2}.arff.gz
cp ${DATA_PATH}/${TEST_FILE}.arff.gz ${DATA_PATH}/${TEST_FILE2}.arff.gz

##Disable feature selection
if false; then
###########################
## Feature Selection
echo "Feature Selection"
# if [[ ${WEKA_SEARCH} != "" ]] && ([ ! -f ${DATA_PATH}/${TRAIN_FILE2}.arff ] || [ ! -f ${DATA_PATH}/${TEST_FILE2}.arff ]); then
if [[ ${WEKA_SEARCH} == "" ]]; then
  cp ${DATA_PATH}/${TRAIN_FILE}.arff.gz ${DATA_PATH}/${TRAIN_FILE2}.arff.gz
  cp ${DATA_PATH}/${TEST_FILE}.arff.gz ${DATA_PATH}/${TEST_FILE2}.arff.gz

else
  ## Wrapper Evaluator
  if [[ ${WEKA_EVAL} == "WrapperSubsetEval" ]]; then
    java -classpath ../../../weka-3-8-0/weka.jar:/home/intel_parking/wekafiles/packages/fastCorrBasedFS/fastCorrBasedFS.jar:/home/intel_parking/wekafiles/packages/LibSVM1.0.10/LibSVM.jar:/home/intel_parking/wekafiles/packages/LibSVM1.0.10/lib/libsvm.jar weka.filters.supervised.attribute.AttributeSelection \
        -E "weka.attributeSelection.${WEKA_EVAL} -B ${WEKA_CLS_WRAP}" \
        -S "weka.attributeSelection.${WEKA_SEARCH} -D ${D} -N ${N}" \
        -i ${DATA_PATH}/${TRAIN_FILE}.arff.gz \
        -o ${DATA_PATH}/${TRAIN_FILE2}.arff \
        -c last \
        -b \
        -r ${DATA_PATH}/${TEST_FILE}.arff.gz \
        -s ${DATA_PATH}/${TEST_FILE2}.arff
    gzip ${DATA_PATH}/${TRAIN_FILE2}.arff
    gzip ${DATA_PATH}/${TEST_FILE2}.arff

  ## RankSearch Searcher
  elif [[ ${WEKA_SEARCH} == "RankSearch" ]]; then
    java -classpath ../../../weka-3-8-0/weka.jar:/home/intel_parking/wekafiles/packages/fastCorrBasedFS/fastCorrBasedFS.jar:/home/intel_parking/wekafiles/packages/LibSVM1.0.10/LibSVM.jar:/home/intel_parki    ng/wekafiles/packages/LibSVM1.0.10/lib/libsvm.jar weka.filters.supervised.attribute.AttributeSelection \
        -E "weka.attributeSelection.${WEKA_EVAL} -M" \
        -S "weka.attributeSelection.${WEKA_SEARCH} -A weka.attributeSelection.GainRatioAttributeEval -- -M" \
        -i ${DATA_PATH}/${TRAIN_FILE}.arff.gz \
        -o ${DATA_PATH}/${TRAIN_FILE2}.arff \
        -c last \
        -b \
        -r ${DATA_PATH}/${TEST_FILE}.arff.gz \
        -s ${DATA_PATH}/${TEST_FILE2}.arff
    gzip ${DATA_PATH}/${TRAIN_FILE2}.arff
    gzip ${DATA_PATH}/${TEST_FILE2}.arff

  ## Ranker Searcher
  elif [[ ${WEKA_SEARCH} == "Ranker" ]]; then
    java -classpath ../../../weka-3-8-0/weka.jar:/home/intel_parking/wekafiles/packages/fastCorrBasedFS/fastCorrBasedFS.jar:/home/intel_parking/wekafiles/packages/LibSVM1.0.10/LibSVM.jar:/home/intel_parki    ng/wekafiles/packages/LibSVM1.0.10/lib/libsvm.jar weka.filters.supervised.attribute.AttributeSelection \
        -E "weka.attributeSelection.${WEKA_EVAL} -M" \
        -S "weka.attributeSelection.${WEKA_SEARCH} -N ${N}" \
        -i ${DATA_PATH}/${TRAIN_FILE}.arff.gz \
        -o ${DATA_PATH}/${TRAIN_FILE2}.arff \
        -c last \
        -b \
        -r ${DATA_PATH}/${TEST_FILE}.arff.gz \
        -s ${DATA_PATH}/${TEST_FILE2}.arff
    gzip ${DATA_PATH}/${TRAIN_FILE2}.arff
    gzip ${DATA_PATH}/${TEST_FILE2}.arff

  else
    java -classpath ../../../weka-3-8-0/weka.jar:/home/intel_parking/wekafiles/packages/fastCorrBasedFS/fastCorrBasedFS.jar:/home/intel_parking/wekafiles/packages/LibSVM1.0.10/LibSVM.jar:/home/intel_parki    ng/wekafiles/packages/LibSVM1.0.10/lib/libsvm.jar weka.filters.supervised.attribute.AttributeSelection \
        -E "weka.attributeSelection.${WEKA_EVAL} -M" \
        -S "weka.attributeSelection.${WEKA_SEARCH} -D ${D} -N ${N}" \
        -i ${DATA_PATH}/${TRAIN_FILE}.arff.gz \
        -o ${DATA_PATH}/${TRAIN_FILE2}.arff \
        -c last \
        -b \
        -r ${DATA_PATH}/${TEST_FILE}.arff.gz \
        -s ${DATA_PATH}/${TEST_FILE2}.arff
    gzip ${DATA_PATH}/${TRAIN_FILE2}.arff
    gzip ${DATA_PATH}/${TEST_FILE2}.arff
  fi
fi
##############################
##Disable feature selection endi
fi
##############################

## Training
echo "Training: -t ${DATA_PATH}/${TRAIN_FILE2}.arff -d ${MODEL_PATH}/${MODEL_FILE}.model"
if [ ! -f ${MODEL_PATH}/${MODEL_FILE}.model ]; then
  java -classpath /home/intel_parking/weka-3-8-0/weka.jar:/home/intel_parking/wekafiles/packages/LibSVM1.0.10/LibSVM.jar:/home/intel_parking/Downloads/libsvm-3.22/java/libsvm.jar ${WEKA_CLS_TRAIN} -t ${DATA_PATH}/${TRAIN_FILE2}.arff.gz -d ${MODEL_PATH}/${MODEL_FILE}.model -no-cv -o
fi


## Testing
echo "Testing: -l ${MODEL_PATH}/${MODEL_FILE}.model -T ${DATA_PATH}/${TEST_FILE2}.arff > ${PRED_PATH}/${OUTPUT_FILE}.pred.csv"
java -classpath /home/intel_parking/weka-3-8-0/weka.jar:/home/intel_parking/wekafiles/packages/LibSVM1.0.10/LibSVM.jar:/home/intel_parking/Downloads/libsvm-3.22/java/libsvm.jar ${WEKA_CLS_TEST} -l ${MODEL_PATH}/${MODEL_FILE}.model -T ${DATA_PATH}/${TEST_FILE2}.arff.gz -classifications "weka.classifiers.evaluation.output.prediction.CSV" > ${PRED_PATH}/${OUTPUT_FILE}.pred.csv

/bin/rm -f ${DATA_PATH}/${TRAIN_FILE2}.arff.gz
/bin/rm -f ${DATA_PATH}/${TEST_FILE2}.arff.gz
/bin/rm -f ${MODEL_PATH}/${MODEL_FILE}.model

## Evaluation
# echo "Evaluation: ${OUTPUT_FILE} ${DET_RNG}"
# python eval_pred.py ${OUTPUT_FILE} ${DET_RNG}
##    1. classifier
##    2. sensor
##    3. training month
##    4. training type
##    5. balance
##    6. testing month
##    7. testing type
##    8. tolerant range: allowed time difference between real and estimated event
echo "Evaluation: ${CLASSIFIER} ${SENSOR} ${TRAIN_MON} ${TRAIN_TYPE} ${DUP} ${TEST_MON} ${TEST_TYPE2} ${DET_RNG}"
python eval_pred.py ${CLASSIFIER} "${SENSOR}" ${TRAIN_MON} ${TRAIN_TYPE} ${DUP} ${TEST_MON} ${TEST_TYPE2} ${DET_RNG}

