#!/usr/bin/env python

######################################
##
## Yi-Chao Chen @ UT Austin
##
## - Input
##    1. classifier
##    2. training month
##    3. training type
##    4. balance
##    5. testing month
##    6. testing type
##    7. tolerant range: allowed time difference between real and estimated event
## - Output
##
## - Example
##   python eval_pred_sensors.py NaiveBayes 201604 norm.fix 200 201604 norm.fix 100
##   python eval_pred_sensors.py C45 201604 norm.fix 200 201605 norm.fix 100
##   python eval_pred_sensors.py NaiveBayes 201604 norm.fix 200 201604 norm.fix.BestFirst_CfsSubsetEval_N30_D1 100
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
DEBUG2 = 1
DEBUG3 = 1
DEBUG4 = 1


## =====================
## Constant
## =====================
input_pred_dir = "../../data/ml_weka/"
input_data_dir = "../../data/sensor/"
output_dir = "../../data/ml_weka/"
fig_dir = "../../data/ml_weka/prob/"

TP = 1
TN = 2
FP = 3
FN = 4

sensors = ["", "lora_", "light_"]
nf = len(sensors)


## =====================
## Variables
## =====================


## =====================
## Check Input Parameters
## =====================
if len(sys.argv) <= 7:
  print "FORMAT: filename range"
  exit()

classifier = sys.argv[1]
mon1       = sys.argv[2]
prefix     = sys.argv[3]
dup        = int(sys.argv[4])
mon2       = sys.argv[5]
suffix     = sys.argv[6]
rng        = int(sys.argv[7])



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

filename       = [""] * nf
valid_idx_name = [""] * nf
valid_idx = [set()] * nf

for fi in range(nf):

  valid = ""
  if sensors[fi] != "":
    valid = ".valid"

    valid_idx_name[fi] = "%svalid_idx_%s%s.txt" % (input_data_dir, sensors[fi], mon2)
    valid_idx[fi] = get_valid_idx(valid_idx_name[fi])

  filename[fi] = "%s.weka_%s%s.%s%s%s.weka_%s%s.%s" % (classifier, sensors[fi], mon1, prefix, valid, bal, sensors[fi], mon2, suffix)


  if DEBUG3:
    print "  [FILE] %s" % (filename[fi])
    if valid_idx_name[fi]:
      print "  [VALID] %s" % (valid_idx_name[fi])
      print "    %s: #valid=%d" % (sensors[fi], len(valid_idx[fi]))


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

ret = [[]] * nf
labels = [[]] * nf
preds  = [[]] * nf
probs  = [[]] * nf

tp = [0] * nf
tn = [0] * nf
fp = [0] * nf
fn = [0] * nf
iv = [0] * nf

state = [[]] * nf

prob_truth     = [[]] * nf
prob_false     = [[]] * nf
prob_fp        = [[]] * nf
prob_fn        = [[]] * nf
prob_truth_sum = [0.0] * nf
prob_truth_cnt = [0] * nf
prob_false_sum = [0.0] * nf
prob_false_cnt = [0] * nf
prob_fp_sum    = [0.0] * nf
prob_fp_cnt    = [0] * nf
prob_fn_sum    = [0.0] * nf
prob_fn_cnt    = [0] * nf

precision = [0] * nf
recall    = [0] * nf
f1        = [0] * nf

for fi in range(nf):
  if DEBUG2: print "  FILE: %s%s.pred.csv" % (input_pred_dir, filename[fi])

  ret[fi] = get_prediction("%s%s.pred.csv" % (input_pred_dir, filename[fi]))
  labels[fi] = ret[fi][0]
  preds[fi]  = ret[fi][1]
  probs[fi]  = ret[fi][2]

  state[fi]  = [0] * len(labels[fi])


  ## =====================
  ## Evaluation
  ## =====================
  if DEBUG2: print "Evaluation"


  # tp[fi] = 0
  # tn[fi] = 0
  # fp[fi] = 0
  # fn[fi] = 0
  # iv[fi] = 0

  # prob_truth[fi] = []
  # prob_false[fi] = []
  # prob_fp[fi]    = []
  # prob_fn[fi]    = []
  # prob_truth_sum[fi] = 0.0
  # prob_truth_cnt[fi] = 0
  # prob_false_sum[fi] = 0.0
  # prob_false_cnt[fi] = 0
  # prob_fp_sum[fi]    = 0.0
  # prob_fp_cnt[fi]    = 0
  # prob_fn_sum[fi]    = 0.0
  # prob_fn_cnt[fi]    = 0

  nd = len(labels[fi])
  for i in xrange(0, nd):
    ## ----------
    ## SANITY CHECK
    # if labels1[i] != labels2[i] or labels1[i] != labels3[i]:
    #   print "[ERROR] the labels are different at index %d" % (i)
    #   exit()
    ## ----------

    if sensors[fi] != "" and (i+1) not in valid_idx[fi]:
      iv[fi] += 1
      continue

    state[fi][i] = check_correctness(labels[fi], preds[fi], i, rng)

    if state[fi][i] == TP:
      tp[fi] += 1
      prob_truth[fi].append(probs[fi][i])
      prob_truth_cnt[fi] += 1
      prob_truth_sum[fi] += probs[fi][i]
    elif state[fi][i] == FP:
      fp[fi] += 1
      prob_false[fi].append(probs[fi][i])
      prob_false_cnt[fi] += 1
      prob_false_sum[fi] += probs[fi][i]

      prob_fp[fi].append(probs[fi][i])
      prob_fp_cnt[fi] += 1
      prob_fp_sum[fi] += probs[fi][i]
    elif state[fi][i] == TN:
      tn[fi] += 1
      prob_truth[fi].append(probs[fi][i])
      prob_truth_cnt[fi] += 1
      prob_truth_sum[fi] += probs[fi][i]
    elif state[fi][i] == FN:
      fn[fi] += 1
      prob_false[fi].append(probs[fi][i])
      prob_false_cnt[fi] += 1
      prob_false_sum[fi] += probs[fi][i]

      prob_fn[fi].append(probs[fi][i])
      prob_fn_cnt[fi] += 1
      prob_fn_sum[fi] += probs[fi][i]

  precision[fi] = 0
  if (tp[fi]+fp[fi]) > 0:
    precision[fi] = float(tp[fi]) / (tp[fi] + fp[fi])

  recall[fi] = 0
  if (tp[fi] + fn[fi]) > 0:
    recall[fi] = float(tp[fi]) / (tp[fi] + fn[fi])

  f1[fi] = 0
  if (precision[fi]+recall[fi]) > 0:
    f1[fi] = 2*precision[fi]*recall[fi]/(precision[fi]+recall[fi])

  if prob_truth_cnt[fi] > 0: prob_truth_sum[fi] /= prob_truth_cnt[fi]
  if prob_false_cnt[fi] > 0: prob_false_sum[fi] /= prob_false_cnt[fi]
  if prob_fp_cnt[fi] > 0: prob_fp_sum[fi] /= prob_fp_cnt[fi]
  if prob_fn_cnt[fi] > 0: prob_fn_sum[fi] /= prob_fn_cnt[fi]

  print "FILE: %s%s.pred.csv" % (input_pred_dir, filename[fi])
  print "total=%d, tp=%d,tn=%d,fp=%d,fn=%d,iv=%d" % (tp[fi]+tn[fi]+fp[fi]+fn[fi]+iv[fi], tp[fi], tn[fi], fp[fi], fn[fi], iv[fi])
  print "precision=%.2f, recall=%.2f, f1=%.2f" % (precision[fi], recall[fi], f1[fi])
  print "prob: truth=%.2f, false=%.2f (fp=%.2f, fn=%.2f)" % (prob_truth_sum[fi], prob_false_sum[fi], prob_fp_sum[fi], prob_fn_sum[fi])


  ## =====================
  ## Confidence Distribution
  ## =====================
  if DEBUG2: print "Confidence Distribution"

  tmpret = pdf(probs[fi])
  x_all = tmpret[0]
  y_all = tmpret[1]

  tmpret = pdf(prob_truth[fi])
  x_truth = tmpret[0]
  y_truth = tmpret[1]

  tmpret = pdf(prob_false[fi])
  x_false = tmpret[0]
  y_false = tmpret[1]

  tmpret = pdf(prob_fp[fi])
  x_fp = tmpret[0]
  y_fp = tmpret[1]

  tmpret = pdf(prob_fn[fi])
  x_fn = tmpret[0]
  y_fn = tmpret[1]


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
  # plt.xlim((0.9,1))
  plt.xlabel("Confidence")
  plt.ylim((0,1))
  plt.ylabel("PDF")
  plt.legend(['all', 'T', 'F', 'FP', 'FN'], loc='best')
  plt.savefig("%s%s.prob_pdf.eps" % (fig_dir, filename[fi]), format='eps', dpi=1000)

  ## =====================
  ## Output Results
  ## =====================
  if DEBUG2: print "Output Results"

  f = open("%s%s.result.txt" % (output_dir, filename[fi]), 'w')
  f.write("%d,%d,%d,%d,%d,%f,%f,%f,%f,%f,%f,%f" % (tp[fi], tn[fi], fp[fi], fn[fi], iv[fi], precision[fi], recall[fi], f1[fi], prob_truth_sum[fi], prob_false_sum[fi], prob_fp_sum[fi], prob_fn_sum[fi]))
  f.close()


  f = open("%s%s.prob_pdf.txt" % (fig_dir, filename[fi]), 'w')
  for i in xrange(0, len(x_all)):
    f.write("%f\t%f\t%f\t%f\t%f\t%f\n" % (x_all[i], y_all[i], y_truth[i], y_false[i], y_fp[i], y_fn[i]))
  f.close()



f = open("%ssensors.%s.txt" % (output_dir, filename[0]), 'w')
for di in xrange(nd):
  for fi in xrange(nf):
    f.write("%d" % (state[fi][di]))
    if fi < nf-1:
      f.write("\t")
  f.write("\n")


