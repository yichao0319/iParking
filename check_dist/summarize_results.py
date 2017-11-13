#!/usr/bin/env python

######################################
##
## Yi-Chao Chen @ UT Austin
##
## - Example
##   python summarize_results.py
##
######################################

import os, sys, math, random, re
from os import listdir
# import list_data


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
output_dir = "../../data/check_dist/weka_pred/summary/"
# fig_dir    = "../../data/ml_weka/summary/"

MONTHS = [201504, 201505, 201506, 201507, 201604, 201605]
TYPES  = ["norm.fix"]
SCORES = ["combine"]
NFS    = [10, 50, 80, 100, 108]
DUPS   = [0, 200]

## =====================
## Variables
## =====================
classifier = "NaiveBayes"
# classifier = "C45"
# classifier = "SVM"
# classifier = "LIBSVM"

sensor = ""
valid  =""


## =====================
## FUNC: get_results
## =====================
def get_results(filename):

  if os.path.isfile(filename):
    f = open(filename, 'r')

    for line in f:
      line = line.strip()
      cols = line.split(',')

      for i in xrange(0,len(cols)):
        cols[i] = float(cols[i])

    f.close()
  else:
    print "[MISS] %s" % (filename)
    cols = [0] * 12

  return cols



## =====================
## Main
## =====================

for ti in range(len(TYPES)):
  type = TYPES[ti]

  for si in range(len(SCORES)):
    score = SCORES[si]

    for nfi in range(len(NFS)):
      nf = NFS[nfi]

      for di in range(len(DUPS)):
        dup = DUPS[di]

        fw = open("%s%s.%s.%s.%s.nf%d.dup%d.f1.txt" % (output_dir, classifier, sensor, type, score, nf, dup), 'w')

        ret = [[]] * len(MONTHS)
        for mi1 in range(len(MONTHS)):
          mon1 = MONTHS[mi1]

          ret[mi1] = [0] * len(MONTHS)

          for mi2 in range(len(MONTHS)):
            mon2 = MONTHS[mi2]

            # C45.weka_201605.train201605.norm.fix.combine.nf80.dup200.result.txt
            tmp = get_results("%s%s.weka_%s%d.train%d.%s.%s.nf%d.dup%d.result.txt" % (input_dir, classifier, sensor, mon1, mon2, type, score, nf, dup))
            print tmp

            ret[mi1][mi2] = tmp[7];

            if mi2 > 0: fw.write(", ")
            fw.write("%f" % (tmp[7]))

          fw.write("\n")
