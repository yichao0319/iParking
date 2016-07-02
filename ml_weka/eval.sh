#!/bin/bash
##################
##
## example:
##   bash eval.sh -E="SymmetricalUncertAttributeSetEval" -S="FCBFSearch" -t="weka_4.norm.fix.bal200" -T="weka_4.norm.fix" -r=80 -N=20
##################

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.


## Inputs
echo "Inputs"

DATA_PATH="../../data/sensor"
MODEL_PATH="../../data/model"
PRED_PATH="../../data/ml_weka"

CLASSIFIER="NaiveBayes"
TRAIN_FILE="weka_4.norm.fix.bal200"
TEST_FILE="weka_4.norm.fix"
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
        -t=*|--train=*)
        TRAIN_FILE="${i#*=}"
        ;;
        -T=*|--test=*)
        TEST_FILE="${i#*=}"
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
fi

echo "  (-E) weka evaluator: " ${WEKA_EVAL}
echo "  (-S) weka search: " ${WEKA_SEARCH}
echo "  (-N) weka num features: " ${N}
echo "  (-D) weka search direction: " ${D}
echo "  (-t) train: " ${TRAIN_FILE}
echo "  (-T) test: " ${TEST_FILE}
echo "  (-r) range: " ${DET_RNG}
echo "  train complete: " ${TRAIN_FILE2}
echo "  test complete: " ${TEST_FILE2}


## Feature Selection
echo "Feature Selection"
if [[ ${WEKA_SEARCH} != "" ]] && [ ! -f ${DATA_PATH}/${TRAIN_FILE2}.arff ]; then

  ## Wrapper Evaluator
  if [[ ${WEKA_EVAL} == "WrapperSubsetEval" ]]; then
    java -classpath ./:/u/yichao/bin/weka-3-8-0/weka.jar:/u/yichao/wekafiles/packages/fastCorrBasedFS/fastCorrBasedFS.jar weka.filters.supervised.attribute.AttributeSelection \
        -E "weka.attributeSelection.${WEKA_EVAL} -B ${WEKA_CLS_WRAP}" \
        -S "weka.attributeSelection.${WEKA_SEARCH} -D ${D} -N ${N}" \
        -i ${DATA_PATH}/${TRAIN_FILE}.arff \
        -o ${DATA_PATH}/${TRAIN_FILE2}.arff \
        -c last \
        -b \
        -r ${DATA_PATH}/${TEST_FILE}.arff \
        -s ${DATA_PATH}/${TEST_FILE2}.arff \

  ## RankSearch Searcher
  elif [[ ${WEKA_SEARCH} == "RankSearch" ]]; then
    java -classpath ./:/u/yichao/bin/weka-3-8-0/weka.jar:/u/yichao/wekafiles/packages/fastCorrBasedFS/fastCorrBasedFS.jar weka.filters.supervised.attribute.AttributeSelection \
        -E "weka.attributeSelection.${WEKA_EVAL} -M" \
        -S "weka.attributeSelection.${WEKA_SEARCH} -A weka.attributeSelection.GainRatioAttributeEval -- -M" \
        -i ${DATA_PATH}/${TRAIN_FILE}.arff \
        -o ${DATA_PATH}/${TRAIN_FILE2}.arff \
        -c last \
        -b \
        -r ${DATA_PATH}/${TEST_FILE}.arff \
        -s ${DATA_PATH}/${TEST_FILE2}.arff

  ## Ranker Searcher
  elif [[ ${WEKA_SEARCH} == "Ranker" ]]; then
    java -classpath ./:/u/yichao/bin/weka-3-8-0/weka.jar:/u/yichao/wekafiles/packages/fastCorrBasedFS/fastCorrBasedFS.jar weka.filters.supervised.attribute.AttributeSelection \
        -E "weka.attributeSelection.${WEKA_EVAL} -M" \
        -S "weka.attributeSelection.${WEKA_SEARCH} -N ${N}" \
        -i ${DATA_PATH}/${TRAIN_FILE}.arff \
        -o ${DATA_PATH}/${TRAIN_FILE2}.arff \
        -c last \
        -b \
        -r ${DATA_PATH}/${TEST_FILE}.arff \
        -s ${DATA_PATH}/${TEST_FILE2}.arff

  else
    java -classpath ./:/u/yichao/bin/weka-3-8-0/weka.jar:/u/yichao/wekafiles/packages/fastCorrBasedFS/fastCorrBasedFS.jar weka.filters.supervised.attribute.AttributeSelection \
        -E "weka.attributeSelection.${WEKA_EVAL} -M" \
        -S "weka.attributeSelection.${WEKA_SEARCH} -D ${D} -N ${N}" \
        -i ${DATA_PATH}/${TRAIN_FILE}.arff \
        -o ${DATA_PATH}/${TRAIN_FILE2}.arff \
        -c last \
        -b \
        -r ${DATA_PATH}/${TEST_FILE}.arff \
        -s ${DATA_PATH}/${TEST_FILE2}.arff
  fi
fi


## Training
echo "Training: -t ${DATA_PATH}/${TRAIN_FILE2}.arff -d ${MODEL_PATH}/${MODEL_FILE}.model"
if [ ! -f ${MODEL_PATH}/${MODEL_FILE}.model ]; then
  java -classpath ./:/u/yichao/bin/weka-3-8-0/weka.jar ${WEKA_CLS_TRAIN} -t ${DATA_PATH}/${TRAIN_FILE2}.arff -d ${MODEL_PATH}/${MODEL_FILE}.model -no-cv -o
fi


## Testing
echo "Testing: -l ${MODEL_PATH}/${MODEL_FILE}.model -T ${DATA_PATH}/${TEST_FILE2}.arff > ${PRED_PATH}/${OUTPUT_FILE}.pred.csv"
java -classpath ./:/u/yichao/bin/weka-3-8-0/weka.jar ${WEKA_CLS_TEST} -l ${MODEL_PATH}/${MODEL_FILE}.model -T ${DATA_PATH}/${TEST_FILE2}.arff -classifications "weka.classifiers.evaluation.output.prediction.CSV" > ${PRED_PATH}/${OUTPUT_FILE}.pred.csv


## Evaluation
echo "Evaluation: ${OUTPUT_FILE} ${DET_RNG}"
python eval_pred.py ${OUTPUT_FILE} ${DET_RNG}


