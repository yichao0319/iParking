#!/usr/bin/env python

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
if len(sys.argv) != 2:
  print "FORMAT: month"
  exit()

mon = int(sys.argv[1])
print "> MONTH=%d" % (mon)


## =======================
## Features
## =======================
print "  Parse Features"

file_prefix = "data_%d" % (mon)

features = []

filename = input_dir + file_prefix + ".txt"
f = open(filename, 'r')

filename_mat = output_dir + file_prefix + ".mat.txt"
f_mat = open(filename_mat, 'w')


for line in f:
  line = line.strip()
  # print line

  row = []
  m = re.match('(\d+):(-?\d+.\d+e*\+?\d*)\s+(.*)', line)
  if m is None: break

  while m is not None:


    ## get a feature
    nf = int(m.group(1))
    val = float(m.group(2))
    remain = m.group((3))
    if nf == 78: val = 0
    # print ("> feautre %d = %g" % (nf, val))
    # print ("  remain=%s" % (remain))

    ## write the feature
    row.append(str(val))
    if nf > 1: f_mat.write(",")
    f_mat.write("%g" % (val))

    ## try to match the next feature
    m = re.match('(\d+):(-?\d+.\d+e?\+?\d*)\s+(.*)', remain)

    if m is None:
      m = re.match('(\d+):(-?\d+)\s+(.*)', remain)

    if m is None:
      m = re.match('(\d+):(-?\d+\.?\d*)(.*)$', remain)

    if m is None:
      m = re.match('(\d+):(-?\d+)(.*)', remain)

  ## finish an entry
  f_mat.write("\n")
  features.append(row)

f_mat.close()
f.close()

print "    #features=%d" % (nf)
print "    #feature data=%d" % (len(features))

## =======================
## Labels
## =======================
print "  Parse Labels"

file_prefix = "label_%d" % (mon)

labels = []
label_set = set()

filename = input_dir + file_prefix + ".txt"
f = open(filename, 'r')

for line in f:
  line = line.strip()

  m = re.match('(-?\d+).*', line)
  if m is None: break

  label = int(line)
  label_set.add(label)
  labels.append(label)

f.close()

print "    #label data=%d" % (len(labels))
print "    label set size=%d" % (len(label_set))


## =============
## Prepare for ARFF
# file_prefix = "data_%d" % (mon)
# filename_arff = output_dir + file_prefix + ".arff"
# f_arff = open(filename_arff, 'w')

# ## Write ARFF Header
# f_arff.write("@RELATION month%d\n\n" % (mon))

# for fi in xrange(0,nf):
#   f_arff.write("@ATTRIBUTE feature%d NUMERIC\n" % (fi))

# f_arff.write("@ATTRIBUTE class {")
# nlabel = 0
# for labeli in label_set:
#   nlabel += 1
#   if nlabel > 1: f_arff.write(",")
#   f_arff.write("%d" % (labeli))

# f_arff.write("}\n\n")

# ## Write ARFF Data
# f_arff.write("@DATA\n")
# for ri in xrange(0, len(features)):
#   row = features[ri]
#   label = labels[ri]
#   f_arff.write(",".join(row) + "," + str(label) + "\n" )

# f_arff.close()

