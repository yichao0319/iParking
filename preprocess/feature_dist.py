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
##   python feature_dist.py "" norm.fix 1
##   python feature_dist.py lora_ norm.fix.valid 1
##   python feature_dist.py light_ norm.fix.valid 1
##
######################################

import os, sys, math, random, re
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.mlab   as mlab
import matplotlib.pyplot as plt
from subprocess import call
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
input_data_dir = "../../data/sensor/"
output_dir = "../../data/feature_dist/"
fig_dir = "../../data/feature_dist/"

## =====================
## Variables
## =====================


## =====================
## FUNC: get_labels_features
## =====================
def get_labels_features(filename):
  start = 0
  labels   = []
  features = []

  ## check if arff is compressed
  is_compressed = 0
  if not os.path.isfile(filename):
    is_compressed = 1
  if is_compressed:
    print "  gunzip file"
    call(["gunzip", "%s.gz" % (filename)])


  f = open(filename, 'r')
  for line in f:
    line = line.strip()

    if start >= 1:
      cols = line.split(',')
      nf = len(cols)
      if nf <= 2: continue

      if start == 1:
        ## the first row, initialize features
        for x in range(nf-1):
          feature_x = [float(cols[x])]
          features.append(feature_x)
        start = 2
      else:
        for x in range(nf-1):
          features[x].append(float(cols[x]))

      labels.append(int(cols[-1]))

    else:
      m = re.match('@DATA', line, re.IGNORECASE)
      if m is not None:
        start = 1
        continue

  ## compress as it is
  if is_compressed:
    print "  gzip file"
    call(["gzip", filename])


  return [labels, features]



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
  # bins = [float(x)/100 for x in xrange(0,101)]

  # Use the histogram function to bin the data
  counts, bin_edges = np.histogram(data, bins=100, density=False)

  if data_size > 0: counts = counts.astype(float)/data_size

  x = bin_edges[0:-1]
  y = counts

  return [x, y]


## =====================
## FUNC: get_feature_dist
## =====================
def get_feature_dist(filename):
  ## ---------------------
  ## Get Features and Labels
  ## ---------------------
  if DEBUG2: print "Get Features and Labels"

  labels, features = get_labels_features(filename)
  # labels = ret[0]
  # features = ret[1]
  nf = len(features)

  print "  #features = %d" % (nf)
  print "  #data = %d (%d)" % (len(features[0]), len(labels))


  ## ---------------------
  ## Calculate Feature Distribution
  ## ---------------------
  if DEBUG2: print "Calculate Feature Distribution"

  ## PDF for all samples
  pdf_all = []
  for x in range(nf):
    # if DEBUG3: print "  feature %d" % (x)
    pdf_x = pdf(features[x])
    pdf_all.append(pdf_x)

  nb = len(pdf_all[0][0])

  ## PDF for all Positive and Negative samples
  features_pos = []
  features_neg = []
  for i in range(len(labels)):
    if i == 0:
      for x in range(nf):
        features_pos.append([])
        features_neg.append([])

    if labels[i] == 1:
      for x in range(nf):
        features_pos[x].append(features[x][i])
    else:
      for x in range(nf):
        features_neg[x].append(features[x][i])

  pdf_pos = []
  for x in range(nf):
    pdf_x = pdf(features_pos[x])
    pdf_pos.append(pdf_x)

  pdf_neg = []
  for x in range(nf):
    pdf_x = pdf(features_neg[x])
    pdf_neg.append(pdf_x)

  # print "  #bins = %d" % (nb)

  return [labels, features, pdf_all, pdf_pos, pdf_neg, nf, nb]


## =====================
## Main
## =====================

## =====================
## Check Input Parameters
## =====================
if len(sys.argv) < 3:
  print "FORMAT: sensor suffix [if_compare]"
  exit()

sensor = sys.argv[1]
suffix = sys.argv[2]
if_compare = 0
if len(sys.argv) == 4:
  if_compare = int(sys.argv[3])

if DEBUG2:
  print "Parameters:"
  print "  sensor=%s" % (sensor)
  print "  suffix=%s" % (suffix)
  print "  if_compare=%d" % (if_compare)


if sensor == "":
  months = [201504, 201505, 201506, 201507, 201508, 201509, 201510, 201511, 201512, 201601, 201604, 201605, 201608]
else:
  months = [201604, 201605]



for mon in months:

  filename = "weka_%s%d.%s" % (sensor, mon, suffix)
  if DEBUG2:
    print "========================"
    print "[FILE] %s" % (filename)


  ## =====================
  ## Get Feature Distribution
  ## =====================
  if DEBUG2: print "Get Feature Distribution"

  labels, features, pdf_all, pdf_pos, pdf_neg, nf, nb = get_feature_dist("%s%s.arff" % (input_data_dir, filename))
  # pdf_all = ret[0]
  # pdf_pos = ret[1]
  # pdf_neg = ret[2]
  # nf      = ret[3]
  # nb      = ret[4]


  ## =====================
  ## Output Results
  ## =====================
  if DEBUG2: print "Output Results"

  for x in range(nf):
    f = open("%sdist_%s%d.f%d.txt" % (output_dir, sensor, mon, x), 'w')

    pdf_all_x = pdf_all[x]
    pdf_pos_x = pdf_pos[x]
    pdf_neg_x = pdf_neg[x]

    for i in range(nb):
      f.write("%f\t%f\t%f\t%f\t%f\t%f\n" % (pdf_all_x[0][i], pdf_all_x[1][i], pdf_pos_x[0][i], pdf_pos_x[1][i], pdf_neg_x[0][i], pdf_neg_x[1][i]))

    f.close()


  ## =====================
  ## Plot Results
  ## =====================
  if DEBUG2: print "Plot Results"

  h = 4
  w = 3
  nfig = int(math.ceil(float(nf) / (w*h)))
  feature_idx = -1
  width = (pdf_all_x[0][1] - pdf_all_x[0][0])/3

  for fi in range(nfig):

    fig = plt.figure(fi)
    plt.clf()
    matplotlib.rcParams.update({'font.size': 10})
    fig_idx = 0

    for hi in range(h):
      for wi in range(w):
        feature_idx += 1
        fig_idx     += 1
        if feature_idx >= nf: break
        if DEBUG3: print "  feature %d" % (feature_idx)

        pdf_all_x = pdf_all[feature_idx]
        pdf_pos_x = pdf_pos[feature_idx]
        pdf_neg_x = pdf_neg[feature_idx]

        ax = fig.add_subplot(h, w, fig_idx)
        # ax.bar(pdf_all_x[0]-width*2/3, pdf_all_x[1], width, color='r', edgecolor='none')
        # ax.bar(pdf_pos_x[0], pdf_pos_x[1], width, color='b', edgecolor='none')
        # ax.bar(pdf_neg_x[0]+width*2/3, pdf_neg_x[1], width, color='g', edgecolor='none')
        l1, l2, l3 = plt.plot(pdf_all_x[0], pdf_all_x[1],
                                pdf_neg_x[0], pdf_neg_x[1],
                                pdf_pos_x[0], pdf_pos_x[1])
        plt.setp(l1, color='g', linewidth=5.0)
        plt.setp(l2, color='b', linewidth=2.0)
        plt.setp(l3, color='r', linewidth=1.0)

        this_x = ax.get_xlim()
        this_y = ax.get_ylim()
        xx = this_x[0] + (this_x[1]-this_x[0])*4/10
        yy = this_y[0] + (this_y[1]-this_y[0])*8/10
        ax.text(xx, yy, "feature %d" % (feature_idx+1))
        # if wi > 0:
        plt.tick_params(
          axis='y',          # changes apply to the x-axis
          which='both',      # both major and minor ticks are affected
          bottom='off',      # ticks along the bottom edge are off
          top='off',         # ticks along the top edge are off
          labelleft='off') # labels along the bottom edge are off
        # if hi != (h-1):
        #   plt.tick_params(
        #     axis='x',          # changes apply to the x-axis
        #     which='both',      # both major and minor ticks are affected
        #     bottom='off',      # ticks along the bottom edge are off
        #     top='off',         # ticks along the top edge are off
        #     labelbottom='off') # labels along the bottom edge are off

    # plt.figlegend( lines, labels, loc = 'lower center', ncol=5, labelspacing=0. )
    fig.legend( (l1,l2,l3), ('all', 'negative', 'positive'), 'upper center', ncol=3)
    plt.savefig("%s%s.dist.%d.eps" % (fig_dir, filename, feature_idx), format='eps', dpi=1000)




if if_compare != 1: exit()

## ==========================================
## Compare Distribution Across Months
## ==========================================
if DEBUG2: print "Compare Distribution Across Months"

mon_pdf_all = []
mon_pdf_pos = []
mon_pdf_neg = []

for mi in range(len(months)):
  mon = months[mi]
  if DEBUG3: print "  month: %d" % (mon)
  # filename = "weka_%d.norm.fix" % (mon)
  filename = "weka_%s%d.%s" % (sensor, mon, suffix)

  labels, features, pdf_all, pdf_pos, pdf_neg, nf, nb = \
    get_feature_dist("%s%s.arff" % (input_data_dir, filename))
  mon_pdf_all.append(pdf_all)
  mon_pdf_pos.append(pdf_pos)
  mon_pdf_neg.append(pdf_neg)


## =====================
## Output Results
## =====================
if DEBUG2: print "Output Results"

for x in range(nf):
  for si in range(3):
    f = open("%smonths_%s.%s.s%d.f%d.txt" % (fig_dir, sensor, suffix, si, x), 'w')

    for i in range(nb):
      for mi in range(len(months)):
        if si == 0:
          mon_pdf_this = mon_pdf_all[mi][x]
        elif si == 1:
          mon_pdf_this = mon_pdf_pos[mi][x]
        elif si == 2:
          mon_pdf_this = mon_pdf_neg[mi][x]

        if mi > 0:
          f.write("\t")

        f.write("%f\t%f" % (mon_pdf_this[0][i], mon_pdf_this[1][i]))

      f.write("\n")

    f.close()

h = 4
w = 3
nfig = int(math.ceil(float(nf) / (w*h)))
feature_idx = -1

for fi in range(nfig):
  ## for all, pos, neg samples
  for si in range(3):
    fig = plt.figure(fi)
    plt.clf()
    matplotlib.rcParams.update({'font.size': 10})
    # colormap = plt.cm.gist_ncar
    # plt.gca().set_color_cycle([colormap(i) for i in np.linspace(0, 0.9, num_plots)])
    plt.gca().set_color_cycle(['r', 'b', 'g', 'y', 'm'])
    fig_idx = 0

    feature_idx = h*w*fi-1
    for hi in range(h):
      for wi in range(w):
        feature_idx += 1
        fig_idx     += 1
        if feature_idx >= nf: break
        if DEBUG3: print "  feature %d" % (feature_idx)

        ax = fig.add_subplot(h, w, fig_idx)

        lhs     = []
        legends = []
        for mi in range(len(months)):
          mon = months[mi]
          mon_pdf_this = []
          if si == 0:
            mon_pdf_this = mon_pdf_all[mi][feature_idx]
          elif si == 1:
            mon_pdf_this = mon_pdf_pos[mi][feature_idx]
          elif si == 2:
            mon_pdf_this = mon_pdf_neg[mi][feature_idx]

          lh, = plt.plot(mon_pdf_this[0], mon_pdf_this[1])
          plt.setp(lh, linewidth=len(months)-mi+1)
          lhs.append(lh)
          legends.append('%d' % (mon))

        this_x = ax.get_xlim()
        this_y = ax.get_ylim()
        xx = this_x[0] + (this_x[1]-this_x[0])*4/10
        yy = this_y[0] + (this_y[1]-this_y[0])*8/10
        ax.text(xx, yy, "feature %d" % (feature_idx+1))
        plt.tick_params(
          axis='y',          # changes apply to the x-axis
          which='both',      # both major and minor ticks are affected
          bottom='off',      # ticks along the bottom edge are off
          top='off',         # ticks along the top edge are off
          labelleft='off') # labels along the bottom edge are off
        plt.tick_params(
          axis='x',          # changes apply to the x-axis
          which='both',      # both major and minor ticks are affected
          bottom='off',      # ticks along the bottom edge are off
          top='off',         # ticks along the top edge are off
          labelbottom='off') # labels along the bottom edge are off

    fig.legend(lhs, legends, 'upper center', ncol=5)
    plt.savefig("%smonths.%s.%s.s%d.%d.eps" % (fig_dir, sensor, suffix, si, feature_idx), format='eps', dpi=1000)
