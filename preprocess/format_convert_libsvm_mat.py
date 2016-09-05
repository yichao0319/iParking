#!/usr/bin/env python

import os, sys, math, random, re
from subprocess import call

input_dir = "../../data/sensor/"
output_dir = "../../data/sensor/"


## =====================
## FUNC: parse_feature
## =====================
def parse_feature_file(file_prefix, input_dir, output_dir):
  features = []

  filename = input_dir + file_prefix + ".txt"
  if not os.path.isfile(filename):
    print "[MISS] %s" % (filename)
    return

  f = open(filename, 'r')

  filename_mat = output_dir + file_prefix + ".mat.txt"
  f_mat = open(filename_mat, 'w')

  nl = 0
  nf_final = -1

  for line in f:
    nl += 1
    line = line.strip()
    # print line

    row = []
    m = re.match('(\d+):(-?\d+.\d+e*\+?\d*)\s+(.*)', line)
    if m is None: break

    prev_nf = -1

    while m is not None:

      ## get a feature
      nf = int(m.group(1))
      val = float(m.group(2))
      remain = m.group((3))
      # if nf == 78: val = 0
      # print ("> feautre %d = %g" % (nf, val))
      # print ("  remain=%s" % (remain))


      ##############
      ## BUG: two lines merge into one..
      if nf == 1 and nf < prev_nf:
        f_mat.write("\n")

      prev_nf = nf
      ##############


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


    ##############
    ## BUG: some lines have fewer features
    while nf < nf_final:
      # print "%d: %d/%d" % (nl, nf, nf_final)
      row.append(str(0))
      if nf > 1: f_mat.write(",")
      f_mat.write("0")
      nf += 1
    ##############

    nf_final = nf

    ## finish an entry
    f_mat.write("\n")
    features.append(row)


  f_mat.close()
  f.close()
  call(["rm", "-f", filename])

  print "    #features=%d" % (nf)
  print "    #feature data=%d" % (len(features))



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
parse_feature_file(file_prefix, input_dir, output_dir)



## =======================
## Labels
## =======================
print "  Parse Labels"

file_prefix = "label_%d" % (mon)

labels = []
label_set = set()

filename = input_dir + file_prefix + ".txt"
f = open(filename, 'r')

filename_fix = output_dir + file_prefix + ".fix.txt"
f_fix = open(filename_fix, 'w')

for line in f:
  line = line.strip()

  m = re.match('(-?\d+).*', line)
  if m is None: break

  label = int(line)
  label_set.add(label)
  labels.append(label)

  f_fix.write("%d\n" % (label))

f.close()
f_fix.close()

call(["mv", filename_fix, filename])

print "    #label data=%d" % (len(labels))
print "    label set size=%d" % (len(label_set))


## =======================
## Lora
## =======================
print "  Parse Lora Features"

file_prefix = "lora_%d" % (mon)
parse_feature_file(file_prefix, input_dir, output_dir)


## =======================
## Light
## =======================
print "  Parse Light Features"

file_prefix = "light_%d" % (mon)
parse_feature_file(file_prefix, input_dir, output_dir)
