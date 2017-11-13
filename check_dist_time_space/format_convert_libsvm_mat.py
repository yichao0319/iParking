#!/usr/bin/env python

import os, sys, math, random, re
from subprocess import call

input_dir = "../../data/sensor/"
output_dir = "../../data/check_dist_time_space/mat_space/"


## =====================
## FUNC: parse_feature
## =====================
def parse_feature_file(mon, file_id, input_dir, output_dir):
  features = []

  filename_src = "%s%d/data/data_TT_%s.txt.gz" % (input_dir, mon, file_id)
  filename_dst = "%s%d.%s.txt.gz" % (output_dir, mon, file_id)
  filename     = "%s%d.%s.txt" % (output_dir, mon, file_id)
  filename_mat = "%s%d.%s.mat.txt" % (output_dir, mon, file_id)

  call(["cp", filename_src, filename_dst])
  call(["gunzip", filename_dst])

  if not os.path.isfile(filename):
    print "[MISS] %s" % (filename)
    return

  f = open(filename, 'r')
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

  call(["gzip", "-f", filename_mat])
  call(["/bin/rm", "-f", filename])

  print "    #features=%d" % (nf)
  print "    #feature data=%d" % (len(features))



## =====================
## Main
## =====================

## =======================
## Check Input Parameters
## =======================
if len(sys.argv) != 3:
  print "FORMAT: month file_id"
  exit()

mon     = int(sys.argv[1])
file_id = sys.argv[2]
print "> MONTH=%d, ID=%s" % (mon, file_id)


## =======================
## Features
## =======================
print "  Parse Features"

parse_feature_file(mon, file_id, input_dir, output_dir)



## =======================
## Labels
## =======================
print "  Parse Labels"

labels = []
label_set = set()

filename = "%s%d/label/lableTT_%s.txt" % (input_dir, mon, file_id)
f = open(filename, 'r')

filename_fix = "%s%d.%s.label.txt" % (output_dir, mon, file_id)
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

print "    #label data=%d" % (len(labels))
print "    label set size=%d" % (len(label_set))

