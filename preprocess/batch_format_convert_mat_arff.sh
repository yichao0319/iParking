#!/bin/bash

FILES=(4 5 6 7 201605)
N=${#FILES[@]}

for (( i = 0; i < ${N}; i++ )); do
    echo "  Month " ${FILES[${i}]}

    python format_convert_mat_arff.py \
        Data_${FILES[${i}]} \
        label_${FILES[${i}]}.fix \
        weka_${FILES[${i}]}.fix

    python format_convert_mat_arff.py \
        Data_${FILES[${i}]}.norm \
        label_${FILES[${i}]}.fix \
        weka_${FILES[${i}]}.norm.fix
done