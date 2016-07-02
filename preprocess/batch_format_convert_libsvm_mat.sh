#!/bin/bash

FILES=(4 5 6 7 201605)
N=${#FILES[@]}

for (( i = 0; i < ${N}; i++ )); do
    echo "  Month " ${FILES[${i}]}

    python format_convert_libsvm_mat.py ${FILES[${i}]}
done
