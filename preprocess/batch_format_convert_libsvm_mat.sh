#!/bin/bash

FILES=(201504 201505 201506 201507)
N=${#FILES[@]}

for (( i = 0; i < ${N}; i++ )); do
    echo "  Month " ${FILES[${i}]}

    python format_convert_libsvm_mat.py ${FILES[${i}]}
done
