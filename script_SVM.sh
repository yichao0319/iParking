#!/bin/bash

start=0
if [ ! $1 ]; then
	echo "default start from head"
else
	start = $1
fi

mon=(201504)
test_mon=(201504)

NM=${#mon[@]}
NTEST=${#mon[@]}

for (( i = 0; i < ${NM}; i++)); do
    echo "========== start from step $start ==========="

    cd git_repository/preprocess/
    if [ $start -le 1 ]; then 
    	echo "==========  step 1 start !!!  ==========="
    	#Step 1
    	./batch_format_convert_libsvm_mat_ver2.sh -m ${mon[${i}]}
    	echo "========== step 1 finished !! ==========="
fi


    if [ $start -le 2 ]; then
    	echo "==========  step 2 start !!!  ==========="
    	#step 2
    	sudo matlab -nodesktop -nosplash -r "run fix_labeling_ver2(${mon[${i}]}); exit;"
    	echo "========== step 2 finished !! ==========="
    fi


    if [ $start -le 3 ]; then
    	echo "==========  step 3 start !!!  ==========="
    	#step 3 
    	./batch_format_convert_mat_arff_ver2.sh -m ${mon[${i}]}      #merge data & label to arff file

    	echo "========== step 3 finished !! ==========="
    fi

    if [ $start -le 4 ]; then
    	echo "==========  step 4 start !!!  ==========="
    	#step 4
    	./weka_SVM_resample.sh -m ${mon[${i}]} -d 40
    	echo "========== step 4 finished !! ==========="
    fi
    cd ../..



    #WEKA
    cd ../ml_weka
    echo "==========  step 4 SVM grid search start !!!  ==========="
    ./weka_gridSearch -m ${mon[${i}]} -c_min -4 -c_max 4 -c_step 2 -g_min 0 -g_max 4 -g_step 2
    echo "========== step 4 finished !! ==========="

    echo "==========  step 5 find best cost & gamma start !!!  ==========="
    python parse_gridSearch.py gridSearch_output ${mon[${i}]}
    echo "========== step 5 finished !! ==========="

    for (( j = 0; j < ${NTEST}; j++)); do
        echo "==========  step 6 generate ML script start !!!  ==========="
        ./batch_SVM_condor.sh -m ${mon[${i}]} -M
        echo "========== step 6 finished !! ==========="
    done
    
    ./all.sh
done
