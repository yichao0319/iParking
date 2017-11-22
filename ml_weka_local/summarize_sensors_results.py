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
##   python summarize_lora_results.py
##
######################################

import os, sys, math, random, re
import os.path
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
input_dir  = "../../data/ml_weka/"
output_dir = "../../data/ml_weka/summary/"
# fig_dir    = "../../data/ml_weka/summary/"


## =====================
## Variables
## =====================
# classifier = "NaiveBayes"
classifier = "C45"
# classifier = "SVM"
# sensor = ""
# sensor = "lora_"
# sensor = "light_"
sensors = ["", "lora_", "light_"]
TYPE = "norm.fix"


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

## =====================
## Check Input Parameters
## =====================
# if len(sys.argv) <= 1:
#     PARAM1 = 1
# else:
#     PARAM1 = sys.argv[1]


for si in range(len(sensors)):
  sensor = sensors[si]

  if sensor == "":
    sensorname = "magnet"
  elif sensor == "lora_":
    sensorname = "lora"
  elif sensor == "light_":
    sensorname = "light"
  else:
    print "wrong sensor: %s" % (sensor)
    exit()

  print ""
  print "#############################"
  print "## %s" % (sensorname)
  print "#############################"


  VALID = ""
  if sensor != "":
    VALID = ".valid"



  ## =====================
  ## Number of Duplication
  ## =====================
  print "========================================="
  print "> Number of Duplication"

  # dups = [0, 100, 150, 200]
  dups = [0, 100, 200]

  h, w = 3, len(dups)
  data = [[0 for x in range(w)] for y in range(h)]

  size = 0
  for dup in dups:
    file_prefix = "weka_%s201604.%s" % (sensor, TYPE)
    size += 1

    BAL = ""
    if dup > 0:
      BAL = ".bal%d" % (dup)

    ## All
    print "dup=%d" % (dup)
    filename = "%s%s.%s%s%s.%s.result.txt" % (input_dir, classifier, file_prefix, VALID, BAL, file_prefix)


    ret = get_results(filename)
    print ret

    data[0][size-1] = ret[5]
    data[1][size-1] = ret[6]
    data[2][size-1] = ret[7]

    # f.write("%d\t%f\t%f\t%f\n" % (size, ret[4], ret[5], ret[6]))

  # f.close()

  filename = "%s%s.%s.balance.txt" % (output_dir, classifier, sensorname)
  f = open(filename, 'w')
  f.write("##Metric\t0\t100\t200\n")

  for hi in range(h):
    if hi == 0: f.write("\"Precision\"")
    elif hi == 1: f.write("\"Recall\"")
    elif hi == 2: f.write("\"F1\"")

    for wi in range(w):
      f.write("\t%f" % (data[hi][wi]))

    f.write("\n")

  f.close()


  ## =====================
  ## Feature Selection
  ## =====================
  print "========================================="
  print "> Feature Selection"

  # months = [4,5,6,7,45,456,4567]
  months = [201604,201605]
  nfs = [10,30,50]

  h, w = len(nfs)+3, len(months)
  data_pre = [[0 for x in range(w)] for y in range(h)]
  data_rec = [[0 for x in range(w)] for y in range(h)]
  data_f1  = [[0 for x in range(w)] for y in range(h)]
  mi = 0
  data_type = []
  for mon in months:

    # filename = "%s%s.feature_selection.%d.txt" % (output_dir, classifier, mon)
    # f = open(filename, 'w')
    # f.write("##FS_type\tPrecision\tRecall\tF1-score\n")

    file_prefix = "weka_%s%d.%s" % (sensor, mon, TYPE)
    hi = 0

    ## All
    print "mon=%d: All" % (mon)
    ret1 = get_results("%s%s.%s%s.bal200.%s.result.txt" % (input_dir, classifier, file_prefix, VALID, file_prefix))
    print ret1
    # f.write("\"All\"\t%f\t%f\t%f\n" % (ret1[4], ret1[5], ret1[6]))
    data_type.append("All")
    data_pre[hi][mi] = ret1[5]
    data_rec[hi][mi] = ret1[6]
    data_f1[hi][mi]  = ret1[7]
    hi += 1

    ## FCBF
    print "mon=%d: FCBF" % (mon)
    search = "FCBFSearch"
    eva    = "SymmetricalUncertAttributeSetEval"
    nf     = 30
    direct = 1
    fs_suffix = "%s_%s_N%d_D%d" % (search, eva, nf, direct)
    ret2 = get_results("%s%s.%s%s.bal200.%s.%s.result.txt" % (input_dir, classifier, file_prefix, VALID, file_prefix, fs_suffix))
    print ret2
    # f.write("\"FCBF\"\t%f\t%f\t%f\n" % (ret2[4], ret2[5], ret2[6]))
    data_type.append("FCBF")
    data_pre[hi][mi] = ret2[5]
    data_rec[hi][mi] = ret2[6]
    data_f1[hi][mi]  = ret2[7]
    hi += 1

    ## BestFirst
    search = "BestFirst"
    eva    = "CfsSubsetEval"
    direct = 1
    nf     = 30
    print "mon=%d: BestFirst, N=%d" % (mon, nf)
    fs_suffix = "%s_%s_N%d_D%d" % (search, eva, nf, direct)
    ret3 = get_results("%s%s.%s%s.bal200.%s.%s.result.txt" % (input_dir, classifier, file_prefix, VALID, file_prefix, fs_suffix))
    print ret3
    # f.write("\"CFS:N=%d\"\t%f\t%f\t%f\n" % (nf, ret3[4], ret3[5], ret3[6]))
    data_type.append("CFS:N=%d" % (nf))
    data_pre[hi][mi] = ret3[5]
    data_rec[hi][mi] = ret3[6]
    data_f1[hi][mi]  = ret3[7]
    hi += 1

    ## Ranker
    search = "Ranker"
    eva    = "GainRatioAttributeEval"
    direct = 1
    for nf in nfs:
      print "mon=%d: Ranker, N=%d" % (mon, nf)
      fs_suffix = "%s_%s_N%d_D%d" % (search, eva, nf, direct)
      ret4 = get_results("%s%s.%s%s.bal200.%s.%s.result.txt" % (input_dir, classifier, file_prefix, VALID, file_prefix, fs_suffix))
      print ret4
      # f.write("\"Gain:N=%d\"\t%f\t%f\t%f\n" % (nf, ret4[4], ret4[5], ret4[6]))
      data_type.append("Gain,N=%d" % (nf))
      data_pre[hi][mi] = ret4[5]
      data_rec[hi][mi] = ret4[6]
      data_f1[hi][mi]  = ret4[7]
      hi += 1

    # f.close()

    filename = "%s%s.feature_selection.%s.%d.txt" % (output_dir, classifier, sensorname, mon)
    f = open(filename, 'w')
    f.write("##FS_type\tAll\tFCBF\tCFS\tGain[10,30,50]\n")

    f.write("\"Precision\"")
    for hj in range(h):
      f.write("\t%f" % (data_pre[hj][mi]))
    f.write("\n")

    f.write("\"Recall\"")
    for hj in range(h):
      f.write("\t%f" % (data_rec[hj][mi]))
    f.write("\n")

    f.write("\"F1\"")
    for hj in range(h):
      f.write("\t%f" % (data_f1[hj][mi]))
    f.write("\n")

    f.close()

    mi += 1


  ## =====================
  ## Time
  ## =====================
  print "========================================="
  print "> Time"

  # train_months = [4,5,6,7,45,456,4567]
  # test_months  = [4,5,6,7]
  train_months = [201604]
  test_months  = [201605]

  for train_mon in train_months:
    filename = "%s%s.time.%d.txt" % (output_dir, classifier, train_mon)
    f = open(filename, 'w')
    f.write("##Test_Month\tPrecision\tRecall\tF1-score\n")

    for test_mon in test_months:
      print "train=%d,test=%d: All" % (train_mon, test_mon)

      train_file_prefix = "weka_%s%d.%s" % (sensor, train_mon, TYPE)
      test_file_prefix = "weka_%s%d.%s" % (sensor, test_mon, TYPE)
      ret1 = get_results("%s%s.%s%s.bal200.%s.result.txt" % (input_dir, classifier, train_file_prefix, VALID, test_file_prefix))
      print ret1
      f.write("%d\t%f\t%f\t%f\n" % (test_mon, ret1[5], ret1[6], ret1[7]))

    f.close()

