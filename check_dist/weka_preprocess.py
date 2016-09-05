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
##   python weka_preprocess.py 'norm.fix'
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

months  = [201504, 201505, 201506, 201507, 201604, 201605]
sensors = [""]
# scores  = ["stable", "combine"]
scores  = ["combine"]
num_f   = [1, 5, 10, 20, 40, 60, 80, 100, 108]
dups    = [100, 200]
nmon = len(months)
nsen = len(sensors)
nscr = len(scores)
ndup = len(dups)


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
## Main
## =====================

## =======================
## Check Input Parameters
## =======================
if len(sys.argv) != 2:
  print "FORMAT: weka_preprocess type"
  exit()

type = sys.argv[1]


for si in range(nscr):
  for sj in range(nsen):
    weka_sensor = ""
    if sensors[sj] != "": weka_sensor = "%s_" % (sensors[sj])

    for mi1 in range(nmon):
      for mi2 in range(nmon):
        print "  mon1=%d, mon2=%d, sensor=%s, type=%s, score=%s" % (months[mi1], months[mi2], sensors[sj], type, scores[si])

        feature_idx, feature_scores = get_feature_score(months[mi1], months[mi2], sensors[sj], type, scores[si], input_score_dir)
        nf = max(feature_idx)
        print "  > # total features = %d" % (nf)

        ## make sure number of selected features <= number of features
        this_num_f = []
        for x in num_f:
          if x <= nf:
            this_num_f.append(x)

        for nsfi in range(len(this_num_f)):
          nsf = this_num_f[nsfi]

          ## prepare for variables: features
          features = ""
          for fi in range(nsf):
            if fi > 0:
              features += ","

            features += "%d" % (feature_idx[fi]-1)  ## weka file idx from 0

          print "  > # selected features = %d: %s" % (nsf, features)

          ## prepare for variables: train input file
          input_filename1 = "%sweka_%s%d.%s.arff" % (input_sensor_dir, weka_sensor, months[mi1], type)

          print "  > train input filename = %s" % (input_filename1)

          ## prepare for variables: train output file
          output_filename1 = "%sweka_%s%d.train%d.%s.%s.nf%d.dup0.arff" % (output_dir, weka_sensor, months[mi1], months[mi2], type, scores[si], nsf)

          print "  > train output filename = %s" % (output_filename1)

          ## prepare for variables: test input file
          input_filename2 = "%sweka_%s%d.%s.arff" % (input_sensor_dir, weka_sensor, months[mi2], type)

          print "  > test input filename = %s" % (input_filename2)

          ## prepare for variables: test output file
          output_filename2 = "%sweka_%s%d.test%d.%s.%s.nf%d.dup0.arff" % (output_dir, weka_sensor, months[mi2], months[mi1], type, scores[si], nsf)

          print "  > test output filename = %s" % (output_filename2)


          # call(["java", "weka.filters.unsupervised.attribute.Remove", "-R", features, "-i", input_filename1, "-o", output_filename1])

          # call(["java", "weka.filters.unsupervised.attribute.Remove", "-R", features, "-i", input_filename2, "-o", output_filename2])


          for di in range(ndup):
            dup = dups[di]

            output_filename1_dup = "%sweka_%s%d.train%d.%s.%s.nf%d.dup%d.arff" % (output_dir, weka_sensor, months[mi1], months[mi2], type, scores[si], nsf, dup)
            print "  >> train output filename w/ dup = %s" % (output_filename1_dup)

            output_filename2_dup = "%sweka_%s%d.train%d.%s.%s.nf%d.dup%d.arff" % (output_dir, weka_sensor, months[mi1], months[mi2], type, scores[si], nsf, dup)
            print "  >> test output filename w/ dup = %s" % (output_filename2_dup)

            # call(["java", "weka.filters.supervised.instance.Resample", "-i", output_filename1, "-o", output_filename1_dup, "-c", "last", "-Z", "%d" % (dup), "-B", "1"])
