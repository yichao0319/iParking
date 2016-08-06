#!/bin/bash


#########################################
## Clean up old data
#########################################
echo "Clean up old data"

dir="../../data"

/bin/rm -f $dir/sensor/*txt
/bin/rm -f $dir/model/*
/bin/rm -f $dir/ml_weka/*
/bin/rm -f $dir/ml_weka/err/*
/bin/rm -f $dir/ml_weka/prob/*
/bin/rm -f $dir/ml_weka/summary/*
/bin/rm -f $dir/feature_dist/*
/bin/rm -f $dir/condor/log/*


#########################################
## Copy data and label to the correct place
#########################################
dir="../../data/sensor"

MONS=("201504" "201505" "201506" "201507")
N=${#MONS[@]}

for (( i = 0; i < ${N}; i++ )); do
    echo "  Month " ${MONS[${i}]}

    filename_src="$dir/${MONS[${i}]}/label/label_${MONS[${i}]}.txt"
    if [[ ! -e $filename_src ]]; then
        echo "$filename_src does not exists"
        filename_src="$dir/${MONS[${i}]}/label/label_20150.txt"
    fi
    filename_dst="$dir/label_${MONS[${i}]}.txt"
    cp $filename_src $filename_dst

    filename_src="$dir/${MONS[${i}]}/data/data_${MONS[${i}]}.txt"
    if [[ ! -e $filename_src ]]; then
        echo "$filename_src does not exists"
        filename_src="$dir/${MONS[${i}]}/data/data_20150.txt"
    fi
    filename_dst="$dir/data_${MONS[${i}]}.txt"
    cp $filename_src $filename_dst
done



#########################################
## Generate directories for other codes
#########################################
dir="../../data"

if [[ ! -e $dir/condor ]]; then
  echo "create $dir/condor"
  mkdir -p $dir/condor/log
fi

if [[ ! -e $dir/feature_dist ]]; then
  echo "create $dir/feature_dist"
  mkdir $dir/feature_dist
fi

if [[ ! -e $dir/ml_weka ]]; then
  echo "create $dir/ml_weka"
  mkdir $dir/ml_weka
  mkdir $dir/ml_weka/err
  mkdir $dir/ml_weka/prob
  mkdir $dir/ml_weka/summary
fi

if [[ ! -e $dir/model ]]; then
  echo "create $dir/model"
  mkdir $dir/model
fi

