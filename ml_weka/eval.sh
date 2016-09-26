#!/bin/bash
##################
##
## example:
##   bash eval.sh -E="SymmetricalUncertAttributeSetEval" -S="FCBFSearch" -m="201604" -t="norm.fix" -v=".valid" -d=200 -M="201604" -T="norm.fix" -S="lora_" -r=80 -N=20
##################

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.


## Inputs
echo "Inputs"

DATA_PATH="/u/yichao/iParking/data/sensor"
MODEL_PATH="/u/yichao/iParking/data/model"
PRED_PATH="/u/yichao/iParking/data/ml_weka"

CLASSIFIER="NaiveBayes"
TRAIN_MON="201604"
TRAIN_TYPE="norm.fix"
VALID=".valid"
DUP=200
TEST_MON="201604"
TEST_TYPE="norm.fix"
SENSOR="lora_"
DET_RNG=100
WEKA_EVAL=""
WEKA_SEARCH=""
N=20
D=1

for i in "$@"; do
    case $i in
        -C=*|--Classifier=*)
        CLASSIFIER="${i#*=}"
        ;;
        -E=*|--Evaluate=*)
        WEKA_EVAL="${i#*=}"
        ;;
        -S=*|--Search=*)
        WEKA_SEARCH="${i#*=}"
        ;;
        -N=*|--NumFeatures=*)
        N="${i#*=}"
        ;;
        -D=*|--Direction=*)
        D="${i#*=}"
        ;;
        -m=*|--train_mon=*)
        TRAIN_MON="${i#*=}"
        ;;
        -t=*|--train_type=*)
        TRAIN_TYPE="${i#*=}"
        ;;
        -v=*|--valid=*)
        VALID="${i#*=}"
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
        -s=*|--sensor=*)
        SENSOR="${i#*=}"
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
    TRAIN_FILE="weka_${SENSOR}${TRAIN_MON}${VALID}${BAL}"
else
    TRAIN_FILE="weka_${SENSOR}${TRAIN_MON}.${TRAIN_TYPE}${VALID}${BAL}"
fi


TEST_FILE="weka_${SENSOR}${TEST_MON}.${TEST_TYPE}"
TEST_TYPE2=${TEST_TYPE}


## Classifier name
if [[ ${CLASSIFIER} == "NaiveBayes" ]]; then
    WEKA_CLS_TRAIN="weka.classifiers.bayes.NaiveBayes -K"
    WEKA_CLS_TEST="weka.classifiers.bayes.NaiveBayes"
    WEKA_CLS_WRAP="weka.classifiers.bayes.NaiveBayes -- -K"
elif [[ ${CLASSIFIER} == "C45" ]]; then
    WEKA_CLS_TRAIN="weka.classifiers.trees.J48"
    WEKA_CLS_TEST="weka.classifiers.trees.J48"
    WEKA_CLS_WRAP="weka.classifiers.trees.J48"
elif [[ ${CLASSIFIER} == "SVM" ]]; then
    WEKA_CLS_TRAIN="weka.classifiers.functions.SMO"
    WEKA_CLS_TEST="weka.classifiers.functions.SMO"
    WEKA_CLS_WRAP="weka.classifiers.functions.SMO"
elif [[ ${CLASSIFIER} == "LIBSVM" ]]; then
    WEKA_CLS_TRAIN="weka.classifiers.functions.LibSVM -B"
    WEKA_CLS_TEST="weka.classifiers.functions.LibSVM"
    WEKA_CLS_WRAP="weka.classifiers.functions.LibSVM"
fi

## Train/Test output name
# TRAIN_FILE2=${TRAIN_FILE}
# TEST_FILE2=${TEST_FILE}
# OUTPUT_FILE=${CLASSIFIER}.${TRAIN_FILE}.${TEST_FILE}
# MODEL_FILE=${CLASSIFIER}.${TRAIN_FILE}
# if [[ ${WEKA_SEARCH} != "" ]]; then
#     TRAIN_FILE2=${CLASSIFIER}.${TRAIN_FILE}.${WEKA_SEARCH}_${WEKA_EVAL}_N${N}_D${D}
#     TEST_FILE2=${CLASSIFIER}.${TEST_FILE}.${TRAIN_FILE}.${WEKA_SEARCH}_${WEKA_EVAL}_N${N}_D${D}
#     OUTPUT_FILE=${CLASSIFIER}.${TRAIN_FILE}.${TEST_FILE}.${WEKA_SEARCH}_${WEKA_EVAL}_N${N}_D${D}
#     MODEL_FILE=${CLASSIFIER}.${TRAIN_FILE}.${WEKA_SEARCH}_${WEKA_EVAL}_N${N}_D${D}

#     if [[ ${TEST_TYPE} == "" ]]; then
#         TEST_TYPE2=${WEKA_SEARCH}_${WEKA_EVAL}_N${N}_D${D}
#     else
#         TEST_TYPE2=${TEST_TYPE}.${WEKA_SEARCH}_${WEKA_EVAL}_N${N}_D${D}
#     fi
# fi
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



echo "  (-E) weka evaluator: " ${WEKA_EVAL}
echo "  (-S) weka search: " ${WEKA_SEARCH}
echo "  (-N) weka num features: " ${N}
echo "  (-D) weka search direction: " ${D}
echo "  (-m) train month: " ${TRAIN_MON}
echo "  (-t) train type: " ${TRAIN_TYPE}
echo "  (-v) valid: " ${VALID}
echo "  (-d) duplicate: " ${DUP}
echo "  (-M) test month: " ${TEST_MON}
echo "  (-T) test type: " ${TEST_TYPE}
echo "  (-s) sensor: ${SENSOR}"
echo "  (-r) range: " ${DET_RNG}
echo "  train complete: " ${TRAIN_FILE2}
echo "  test complete: " ${TEST_FILE2}


## Feature Selection
echo "Feature Selection"
# if [[ ${WEKA_SEARCH} != "" ]] && ([ ! -f ${DATA_PATH}/${TRAIN_FILE2}.arff ] || [ ! -f ${DATA_PATH}/${TEST_FILE2}.arff ]); then
if [[ ${WEKA_SEARCH} == "" ]]; then
  cp ${DATA_PATH}/${TRAIN_FILE}.arff.gz ${DATA_PATH}/${TRAIN_FILE2}.arff.gz
  cp ${DATA_PATH}/${TEST_FILE}.arff.gz ${DATA_PATH}/${TEST_FILE2}.arff.gz

else
  ## Wrapper Evaluator
  if [[ ${WEKA_EVAL} == "WrapperSubsetEval" ]]; then
    java -classpath ./:/u/yichao/bin/weka-3-8-0/weka.jar:/u/yichao/wekafiles/packages/fastCorrBasedFS/fastCorrBasedFS.jar:/u/yichao/bin/weka-3-8-0/LibSVM.jar weka.filters.supervised.attribute.AttributeSelection \
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
    java -classpath ./:/u/yichao/bin/weka-3-8-0/weka.jar:/u/yichao/wekafiles/packages/fastCorrBasedFS/fastCorrBasedFS.jar:/u/yichao/bin/weka-3-8-0/LibSVM.jar weka.filters.supervised.attribute.AttributeSelection \
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
    java -classpath ./:/u/yichao/bin/weka-3-8-0/weka.jar:/u/yichao/wekafiles/packages/fastCorrBasedFS/fastCorrBasedFS.jar:/u/yichao/bin/weka-3-8-0/LibSVM.jar weka.filters.supervised.attribute.AttributeSelection \
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
    java -classpath ./:/u/yichao/bin/weka-3-8-0/weka.jar:/u/yichao/wekafiles/packages/fastCorrBasedFS/fastCorrBasedFS.jar:/u/yichao/bin/weka-3-8-0/LibSVM.jar weka.filters.supervised.attribute.AttributeSelection \
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


## Training
echo "Training: -t ${DATA_PATH}/${TRAIN_FILE2}.arff -d ${MODEL_PATH}/${MODEL_FILE}.model"
if [ ! -f ${MODEL_PATH}/${MODEL_FILE}.model ]; then
  java -classpath ./:/u/yichao/bin/weka-3-8-0/weka.jar:/u/yichao/bin/weka-3-8-0/LibSVM.jar ${WEKA_CLS_TRAIN} -t ${DATA_PATH}/${TRAIN_FILE2}.arff.gz -d ${MODEL_PATH}/${MODEL_FILE}.model -no-cv -o
fi


## Testing
echo "Testing: -l ${MODEL_PATH}/${MODEL_FILE}.model -T ${DATA_PATH}/${TEST_FILE2}.arff > ${PRED_PATH}/${OUTPUT_FILE}.pred.csv"
java -classpath ./:/u/yichao/bin/weka-3-8-0/weka.jar:/u/yichao/bin/weka-3-8-0/LibSVM.jar ${WEKA_CLS_TEST} -l ${MODEL_PATH}/${MODEL_FILE}.model -T ${DATA_PATH}/${TEST_FILE2}.arff.gz -classifications "weka.classifiers.evaluation.output.prediction.CSV" > ${PRED_PATH}/${OUTPUT_FILE}.pred.csv

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


