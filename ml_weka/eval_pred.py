#!/usr/bin/env python

######################################
##
## Yi-Chao Chen @ UT Austin
##
## - Input
##    1. classifier
##    2. sensor
##    3. training month
##    4. training type
##    5. balance
##    6. testing month
##    7. testing type
##    8. tolerant range: allowed time difference between real and estimated event
## - Output
##
## - Example
##   python eval_pred.py "C45" "" 201604 norm.fix 200 201604 norm.fix 100
##
######################################

import os, sys, math, random, re
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

from os import listdir
# import list_data

## =====================
## DEBUG
## =====================
DEBUG0 = 0
DEBUG1 = 1
DEBUG2 = 0
DEBUG3 = 1
DEBUG4 = 1

TP = 1
TN = 2
FP = 3
FN = 4


## =====================
## Constant
## =====================
input_pred_dir = "../../data/ml_weka/"
input_data_dir = "../../data/sensor/"
output_dir = "../../data/ml_weka/"
fig_dir = "../../data/ml_weka/prob/"

## =====================
## Variables
## =====================


## =====================
## Check Input Parameters
## =====================
if len(sys.argv) <= 8:
  print "FORMAT: filename range"
  exit()

classifier = sys.argv[1]
sensor     = sys.argv[2]
mon1       = sys.argv[3]
prefix     = sys.argv[4]
dup        = int(sys.argv[5])
mon2       = sys.argv[6]
suffix     = sys.argv[7]
rng        = int(sys.argv[8])


## =====================
## FUNC: get_ground_truth
## =====================
def get_ground_truth(filename):
  start = 0
  labels = []

  f = open(filename, 'r')
  for line in f:
    line = line.strip()

    if start == 1:
      cols = line.split(',')
      nf = len(cols)
      if nf <= 2: continue

      labels.append(int(cols[nf-1]))
    else:
      m = re.match('@DATA', line, re.IGNORECASE)
      if m is not None:
        start = 1
        continue

  return labels
  # f.close()
  # m = re.match('(\d{4})(\d{2})(\d{2})', str)
  # if m is not None:
  #   return m.groups()
  # else:
  #   return None


## =====================
## FUNC: get_prediction
## =====================
def get_prediction(filename):
  start = 0
  labels = []
  preds  = []
  prob   = []

  f = open(filename, 'r')
  for line in f:
    line = line.strip()
    # print line

    m = re.match('(\d+),(\d+):(-?\d+),(\d+):(-?\d+),(\+?),(\d+\.?\d?)', line)
    if m is not None:
      labels.append(int(m.group(3)))
      preds.append(int(m.group(5)))
      prob.append(float(m.group(7)))

      # if prob[int(m.group((1)))-1] < 1:
      #   print m.groups()
      #   print labels[int(m.group((1)))-1]
      #   print preds[int(m.group((1)))-1]
      #   print prob[int(m.group((1)))-1]

  return [labels, preds, prob]


## =====================
## FUNC: cdf
## =====================
def cdf(data):
  data_size = len(data)

  # Set bins edges
  data_set = sorted(set(data))
  bins = [float(x)/1000 for x in xrange(0,1001)]

  # Use the histogram function to bin the data
  counts, bin_edges = np.histogram(data, bins=bins, density=False)

  if data_size > 0: counts = counts.astype(float)/data_size

  # Find the cdf
  cdf = np.cumsum(counts)

  x = bin_edges[0:-1]
  y = cdf

  return [x, y]


## =====================
## FUNC: pdf
## =====================
def pdf(data):
  data_size = len(data)

  # Set bins edges
  data_set = sorted(set(data))
  bins = [float(x)/100 for x in xrange(0,101)]

  # Use the histogram function to bin the data
  counts, bin_edges = np.histogram(data, bins=bins, density=False)

  if data_size > 0: counts = counts.astype(float)/data_size

  x = bin_edges[0:-1]
  y = counts

  return [x, y]


## =====================
## FUNC: get_valid_idx(filename)
## =====================
def get_valid_idx(filename):
  valid_idx = set()

  f = open(filename, 'r')
  for line in f:
    line = line.strip()
    valid_idx.add(int(line))

  return valid_idx



## =====================
## FUNC: check_correctness
## =====================
def check_correctness(labels, preds, i, rng):
  nd = len(labels)
  std_idx = max(0, i-rng)
  end_idx = min(nd, i+rng+1)

  ## True Positive, False Negative
  if labels[i] == 1:
    found = 0
    for j in xrange(std_idx, end_idx):
      if preds[j] == 1:
        found = 1
        break

    if found == 1:
      ## true positive
      return TP

    else:
      ## false negative
      ##   Avoid continuous false negative
      found = 0
      for j in xrange(std_idx, i):
        if labels[j] == 1:
          found = 1
          break
      if found == 0:
        return FN
      else:
        return TN

  ## False Positive
  if preds[i] == 1:
    found = 0
    j = 0
    for j in xrange(std_idx, end_idx):
      if labels[j] == 1:
        found = 1
        break

    if found == 0:
      return FP
    else:
      ## True Positive, should be captured above
      return TN

  ## True Negative
  return TN


## =====================
## Main
## =====================

## =====================
## Filenames
## =====================
if DEBUG2: print "Filenames"


bal = ""
if dup > 0:
  bal = ".bal%d" % (dup)

valid = ""
if sensor != "":
  valid = ".valid"

  valid_idx_name = "%svalid_idx_%s%s.txt" % (input_data_dir, sensor, mon2)
  valid_idx = get_valid_idx(valid_idx_name)

filename = "%s.weka_%s%s.%s%s%s.weka_%s%s.%s" % (classifier, sensor, mon1, prefix, valid, bal, sensor, mon2, suffix)


## =====================
## Get Ground Truth
## =====================
# if DEBUG2: print "Get Ground Truth"

# labels = get_ground_truth("%s%s.arff" % (input_data_dir, filename))
# print labels


## =====================
## Get Prediction
## =====================
if DEBUG2: print "Get Prediction"
if DEBUG2: print "  FILE: %s%s.pred.csv" % (input_pred_dir, filename)

ret = get_prediction("%s%s.pred.csv" % (input_pred_dir, filename))
labels = ret[0]
preds  = ret[1]
probs  = ret[2]


## =====================
## Evaluation
## =====================
if DEBUG2: print "Evaluation"

tp = 0
tn = 0
fp = 0
fn = 0
iv = 0

prob_truth = []
prob_false = []
prob_fp    = []
prob_fn    = []
prob_truth_sum = 0.0
prob_truth_cnt = 0
prob_false_sum = 0.0
prob_false_cnt = 0
prob_fp_sum    = 0.0
prob_fp_cnt    = 0
prob_fn_sum    = 0.0
prob_fn_cnt    = 0

nd = len(labels)
for i in xrange(0, nd):
  if sensor != "" and (i+1) not in valid_idx:
    iv += 1
    continue

  state = check_correctness(labels, preds, i, rng)

  if state == TP:
    tp += 1
    prob_truth.append(probs[i])
    prob_truth_cnt += 1
    prob_truth_sum += probs[i]
  elif state == FP:
    fp += 1
    prob_false.append(probs[i])
    prob_false_cnt += 1
    prob_false_sum += probs[i]

    prob_fp.append(probs[i])
    prob_fp_cnt += 1
    prob_fp_sum += probs[i]
  elif state == TN:
    tn += 1
    prob_truth.append(probs[i])
    prob_truth_cnt += 1
    prob_truth_sum += probs[i]
  elif state == FN:
    fn += 1
    prob_false.append(probs[i])
    prob_false_cnt += 1
    prob_false_sum += probs[i]

    prob_fn.append(probs[i])
    prob_fn_cnt += 1
    prob_fn_sum += probs[i]


precision = 0
if (tp+fp) > 0:
  precision = float(tp) / (tp + fp)

recall = 0
if (tp + fn) > 0:
  recall = float(tp) / (tp + fn)

f1 = 0
if (precision+recall) > 0:
  f1 = 2*precision*recall/(precision+recall)

if prob_truth_cnt > 0: prob_truth_sum /= prob_truth_cnt
if prob_false_cnt > 0: prob_false_sum /= prob_false_cnt
if prob_fp_cnt > 0: prob_fp_sum /= prob_fp_cnt
if prob_fn_cnt > 0: prob_fn_sum /= prob_fn_cnt

print "tp=%d,tn=%d,fp=%d,fn=%d,iv=%d" % (tp, tn, fp, fn, iv)
print "precision=%.2f, recall=%.2f, f1=%.2f" % (precision, recall, f1)
print "prob: truth=%.2f, false=%.2f (fp=%.2f, fn=%.2f)" % (prob_truth_sum, prob_false_sum, prob_fp_sum, prob_fn_sum)


## =====================
## Confidence Distribution
## =====================
if DEBUG2: print "Confidence Distribution"

ret = pdf(probs)
x_all = ret[0]
y_all = ret[1]

ret = pdf(prob_truth)
x_truth = ret[0]
y_truth = ret[1]

ret = pdf(prob_false)
x_false = ret[0]
y_false = ret[1]

ret = pdf(prob_fp)
x_fp = ret[0]
y_fp = ret[1]

ret = pdf(prob_fn)
x_fn = ret[0]
y_fn = ret[1]


# plt.plot(x_all, y_all, '-b.', x_truth, y_truth, '-r.', x_false, y_false, '-y.', x_fp, y_fp, '-g.', x_fn, y_fn, '-c.')
lh, = plt.plot(x_all, y_all, '-b.')
plt.setp(lh, linewidth=5.0, marker='o', ls='-')
lh, = plt.plot(x_truth, y_truth, '-r.')
plt.setp(lh, linewidth=4.0, marker='+', ls='--')
lh, = plt.plot(x_false, y_false, '-y.')
plt.setp(lh, linewidth=3.0, marker='x', ls='-.')
lh, = plt.plot(x_fp, y_fp, '-g.')
plt.setp(lh, linewidth=2.0, marker='.', ls='..')
lh, = plt.plot(x_fn, y_fn, '-c.')
plt.setp(lh, linewidth=1.0, marker=',', ls='-')
plt.xlim((0.8,1))
plt.xlabel("Confidence")
plt.ylim((0,1))
plt.ylabel("PDF")
plt.legend(['all', 'T', 'F', 'FP', 'FN'], loc='best')
plt.savefig("%s%s.prob_pdf.eps" % (fig_dir, filename), format='eps', dpi=1000)
# plt.title("Interpolation")
# plt.grid(True)


## =====================
## Output Results
## =====================
if DEBUG2: print "Output Results"

f = open("%s%s.result.txt" % (output_dir, filename), 'w')
f.write("%d,%d,%d,%d,%d,%f,%f,%f,%f,%f,%f,%f" % (tp, tn, fp, fn, iv, precision, recall, f1, prob_truth_sum, prob_false_sum, prob_fp_sum, prob_fn_sum))
f.close()


f = open("%s%s.prob_pdf.txt" % (fig_dir, filename), 'w')
for i in xrange(0, len(x_all)):
  f.write("%f\t%f\t%f\t%f\t%f\t%f\n" % (x_all[i], y_all[i], y_truth[i], y_false[i], y_fp[i], y_fn[i]))
f.close()
