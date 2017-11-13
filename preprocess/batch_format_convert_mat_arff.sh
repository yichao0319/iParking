#!/bin/bash

dir="../../data/sensor/"

FILES=(201504 201505 201506 201507 201508 201509 201510 201511 201512 201601 201604 201605 201608)
# FILES=(201604 201605)
N=${#FILES[@]}

for (( i = 0; i < ${N}; i++ )); do
    echo "  Month " ${FILES[${i}]}

    ## Original Data
    python format_convert_mat_arff.py \
        data_${FILES[${i}]} \
        label_${FILES[${i}]}.fix \
        weka_${FILES[${i}]}.fix

    ## Normailized Data
    python format_convert_mat_arff.py \
        data_${FILES[${i}]}.norm \
        label_${FILES[${i}]}.fix \
        weka_${FILES[${i}]}.norm.fix

    ## Lora
    if [[ -e $dir/lora_${FILES[${i}]}.mat.txt ]]; then
        ## Original Lora
        python format_convert_mat_arff.py \
            lora_${FILES[${i}]} \
            label_${FILES[${i}]}.fix \
            weka_lora_${FILES[${i}]}.fix

        ## Normalized Lora
        python format_convert_mat_arff.py \
            lora_${FILES[${i}]}.norm \
            label_${FILES[${i}]}.fix \
            weka_lora_${FILES[${i}]}.norm.fix

        ## Valid Lora
        python format_convert_mat_arff.py \
            lora_${FILES[${i}]}.norm.valid \
            label_lora_${FILES[${i}]}.fix.valid \
            weka_lora_${FILES[${i}]}.norm.fix.valid
    fi


    ## Light
    if [[ -e $dir/light_${FILES[${i}]}.mat.txt ]]; then
        ## Original Light
        python format_convert_mat_arff.py \
            light_${FILES[${i}]} \
            label_${FILES[${i}]}.fix \
            weka_light_${FILES[${i}]}.fix

        ## Normalized Light
        python format_convert_mat_arff.py \
            light_${FILES[${i}]}.norm \
            label_${FILES[${i}]}.fix \
            weka_light_${FILES[${i}]}.norm.fix

        ## Valid Light
        python format_convert_mat_arff.py \
            light_${FILES[${i}]}.norm.valid \
            label_light_${FILES[${i}]}.fix.valid \
            weka_light_${FILES[${i}]}.norm.fix.valid
    fi
done