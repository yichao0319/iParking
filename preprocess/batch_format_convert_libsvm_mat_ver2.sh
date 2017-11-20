#!/bin/bash/

FILES=(201507)

N=${#FILE[@]}
`
for ((i=0; i<${N}; i++)); do
    echo " Month " ${FILES[${i}]}

    python format_convert_libsvm_mat_ver2.py ${FILES[${i}]}

done
