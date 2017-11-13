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
##   python weka_preprocess.py train_mon test_mon "sensor" "type" "score" num_f dup "out_train_file" "out_test_file"
##
######################################


import os, sys, math, random, re
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
input_score_dir  = "../../data/check_dist/feature_score/"
input_sensor_dir = "../../data/sensor/"
output_dir       = "../../data/check_dist/weka_data/"

## select top "num_f" features based on score
# num_f   = [10, 50, 80, 100, 108]
# num_f   = [1, 60, 108]
# dups    = [100, 200]
# dups    = [200]
# ndup = len(dups)


## =====================
## FUNC: get_feature_score
## =====================
def get_feature_score(mon1, mon2, sensor, type, score, input_dir):
  feature_idx    = []
  feature_scores = []

  filename = "%s%d.%d.%s.%s.%s.txt" % (input_dir, mon1, mon2, sensor, type, score)

  f = open(filename, 'r')
  for line in f:
    line = line.strip()

    m = re.match('(\d+)\t+(\d+\.?\d*)', line)
    if m is None: break

    idx = int(m.group(1))
    score = float(m.group(2))
    # print "  line: %s" % (line)
    # print "  idx=%d, score=%f" % (idx, score)

    feature_idx.append(idx)
    feature_scores.append(score)

  f.close()

  return [feature_idx, feature_scores]


## =====================
## FUNC: get_remove_features_str
## =====================
def get_remove_features_str(feature_idx, nsf):
  nf = max(feature_idx)

  features = ""
  # for fi in range(nsf):
  #   if fi > 0:
  #     features += ","
  #   features += "%d" % (feature_idx[fi])
  first = 1
  for fi1 in xrange(1, nf+1):
    found = 0
    for fi2 in range(nsf):
      if fi1 == feature_idx[fi2]:
        found = 1
        break
    if found == 0:
      if first == 0:
        features += ","
      first = 0
      features += "%d" % (fi1)

  return features

## =====================
## Main
## =====================

## =======================
## Check Input Parameters
## =======================
if len(sys.argv) != 10:
  print "FORMAT: weka_preprocess train_mon test_mon sensor type score num_f dup out_train_file out_test_file"
  exit()

mon1           = int(sys.argv[1])
mon2           = int(sys.argv[2])
sensor         = sys.argv[3]
type           = sys.argv[4]
score          = sys.argv[5]
num_f          = int(sys.argv[6])
dup            = int(sys.argv[7])
out_train_file = sys.argv[8]
out_test_file  = sys.argv[9]

weka_sensor = ""
if sensor != "": weka_sensor = "%s_" % (sensor)

print "  mon1=%d, mon2=%d, sensor=%s, type=%s, score=%s, num_f=%d, dup=%d, out_train_file=%s, out_test_file=%s" % (mon1, mon2, sensor, type, score, num_f, dup, out_train_file, out_test_file)

feature_idx, feature_scores = get_feature_score(mon1, mon2, sensor, type, score, input_score_dir)
nf = max(feature_idx)
print "  > # total features = %d" % (nf)


## make sure number of selected features <= number of features
## XXX: assume it won't happen..

## prepare for variables: features
features = get_remove_features_str(feature_idx, num_f)
print "  > # selected features = %d: %s" % (num_f, features)

## prepare for variables: train input file
input_filename1 = "%sweka_%s%d.%s.arff.gz" % (input_sensor_dir, weka_sensor, mon1, type)
print "  > train input filename = %s" % (input_filename1)

## prepare for variables: train output file
# output_filename1 = "%sweka_%s%d.train%d.%s.%s.nf%d.dup0.arff" % (output_dir, weka_sensor, mon1, mon2, type, score, num_f)
output_filename1 = "%s%s.arff" % (output_dir, out_train_file)
print "  > train output filename = %s" % (output_filename1)

## prepare for variables: test input file
input_filename2 = "%sweka_%s%d.%s.arff.gz" % (input_sensor_dir, weka_sensor, mon2, type)
print "  > test input filename = %s" % (input_filename2)

## prepare for variables: test output file
# output_filename2 = "%sweka_%s%d.test%d.%s.%s.nf%d.dup0.arff" % (output_dir, weka_sensor, mon2, mon1, type, score, num_f)
output_filename2 = "%s%s.arff" % (output_dir, out_test_file)
print "  > test output filename = %s" % (output_filename2)


call(["java", "-classpath", "./:/u/yichao/bin/weka-3-8-0/weka.jar", "weka.filters.unsupervised.attribute.Remove", "-R", features, "-i", input_filename1, "-o", output_filename1])

call(["java", "-classpath", "./:/u/yichao/bin/weka-3-8-0/weka.jar", "weka.filters.unsupervised.attribute.Remove", "-R", features, "-i", input_filename2, "-o", output_filename2])

if dup > 0:

  # output_filename1_dup = "%sweka_%s%d.train%d.%s.%s.nf%d.dup%d.arff" % (output_dir, weka_sensor, mon1, mon2, type, score, num_f, dup)
  output_filename1_dup = "%s%s.dup.arff" % (output_dir, out_train_file)
  print "  >> train output filename w/ dup = %s" % (output_filename1_dup)

  call(["java", "-classpath", "./:/u/yichao/bin/weka-3-8-0/weka.jar", "weka.filters.supervised.instance.Resample", "-i", output_filename1, "-o", output_filename1_dup, "-c", "last", "-Z", "%d" % (dup), "-B", "1"])
  call(["mv", output_filename1_dup, output_filename1])

## compression
call(["gzip", output_filename1])
call(["gzip", output_filename2])
