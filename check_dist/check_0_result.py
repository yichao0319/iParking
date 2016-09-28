#!/usr/bin/env python

######################################
##
## Yi-Chao Chen @ UT Austin
##
## - Input
##
## - Output
##
## - Example
##
######################################


import os, sys, math, random, re
from os import listdir
from os.path import isfile, join
from subprocess import call


## =====================
## DEBUG
## =====================
DEBUG0 = 0
DEBUG1 = 1
DEBUG2 = 1
DEBUG3 = 1
DEBUG4 = 1


## =====================
## Constant
## =====================
input_dir  = "../../data/check_dist/weka_pred/"


## =====================
## Main
## =====================
for filename in listdir(input_dir):
    m = re.search("result.txt", filename)
    if m is None:
        continue

    # print filename

    filepath = "%s%s" % (input_dir, filename)
    if_del = 0
    f = open(filepath, 'r')
    for line in f:
        # print "> %s" % (line)
        line = line.strip()

        cols = line.split(',')
        tp = int(cols[0])
        tn = int(cols[1])
        fp = int(cols[2])
        fn = int(cols[3])
        if tp == 0 and tn == 0 and fp == 0 and fn == 0:
            print filename
            if_del = 1
    f.close()

    if if_del == 1:
        call(["/bin/rm", "-f", filepath])


