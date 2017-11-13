#!/bin/bash

## CONDOR
func="batch_eval"
EVAL_PATH="/home/hpc/intel_parking/iParking/git_repository/ml_weka/"
JOB_PATH="/home/hpc/intel_parking/iParking/git_repository/ml_weka/script/fig8a/"
OUTPUT_PATH="/home/hpc/intel_parking/iParking/data/condor/log/"

num_jobs=200
cnt=0
MONTHS=
CLASSIFIER=""

TYPES="norm.fix.fltr"
DUPS=200
##108* 10% 20% 30% 40% 50% 60% 70% 80% 90% 100%
FEATURE_NUM=108
FEATURES=(11 22 32 43 54 65 76 86 97 108)

MONTHS=$1
CLASSIFIER=$2



tf=0
i=0

RNG=100

NF=${#FEATURES[@]}

i=0 ## MONTHS
j=0 ## DUPS
t=0 ## TYPES
    
FILENAME="weka_${MONTHS}.${TYPES}"
echo "-----------------"
echo "FILE=${FILENAME}"


BAL=""
if [[ ${DUPS} > 0 ]]; then
    BAL=".bal${DUPS[${j}]}"
fi

echo "#!/bin/sh" >> job.${CLASSIFIER}.${MONTHS}.sh


echo "  > all"
ALL_FILENAME="${CLASSIFIER}.ALL.TRAIN_${FILENAME}${BAL}.TEST_${FILENAME}"
echo ${ALL_FILENAME}
echo "bash ${EVAL_PATH}eval.sh -C=\"${CLASSIFIER}\" -t=\"${FILENAME}${BAL}\" -T=\"${FILENAME}\" -r=${RNG} -N=${FEATURES_NUM}" > ${ALL_FILENAME}.sh

echo "qsub -q long2 -N iParking_J_${ALL_FILENAME} -o ${OUTPUT_PATH}job.${ALL_FILENAME}.txt -e ${OUTPUT_PATH}${ALL_FILENAME}.err -l walltime=1:00:00 ${JOB_PATH}${ALL_FILENAME}.sh" >> job.${CLASSIFIER}.${MONTHS}.sh
    
echo "  > FCBF"
FCBF_FILENAME="${CLASSIFIER}.FCBF.TRAIN_${FILENAME}${BAL}.TEST_${FILENAME}"
echo ${FCBF_FILENAME}

echo "bash ${EVAL_PATH}eval.sh -C=\"${CLASSIFIER}\" -E=\"SymmetricalUncertAttributeSetEval\" -S=\"FCBFSearch\" -t=\"${FILENAME}${BAL}\" -T=\"${FILENAME}\" -r=${RNG} -N=30" > ${FCBF_FILENAME}.sh
  
echo "qsub -q long2 -N iParking_J_${FCBF_FILENAME} -o ${OUTPUT_PATH}job.${FCBF_FILENAME}.txt -e ${OUTPUT_PATH}/job${FCBF_FILENAME}.err -l walltime=1:00:00 ${JOB_PATH}${FCBF_FILENAME}.sh" >> job.${CLASSIFIER}.${MONTHS}.sh
    
echo "  > Cfs, BesttFirst"
BESTTFIRST_FILENAME="${CLASSIFIER}.BESTTFIRST.TRAIN_${FILENAME}${BAL}.TEST_${FILENAME}"
echo ${BESTTFIRST_FILENAME}

echo "bash ${EVAL_PATH}eval.sh -C=\"${CLASSIFIER}\" -E=\"CfsSubsetEval\" -S=\"BestFirst\" -t=\"${FILENAME}${BAL}\" -T=\"${FILENAME}\" -r=${RNG} -N=30" > ${BESTTFIRST_FILENAME}.sh
     
echo "qsub -q long2 -N iParking_J_${BESTTFIRST_FILENAME} -o ${OUTPUT_PATH}job.${BESTTFIRST_FILENAME}.txt -e ${OUTPUT_PATH}job.${BESTTFIRST_FILENAME}.err -l walltime=1:00:00 ${JOB_PATH}${BESTTFIRST_FILENAME}.sh" >> job.${CLASSIFIER}.${MONTHS}.sh
    
for (( k = 0; k < ${NF}; k++ )); do
    echo "  > Ranker: ${FEATURES[${k}]}"

    RANKER_FILENAME="${CLASSIFIER}.RANKER${FEATURES[${k}]}.TRAIN_${FILENAME}${BAL}.TEST_${FILENAME}"
    echo ${RANKER_FILENAME}
    echo "bash ${EVAL_PATH}eval.sh -C=\"${CLASSIFIER}\" -E=\"GainRatioAttributeEval\" -S=\"Ranker\" -t=\"${FILENAME}${BAL}\" -T=\"${FILENAME}\" -r=${RNG} -N=${FEATURES[${k}]}" > ${RANKER_FILENAME}.sh
        
    echo "qsub -q long2 -N iParking_J_${RANKER_FILENAME} -o ${OUTPUT_PATH}job.${RANKER_FILENAME}.txt -e ${OUTPUT_PATH}job.${RANKER_FILENAME}.err -l walltime=1:00:00 ${JOB_PATH}${RANKER_FILENAME}.sh" >> job.${CLASSIFIER}.${MONTHS}.sh

done
