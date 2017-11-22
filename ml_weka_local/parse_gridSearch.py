#!/usr/bin/env python

import os, sys, math, random, re
from subprocess import call

## =====================
## FUNC: parse_feature
## =====================
def parse_gridSearch(file_prefix, file_gridSearch, input_dir, output_dir):

  filename = input_dir + file_prefix + ".txt"
  output_filename = output_dir + file_gridSearch + ".txt"

  #if not os.path.isfile(filename):
 #    print "[MISS] %s" % (filename)
#  return
 
  f = open(filename, 'r')
  f_grid = open(output_filename, 'w')

  row_cost = []
  row_gamma = []
  row_RMSE = []
 
  for line in f:

    line = line.strip()
    m = re.match('(^Performance+\s)(\(\[)(-?\d+.\d)(,+\s)(-?\d+.\d)(\]\):+\s)(NaN+\s)(\()(CC+\),+\s)(-?\d.+\d)(\s)(\()(RMSE+\))(.*)(.*)', line)

    if m is None:
      continue
    cost = float(m.group(3))
    gamma = float(m.group(5))
    RMSE = float(m.group(10))    
    row_cost.append(cost)
    row_gamma.append(gamma)
    row_RMSE.append(RMSE)
#    print "cost: '{0}', gamma: '{1}', RMSE: '{2}'".format(cost, gamma, RMSE)

  RMSE_tmp = 0
  cost_best = 0
  gamma_best = 0
  RMSE_smallest = row_RMSE[0]
  for i in range(0, len(row_RMSE)):
    RMSE_tmp = row_RMSE[i]
    if RMSE_smallest > RMSE_tmp:
        RMSE_smallest = RMSE_tmp
        cost_best = row_cost[i]
        gamma_best = row_gamma[i]
  print "Best parameter combination: cost: '{0}', gamma: '{1}', RMSE: '{2}'".format(cost_best, gamma_best, RMSE_smallest)
  f_grid.write(repr(cost_best))
  f_grid.write("\n")
  f_grid.write(repr(gamma_best))
  f_grid.write("\n")
  f_grid.write(repr(RMSE_smallest))

  f.close()
  f_grid.close()

## =====================
## Main
## =====================

## =======================
## Check Input Parameters
## =======================
if len(sys.argv) != 3:
  print "FORMAT: GridSearch_filename month"
  exit()

filename = sys.argv[1]
print "> filename=%s" % (filename)
mon = sys.argv[2]
print "> month=%s" % (mon)

input_dir = "../../data/sensor/SVM_sampling/"
output_dir ="../../data/sensor/SVM_sampling/"

input_dir = input_dir + mon + "/"
output_dir = output_dir + mon + "/"

## =======================
## Features
## =======================
print "  Parse Features"

#file_prefix = "data_%d" % (mon)
file_prefix = filename
file_gridSearch = "gridSearch_bestResult"
parse_gridSearch(file_prefix, file_gridSearch, input_dir, output_dir)
