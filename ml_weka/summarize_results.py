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
input_dir  = "../../data/ml_weka/"
output_dir = "../../data/ml_weka/summary/"
# fig_dir    = "../../data/ml_weka/summary/"

TYPE = "norm.fix"
MON  = 54567645

## =====================
## Variables
## =====================
# classifier = "NaiveBayes"
# classifier = "C45"
# classifier = "SVM"
classifier = "LIBSVM"

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


## =====================
## normalized, non-normalization, imbalanced
## =====================
print "========================================="
print "> normalized, non-normalization, imbalanced"

# file_prefix = "weka_4567"
file_prefix = "weka_%d" % (MON)

ret = []

print "orig"
tmp = get_results("%s%s.%s.fix.%s.fix.result.txt" % (input_dir, classifier, file_prefix, file_prefix))
print tmp
ret.append(tmp)

print "norm"
tmp = get_results("%s%s.%s.norm.fix.%s.norm.fix.result.txt" % (input_dir, classifier, file_prefix, file_prefix))
print tmp
ret.append(tmp)

print "balance"
tmp = get_results("%s%s.%s.fix.bal200.%s.fix.result.txt" % (input_dir, classifier, file_prefix, file_prefix))
print tmp
ret.append(tmp)

print "filter"
tmp = get_results("%s%s.%s.fix.fltr.%s.fix.fltr.result.txt" % (input_dir, classifier, file_prefix, file_prefix))
print tmp
ret.append(tmp)

print "norm-balance"
tmp = get_results("%s%s.%s.norm.fix.bal200.%s.norm.fix.result.txt" % (input_dir, classifier, file_prefix, file_prefix))
print tmp
ret.append(tmp)

print "norm-filter"
tmp = get_results("%s%s.%s.norm.fix.fltr.%s.norm.fix.fltr.result.txt" % (input_dir, classifier, file_prefix, file_prefix))
print tmp
ret.append(tmp)

print "balance-filter"
tmp = get_results("%s%s.%s.fix.fltr.bal200.%s.fix.fltr.result.txt" % (input_dir, classifier, file_prefix, file_prefix))
print tmp
ret.append(tmp)

print "norm-balance-filter"
tmp = get_results("%s%s.%s.norm.fix.fltr.bal200.%s.norm.fix.fltr.result.txt" % (input_dir, classifier, file_prefix, file_prefix))
print tmp
ret.append(tmp)


filename = "%s%s.norm_bal_fltr.txt" % (output_dir, classifier)
f = open(filename, 'w')
f.write("##orig\tnorm\tbal\tfltr\tnorm-bal\tnorm-fltr\tbal-fltr\tnorm-bal-fltr\n")
f.write("\"Precision\"\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n" % (ret[0][5],ret[1][5],ret[2][5],ret[3][5],ret[4][5],ret[5][5],ret[6][5],ret[7][5]))
f.write("\"Recall\"\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n" % (ret[0][6],ret[1][6],ret[2][6],ret[3][6],ret[4][6],ret[5][6],ret[6][6],ret[7][6]))
f.write("\"F1\"\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n" % (ret[0][7],ret[1][7],ret[2][7],ret[3][7],ret[4][7],ret[5][7],ret[6][7],ret[7][7]))
f.close()
# exit()


## =====================
## Data Size
## =====================
print "========================================="
print "> Data Size"

# months = [4,45,456,4567]
# months = [201504, 20150405,2015040506,201504050607]
months = [201504, 545, 5456, 54567, 5456764, 54567645]

# filename = "%s%s.dataset_size.txt" % (output_dir, classifier)
# f = open(filename, 'w')
# f.write("##dataset_size\tPrecision\tRecall\tF1-score\n")

h, w = 3, len(months)
data = [[0 for x in range(w)] for y in range(h)]

size = 0
for mon in months:
  file_prefix = "weka_%d.%s" % (mon, TYPE)
  size += 1

  ## All
  print "mon=%d: All" % (mon)
  ret = get_results("%s%s.%s.bal200.%s.result.txt" % (input_dir, classifier, file_prefix, file_prefix))
  print ret

  data[0][size-1] = ret[5]
  data[1][size-1] = ret[6]
  data[2][size-1] = ret[7]

  # f.write("%d\t%f\t%f\t%f\n" % (size, ret[5], ret[6]], ret[7]))

# f.close()

filename = "%s%s.dataset_size.txt" % (output_dir, classifier)
f = open(filename, 'w')
f.write("##Metric\t1\t2\t3\t4\t5\n")

for hi in range(h):
  if hi == 0: f.write("\"Precision\"")
  elif hi == 1: f.write("\"Recall\"")
  elif hi == 2: f.write("\"F1\"")

  for wi in range(w):
    f.write("\t%f" % (data[hi][wi]))

  f.write("\n")

f.close()


## =====================
## Number of Duplication
## =====================
print "========================================="
print "> Number of Duplication"

# dups = [0, 100, 150, 200]
dups = [0, 100, 200]

# filename = "%s%s.dataset_size.txt" % (output_dir, classifier)
# f = open(filename, 'w')
# f.write("##dataset_size\tPrecision\tRecall\tF1-score\n")

h, w = 3, len(dups)
data = [[0 for x in range(w)] for y in range(h)]

size = 0
for dup in dups:
  # file_prefix = "weka_4567.norm.fix.fltr"
  file_prefix = "weka_%d.%s" % (MON, TYPE)
  size += 1

  ## All
  print "dup=%d" % (dup)
  if dup == 0:
    filename = "%s%s.%s.%s.result.txt" % (input_dir, classifier, file_prefix, file_prefix)
  else:
    filename = "%s%s.%s.bal%d.%s.result.txt" % (input_dir, classifier, file_prefix, dup, file_prefix)

  ret = get_results(filename)
  print ret

  data[0][size-1] = ret[5]
  data[1][size-1] = ret[6]
  data[2][size-1] = ret[7]

  # f.write("%d\t%f\t%f\t%f\n" % (size, ret[5], ret[6], ret[7]))

# f.close()

filename = "%s%s.balance.txt" % (output_dir, classifier)
f = open(filename, 'w')
f.write("##Metric\t0\t100\t150\t200\n")

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
months = [201504,201505,201506,201507,201604,201605,545,5456,54567,5456764,54567645]
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

  file_prefix = "weka_%d.%s" % (mon, TYPE)
  hi = 0

  ## All
  print "mon=%d: All" % (mon)
  ret1 = get_results("%s%s.%s.bal200.%s.result.txt" % (input_dir, classifier, file_prefix, file_prefix))
  print ret1
  # f.write("\"All\"\t%f\t%f\t%f\n" % (ret1[5], ret1[6], ret1[7]))
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
  ret2 = get_results("%s%s.%s.bal200.%s.%s.result.txt" % (input_dir, classifier, file_prefix, file_prefix, fs_suffix))
  print ret2
  # f.write("\"FCBF\"\t%f\t%f\t%f\n" % (ret2[5], ret2[6], ret2[7]))
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
  ret3 = get_results("%s%s.%s.bal200.%s.%s.result.txt" % (input_dir, classifier, file_prefix, file_prefix, fs_suffix))
  print ret3
  # f.write("\"CFS:N=%d\"\t%f\t%f\t%f\n" % (nf, ret3[5], ret3[6], ret3[7]))
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
    ret4 = get_results("%s%s.%s.bal200.%s.%s.result.txt" % (input_dir, classifier, file_prefix, file_prefix, fs_suffix))
    print ret4
    # f.write("\"Gain:N=%d\"\t%f\t%f\t%f\n" % (nf, ret4[5], ret4[6], ret4[7]))
    data_type.append("Gain,N=%d" % (nf))
    data_pre[hi][mi] = ret4[5]
    data_rec[hi][mi] = ret4[6]
    data_f1[hi][mi]  = ret4[7]
    hi += 1

  # f.close()

  filename = "%s%s.feature_selection.%d.txt" % (output_dir, classifier, mon)
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

# filename = "%s%s.feature_selection.txt" % (output_dir, classifier)
# f = open(filename, 'w')
# for hi in range(h):
#   f.write("\"%s\"" % (data_type[hi]))
#   print "%s" % (data_type[hi]) ,
#   for wi in range(w):
#     f.write("\t%f" % (data_f1[hi][wi]))
#     print ",%f" % (data_f1[hi][wi]) ,
#   f.write("\n")
#   print ""
# f.close()


## =====================
## Time
## =====================
print "========================================="
print "> Time"

# train_months = [4,5,6,7,45,456,4567]
# test_months  = [4,5,6,7]
train_months = [201504,201505,201506,201507,201604,201605,545,5456,54567,5456764,54567645]
test_months  = [201504,201505,201506,201507,201604,201605]
time_types   = ["norm.fix", "norm.fix.fltr"]

for time_type in time_types:
  for train_mon in train_months:
    filename = "%s%s.time.%d.%s.txt" % (output_dir, classifier, train_mon, time_type)
    f = open(filename, 'w')
    f.write("##Test_Month\tPrecision\tRecall\tF1-score\n")

    for test_mon in test_months:

      print "train=%d,test=%d,type=%s: All" % (train_mon, test_mon, time_type)

      train_file_prefix = "weka_%d.%s" % (train_mon, time_type)
      test_file_prefix = "weka_%d.%s" % (test_mon, time_type)
      ret1 = get_results("%s%s.%s.bal200.%s.result.txt" % (input_dir, classifier, train_file_prefix, test_file_prefix))
      print ret1
      f.write("%d\t%f\t%f\t%f\n" % (test_mon, ret1[5], ret1[6], ret1[7]))

    f.close()

## train for the next month
# train_months = [4,4,5,6]
# test_months  = [4,5,6,7]
train_months = [201504,201504,201505,201506,201507,201604]
test_months  = [201504,201505,201506,201507,201604,201605]

for time_type in time_types:

  filename = "%s%s.time.next.%s.txt" % (output_dir, classifier, time_type)
  f = open(filename, 'w')
  f.write("##Test_Month\tPrecision\tRecall\tF1-score\n")

  for i in xrange(len(train_months)):
    train_mon = train_months[i]
    test_mon  = test_months[i]

    print "train=%d,test=%d,type=%s: All" % (train_mon, test_mon, time_type)

    train_file_prefix = "weka_%d.%s" % (train_mon, time_type)
    test_file_prefix = "weka_%d.%s" % (test_mon, time_type)
    ret1 = get_results("%s%s.%s.bal200.%s.result.txt" % (input_dir, classifier, train_file_prefix, test_file_prefix))
    print ret1
    f.write("%d\t%f\t%f\t%f\n" % (test_mon, ret1[5], ret1[6], ret1[7]))

  f.close()

