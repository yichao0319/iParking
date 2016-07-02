#!/usr/bin/env python

import os, sys, math, random, re
# import list_data

input_dir = "../../data/"
output_dir = "../../data/"


## read features 1
filename = input_dir + "data_.txt"
f = open(filename, 'r')

filename2 = output_dir + "data_2.txt"
f2 = open(filename2, 'w')

for line in f:
  line = line.strip()
  nf = 1
  m = re.search('(\d+):(-?\d+.\d+)2:(-?\d+.\d+)\s+(.*)', line)
  print m.group(1) + ":" + m.group(2) + " 2:" + m.group(3) + " " + m.group(4)
  f2.write(m.group(1) + ":" + m.group(2) + " 2:" + m.group(3) + " " + m.group(4) + "\n")

  # while :
  #   pass

  # print m.groups()

f.close()
f2.close()

