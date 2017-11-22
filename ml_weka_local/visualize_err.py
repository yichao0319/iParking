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
##   python visualize_err.py weka_4.norm.fix.fltr NaiveBayes.weka_4.norm.fix.fltr.bal200.weka_4.norm.fix.fltr 100
##   python visualize_err.py weka_5.norm.fix.fltr NaiveBayes.weka_5.norm.fix.fltr.bal200.weka_5.norm.fix.fltr 100
##   python visualize_err.py weka_6.norm.fix.fltr NaiveBayes.weka_6.norm.fix.fltr.bal200.weka_6.norm.fix.fltr 100
##   python visualize_err.py weka_7.norm.fix.fltr NaiveBayes.weka_7.norm.fix.fltr.bal200.weka_7.norm.fix.fltr 100
##
######################################

import os, sys, math, random, re
from os import listdir
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt



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
fig_dir = "../../data/ml_weka/err/"


## =====================
## Variables
## =====================
fig_idx = 0
font_size = 10
plot_rng = 100


## =====================
## Check Input Parameters
## =====================
if len(sys.argv) != 4:
  print "[FORMAT] test_filename pred_filename rng"
  exit()

test_filename = sys.argv[1]
pred_filename = sys.argv[2]
rng           = int(sys.argv[3])



## =====================
## FUNC: get_ground_truth
## =====================
def get_ground_truth(filename):
  start = 0
  features = []
  labels   = []

  f = open(filename, 'r')
  for line in f:
    line = line.strip()

    if start == 1:
      cols = line.split(',')
      nf = len(cols)
      if nf <= 2: continue

      if len(features) == 0:
        for i in range(nf-1):
          tmp = [float(cols[i])]
          features.append(tmp)
      else:
        for i in range(nf-1):
          features[i].append(float(cols[i]))

      labels.append(int(cols[nf-1]))

    else:
      m = re.match('@DATA', line, re.IGNORECASE)
      if m is not None:
        start = 1
        continue

  return [features, labels]


## =====================
## FUNC: get_prediction
## =====================
def get_prediction(filename):
  start = 0
  labels = []
  preds  = []
  probs  = []

  f = open(filename, 'r')
  for line in f:
    line = line.strip()
    # print line

    m = re.match('(\d+),(\d+):(-?\d+),(\d+):(-?\d+),(\+?),(\d+\.?\d?)', line)
    if m is not None:
      labels.append(int(m.group(3)))
      preds.append(int(m.group(5)))
      probs.append(float(m.group(7)))

  return [labels, preds, probs]


## =====================
## FUNC: plot_features_rng
## =====================
def plot_features_rng(features, labels, preds, figname, std_idx, end_idx):
  nf = len(features)

  tmp_f = []
  for i in range(nf):
    tmp = features[i][std_idx:end_idx]
    tmp_f.append(tmp)

  tmp_l = labels[std_idx:end_idx]

  tmp_p = preds[std_idx:end_idx]

  plot_features(tmp_f, tmp_l, tmp_p, figname)


## =====================
## FUNC: plot_features
## =====================
def plot_features(features, labels, preds, figname):
  nf = len(features)
  nd = len(features[0])

  h, w = 4, 3
  nfig = int(math.ceil(nf*1.0/h/w))

  for i in range(nfig):
    fig = plt.figure(0)
    plt.clf()
    matplotlib.rcParams.update({'font.size': font_size})
    # plt.gca().set_color_cycle(['r', 'b', 'g', 'y', 'm'])

    for hi in range(h):
      for wi in range(w):
        subfig_idx = i*h*w + hi*w + wi
        if subfig_idx >= nf: break

        ax = fig.add_subplot(h, w, hi*w+wi+1)
        lh, = plt.plot(features[subfig_idx], '-b.')
        plt.setp(lh, ms=3)

        for j in range(nd):
          if labels[j] > 0:
            lh, = plt.plot(j, features[subfig_idx][j], 'ro')
            plt.setp(lh, marker='o', fillstyle='full', ms=5, \
                         markeredgecolor='none', markeredgewidth=1.0)

          if preds[j] > 0:
            lh, = plt.plot(j, features[subfig_idx][j], 'g*')
            plt.setp(lh, marker='o', fillstyle='full', ms=5, \
                         markeredgecolor='none', markeredgewidth=1.0)

        ## TEXT
        ax_xlim = ax.get_xlim()
        ax_ylim = ax.get_ylim()
        xx = ax_xlim[0] + (ax_xlim[1]-ax_xlim[0])*4/10
        yy = ax_ylim[0] + (ax_ylim[1]-ax_ylim[0])*8/10
        ax.text(xx, yy, "feature=%d" % (subfig_idx+1))

        ## TICK
        plt.tick_params(
          axis='x',          # changes apply to the x-axis
          which='both',      # both major and minor ticks are affected
          bottom='off',      # ticks along the bottom edge are off
          top='off',         # ticks along the top edge are off
          labelbottom='off') # labels along the bottom edge are off

        ax.grid(True)
    plt.savefig("%s.%d.eps" % (figname, i), format='eps', dpi=1000)
    return

## =====================
## Main
## =====================


## =====================
## Get Features, Labels, and Prediction
## =====================
if DEBUG2: print "> Get Features, Labels, and Prediction"

features, labels      = get_ground_truth("%s%s.arff" % (input_data_dir, test_filename))
labels2, preds, probs = get_prediction("%s%s.pred.csv" % (input_pred_dir, pred_filename))

nf = len(features)
nd = len(features[0])

if DEBUG3: print "  #gt data in features = %d" % (len(features[0]))
if DEBUG3: print "  #gt data in labels   = %d" % (len(labels))
if DEBUG3: print "  #pred data in labels = %d" % (len(labels2))
if DEBUG3: print "  #pred data in preds  = %d" % (len(labels2))
if DEBUG3: print "  #pred data in probs  = %d" % (len(labels2))
if DEBUG3: print "  nd                   = %d" % (nd)
if DEBUG3: print "  #features= %d" % (len(features))
if DEBUG3: print "  nf       = %d" % (nf)


## =====================
## FP
## =====================
if DEBUG2: print "> False Positive"

for i in range(nd):
  if preds[i] > 0:
    std_idx = max(0, i-rng)
    end_idx = min(nd, i+rng+1)
    found = 0
    for j in xrange(std_idx, end_idx):
      if labels[j] > 0:
        found = 1
        break
    if found == 1: continue

    ## false positive
    std_idx = max(0, i-plot_rng)
    end_idx = min(nd, i+plot_rng+1)

    if DEBUG3: print "  idx=%d" % (i)
    figname = "%s%s.fp.%d" % (fig_dir, pred_filename, i)
    plot_features_rng(features, labels, preds, figname, std_idx, end_idx)


## =====================
## FN
## =====================
if DEBUG2: print "> False Negative"

for i in range(nd):
  if labels[i] > 0:
    std_idx = max(0, i-rng)
    end_idx = min(nd, i+rng+1)
    found = 0
    for j in xrange(std_idx, end_idx):
      if preds[j] > 0:
        found = 1
        break
    if found == 1: continue

    ## false negative
    std_idx = max(0, i-plot_rng)
    end_idx = min(nd, i+plot_rng+1)

    if DEBUG3: print "  idx=%d" % (i)
    figname = "%s%s.fn.%d" % (fig_dir, pred_filename, i)
    plot_features_rng(features, labels, preds, figname, std_idx, end_idx)





