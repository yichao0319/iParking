#!/bin/bash

ls -alh ../../data/sensor | grep arff | grep -v weka | awk '{print "../../data/sensor/"$9; }' | xargs /bin/rm -f
