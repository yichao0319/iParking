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
##   python format_convert_mat_arff.py data_4 label_4.fixed weka_4.fixed
##
######################################


import os, sys, math, random, re
# import list_data

input_dir = "../../data/sensor/"
output_dir = "../../data/sensor/"


## =====================
## Main
## =====================

## =======================
## Check Input Parameters
## =======================
if len(sys.argv) != 4:
  print "FORMAT: feature_file label_file output_weka_arff"
  exit()

feature_prefix = sys.argv[1]
label_prefix   = sys.argv[2]
weka_prefix    = sys.argv[3]


## =======================
## Features
## =======================
print "Parse Features"

features = []

filename = input_dir + feature_prefix + ".mat.txt"
f = open(filename, 'r')

for line in f:
  line = line.strip()

  m = re.match('(-?\d+)', line)
  if m is None: break

  if len(features) == 1:
    cols = line.split(',')
    nf = len(cols)

  features.append(line)

f.close()

print "  #features=%d" % (nf)
print "  #feature data=%d" % (len(features))


## =======================
## Parse Labels
## =======================
print "Parse Labels"

labels = []
label_set = set()

filename = input_dir + label_prefix + ".txt"
f = open(filename, 'r')

for line in f:
  line = line.strip()

  m = re.match('(-?\d+).*', line)
  if m is None: break

  label = int(line)
  label_set.add(label)
  labels.append(label)

f.close()

print "  #label data=%d" % (len(labels))
print "  label set size=%d" % (len(label_set))


## =======================
## Output ARFF File
## =======================
print "Output ARFF File"

filename_arff = output_dir + weka_prefix + ".arff"
f_arff = open(filename_arff, 'w')

## Write ARFF Header
f_arff.write("@RELATION %s\n\n" % (weka_prefix))

for fi in xrange(0,nf):
  f_arff.write("@ATTRIBUTE feature%d NUMERIC\n" % (fi))

f_arff.write("@ATTRIBUTE class {")
nlabel = 0
for labeli in label_set:
  nlabel += 1
  if nlabel > 1: f_arff.write(",")
  f_arff.write("%d" % (labeli))

f_arff.write("}\n\n")

## Write ARFF Data
f_arff.write("@DATA\n")
for ri in xrange(0, len(features)):
  row = features[ri]
  label = labels[ri]
  f_arff.write(row + "," + str(label) + "\n" )

f_arff.close()

