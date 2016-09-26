#!/bin/bash
##################
##
## example:
##   bash weka_eval.sh -C="NaiveBayes" -m="201504" -t="norm.fix" -v="" -d=200 -M="201504" -s="" -S="combine" -r=100 -N=20
##################

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.


## Inputs
echo "Inputs"

DATA_PATH="../../data/check_dist/weka_data"
MODEL_PATH="../../data/check_dist/weka_model"
PRED_PATH="../../data/check_dist/weka_pred"

CLASSIFIER="NaiveBayes"
TRAIN_MON="201604"
TYPE="norm.fix"
VALID=".valid"
DUP=200
TEST_MON="201604"
SENSOR="lora_"
SCORE="combine"
DET_RNG=100
N=20

for i in "$@"; do
    case $i in
        -C=*|--Classifier=*)
        CLASSIFIER="${i#*=}"
        ;;
        -N=*|--NumFeatures=*)
        N="${i#*=}"
        ;;
        -m=*|--train_mon=*)
        TRAIN_MON="${i#*=}"
        ;;
        -t=*|--type=*)
        TYPE="${i#*=}"
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
        -s=*|--sensor=*)
        SENSOR="${i#*=}"
        ;;
        -S=*|--score=*)
        SCORE="${i#*=}"
        ;;
        -r=*|--range=*)
        DET_RNG="${i#*=}"
        ;;
        *)
                # unknown option
        ;;
    esac
done

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
TRAIN_FILE=$(LC_ALL=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 32;)
TEST_FILE=$(LC_ALL=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 32;)
MODEL_FILE=$(LC_ALL=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 32;)

OUTPUT_FILE="${CLASSIFIER}.weka_${SENSOR}${TRAIN_MON}.train${TEST_MON}.${TYPE}.${SCORE}.nf${N}.dup${DUP}${VALID}"

echo "  (-C) classifier: " ${CLASSIFIER}
echo "  (-N) weka num features: " ${N}
echo "  (-m) train month: " ${TRAIN_MON}
echo "  (-t) train type: " ${TYPE}
echo "  (-v) valid: " ${VALID}
echo "  (-d) duplicate: " ${DUP}
echo "  (-M) test month: " ${TEST_MON}
echo "  (-s) sensor: ${SENSOR}"
echo "  (-S) score: ${SCORE}"
echo "  (-r) range: " ${DET_RNG}
echo "  train file: " ${TRAIN_FILE}
echo "  test file: " ${TEST_FILE}


## Generate Train and Test files
python weka_preprocess.py ${TRAIN_MON} ${TEST_MON} "${SENSOR}" "${TYPE}" "${SCORE}" ${N} ${DUP} "${TRAIN_FILE}" "${TEST_FILE}"

## Training
echo "Training: -t ${DATA_PATH}/${TRAIN_FILE}.arff.gz -d ${MODEL_PATH}/${MODEL_FILE}.model"
if [ ! -f ${MODEL_PATH}/${MODEL_FILE}.model ]; then
  java -classpath ./:/u/yichao/bin/weka-3-8-0/weka.jar:/u/yichao/bin/weka-3-8-0/LibSVM.jar ${WEKA_CLS_TRAIN} -t ${DATA_PATH}/${TRAIN_FILE}.arff.gz -d ${MODEL_PATH}/${MODEL_FILE}.model -no-cv -o
fi


## Testing
echo "Testing: -l ${MODEL_PATH}/${MODEL_FILE}.model -T ${DATA_PATH}/${TEST_FILE}.arff.gz > ${PRED_PATH}/${OUTPUT_FILE}.pred.csv"
java -classpath ./:/u/yichao/bin/weka-3-8-0/weka.jar:/u/yichao/bin/weka-3-8-0/LibSVM.jar ${WEKA_CLS_TEST} -l ${MODEL_PATH}/${MODEL_FILE}.model -T ${DATA_PATH}/${TEST_FILE}.arff.gz -classifications "weka.classifiers.evaluation.output.prediction.CSV" > ${PRED_PATH}/${OUTPUT_FILE}.pred.csv


## Remove file after done
/bin/rm -f ${DATA_PATH}/${TRAIN_FILE}.arff.gz
/bin/rm -f ${DATA_PATH}/${TEST_FILE}.arff.gz


## Evaluation
##    1. classifier
##    2. sensor
##    3. training month
##    4. testing month
##    5. type
##    6. score type
##    7. number of selected features
##    8. balance
##    9. tolerant range: allowed time difference between real and estimated event
echo "Evaluation: ${CLASSIFIER} ${SENSOR} ${TRAIN_MON} ${TEST_MON} ${TYPE} ${SCORE} ${N} ${DUP} ${DET_RNG}"
python weka_eval_pred.py ${CLASSIFIER} "${SENSOR}" ${TRAIN_MON} ${TEST_MON} ${TYPE} ${SCORE} ${N} ${DUP} ${DET_RNG}


