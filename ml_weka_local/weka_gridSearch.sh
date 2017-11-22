while getopts m:C:a:b:G:c:d: option; do
  case ${option} in
  m) month=${OPTARG};;
  C) cost_min=${OPTARG};;
  a) cost_max=${OPTARG};;
  b) cost_step=${OPTARG};;
  G)  gamma_min=${OPTARG};;
  c)  gamma_max=${OPTARG};;
  d)  gamma_step=${OPTARG};;
  esac
done


FILE_PATH="/home/intel_parking/iParking/data/sensor/SVM_sampling/${month}/"
GRIDSEARCH_PATH="/home/intel_parking/wekafiles/packages/gridSearch1.0.11/gridSearch.jar"
WEKA_PATH="/home/intel_parking/weka-3-8-0/weka.jar"
WEKA_LIBSVM_PATH="/home/intel_parking/wekafiles/packages/LibSVM1.0.10/LibSVM.jar"
LIBSVM_PATH="/home/intel_parking/Downloads/libsvm-3.22/java/libsvm.jar"

if [ -f "${FILE_PATH}weka_${month}.norm.fix.fltr.sample40.balance.arff.gz" ]; then

    java -XX:-UseGCOverheadLimit -Xmx2048m -cp ${WEKA_PATH}:${GRIDSEARCH_PATH}:${WEKA_LIBSVM_PATH}:${LIBSVM_PATH} weka.classifiers.meta.GridSearch -E ACC -W weka.classifiers.functions.LibSVM -x-property cost -x-min ${cost_min} -x-max ${cost_max} -x-step ${cost_step} -x-expression I -y-property gamma -y-min ${gamma_min} -y-max ${gamma_max} -y-step ${gamma_step} -y-base 10 -y-expression pow\(BASE,I\) -c last -d ${FILE_PATH}gridSearch_output.xml -log-file ${FILE_PATH}gridSearch_output.txt -t ${FILE_PATH}weka_${month}.norm.fix.fltr.sample40.balance.arff.gz

else 
    echo " ${FILE_PATH}weka_${month}.norm.fix.fltr.sample40.balance.arff.gz not exist."
fi


