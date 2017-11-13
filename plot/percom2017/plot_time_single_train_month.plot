reset
set terminal postscript eps enhanced color 28 dl 0.4
# set terminal png enhanced 28 size 800,600
# set terminal jpeg enhanced font helvetica 28
set size ratio 0.5

data_dir = "./data/train_fix/"
fig_dir  = "./figs/"
fig_name  = "temporal_single_mon"

set xlabel '{/Helvetica=28 Test Month}' offset character 0, 0, 0

set tics font "Helvetica,24"
set xtics nomirror rotate by 0
set ytics nomirror
# set format x "10^{%L}"

# set xrange [X_RANGE_S:X_RANGE_E]
set yrange [0:1]

## Make tics at 0, 0.5, 1, 1.5, ..., 9.5, 10.
# set xtics 0,1,10
set xtics ("Apr" 0, "May" 1, "Jun" 2, "Jul" 3, "Aug" 4, "Sep" 5, "Oct" 6, "Nov" 7, "Dec" 8, "Jan" 9, "Feb" 10, "Mar" 11, "Apr" 12)
## Make tics at ..., -10, -5, 0, 5, 10, ...
# set xtics 5

# set logscale x
# set logscale y

set lmargin 5.5
set rmargin 2
set bmargin 1
set tmargin 1

# set key right top
# set key at 10,5  ## coordinate of right top corner of the legend
# set key Left above reverse nobox horizontal spacing 0.9 samplen 1.5 width -8
set key at 0,1.2 left reverse Left nobox horizontal spacing 0.9 samplen 2 width -1
# set nokey

set style line 1 lc rgb "#e41a1c" lt 1 lw 15 pt 1 ps 3   pi -1 dt 1  ## +
set style line 2 lc rgb "#377eb8" lt 2 lw 11 pt 6 ps 2   pi -1 dt 2  ##
set style line 3 lc rgb "#4daf4a" lt 5 lw 8  pt 2 ps 2   pi -1 dt 3  ## *
set style line 4 lc rgb "#984ea3" lt 4 lw 5  pt 5 ps 1.5 pi -1 dt 4  ## box
set style line 5 lc rgb "#ff7f00" lt 3 lw 15 pt 5 ps 1 pi -1 dt 5  ## solid box
set style line 6 lc rgb "#ffff33" lt 6 lw 18 pt 6 ps 1 pi -1 dt 6  ## circle
set style line 7 lc rgb "#a65628" lt 7 lw 5  pt 7 ps 1 pi -1 dt 7  ##
set style line 8 lc rgb "#f781bf" lt 8 lw 5  pt 8 ps 1 pi -1 dt 8  ## triangle
set style line 9 lc rgb "#999999" lt 9 lw 5  pt 9 ps 1 pi -1 dt 9  ##
# set pointintervalbox 2  ## interval to a point

set grid

# ###########################################################################
# classifier = "C45"
# file_name = classifier.".time"
# type = "norm.fix"

# set output fig_dir.fig_name.".".classifier.".".type.".prec.eps"
# set ylabel '{/Helvetica=28 Precision}' offset character 0, 0, 0

# plot data_dir.file_name.".201504.".type.".txt" using 2 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
#      data_dir.file_name.".201505.".type.".txt" using 2 with linespoints ls 2 title '{/Helvetica=28 15.5}', \
#      data_dir.file_name.".201506.".type.".txt" using 2 with linespoints ls 3 title '{/Helvetica=28 15.6}', \
#      data_dir.file_name.".201507.".type.".txt" using 2 with linespoints ls 4 title '{/Helvetica=28 15.7}', \
#      data_dir.file_name.".201604.".type.".txt" using 2 with linespoints ls 5 title '{/Helvetica=28 16.4}', \
#      data_dir.file_name.".201605.".type.".txt" using 2 with linespoints ls 6 title '{/Helvetica=28 16.5}'

# ###########################################################################
# set output fig_dir.fig_name.".".classifier.".".type.".recall.eps"
# set ylabel '{/Helvetica=28 Recall}' offset character 0, 0, 0

# plot data_dir.file_name.".201504.".type.".txt" using 3 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
#      data_dir.file_name.".201505.".type.".txt" using 3 with linespoints ls 2 title '{/Helvetica=28 15.5}', \
#      data_dir.file_name.".201506.".type.".txt" using 3 with linespoints ls 3 title '{/Helvetica=28 15.6}', \
#      data_dir.file_name.".201507.".type.".txt" using 3 with linespoints ls 4 title '{/Helvetica=28 15.7}', \
#      data_dir.file_name.".201604.".type.".txt" using 3 with linespoints ls 5 title '{/Helvetica=28 16.4}', \
#      data_dir.file_name.".201605.".type.".txt" using 3 with linespoints ls 6 title '{/Helvetica=28 16.5}'

# ###########################################################################
# set output fig_dir.fig_name.".".classifier.".".type.".f1.eps"
# set ylabel '{/Helvetica=28 F1-Score}' offset character 0, 0, 0

# plot data_dir.file_name.".201504.".type.".txt" using 4 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
#      data_dir.file_name.".201505.".type.".txt" using 4 with linespoints ls 2 title '{/Helvetica=28 15.5}', \
#      data_dir.file_name.".201506.".type.".txt" using 4 with linespoints ls 3 title '{/Helvetica=28 15.6}', \
#      data_dir.file_name.".201507.".type.".txt" using 4 with linespoints ls 4 title '{/Helvetica=28 15.7}', \
#      data_dir.file_name.".201604.".type.".txt" using 4 with linespoints ls 5 title '{/Helvetica=28 16.4}', \
#      data_dir.file_name.".201605.".type.".txt" using 4 with linespoints ls 6 title '{/Helvetica=28 16.5}'


# ###########################################################################
# type = "norm.fix.fltr"

# set output fig_dir.fig_name.".".classifier.".".type.".prec.eps"
# set ylabel '{/Helvetica=28 Precision}' offset character 0, 0, 0

# plot data_dir.file_name.".201504.".type.".txt" using 2 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
#      data_dir.file_name.".201505.".type.".txt" using 2 with linespoints ls 2 title '{/Helvetica=28 15.5}', \
#      data_dir.file_name.".201506.".type.".txt" using 2 with linespoints ls 3 title '{/Helvetica=28 15.6}', \
#      data_dir.file_name.".201507.".type.".txt" using 2 with linespoints ls 4 title '{/Helvetica=28 15.7}', \
#      data_dir.file_name.".201604.".type.".txt" using 2 with linespoints ls 5 title '{/Helvetica=28 16.4}', \
#      data_dir.file_name.".201605.".type.".txt" using 2 with linespoints ls 6 title '{/Helvetica=28 16.5}'

# ###########################################################################
# set output fig_dir.fig_name.".".classifier.".".type.".recall.eps"
# set ylabel '{/Helvetica=28 Recall}' offset character 0, 0, 0

# plot data_dir.file_name.".201504.".type.".txt" using 3 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
#      data_dir.file_name.".201505.".type.".txt" using 3 with linespoints ls 2 title '{/Helvetica=28 15.5}', \
#      data_dir.file_name.".201506.".type.".txt" using 3 with linespoints ls 3 title '{/Helvetica=28 15.6}', \
#      data_dir.file_name.".201507.".type.".txt" using 3 with linespoints ls 4 title '{/Helvetica=28 15.7}', \
#      data_dir.file_name.".201604.".type.".txt" using 3 with linespoints ls 5 title '{/Helvetica=28 16.4}', \
#      data_dir.file_name.".201605.".type.".txt" using 3 with linespoints ls 6 title '{/Helvetica=28 16.5}'

# ###########################################################################
# set output fig_dir.fig_name.".".classifier.".".type.".f1.eps"
# set ylabel '{/Helvetica=28 F1-Score}' offset character 0, 0, 0

# plot data_dir.file_name.".201504.".type.".txt" using 4 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
#      data_dir.file_name.".201505.".type.".txt" using 4 with linespoints ls 2 title '{/Helvetica=28 15.5}', \
#      data_dir.file_name.".201506.".type.".txt" using 4 with linespoints ls 3 title '{/Helvetica=28 15.6}', \
#      data_dir.file_name.".201507.".type.".txt" using 4 with linespoints ls 4 title '{/Helvetica=28 15.7}', \
#      data_dir.file_name.".201604.".type.".txt" using 4 with linespoints ls 5 title '{/Helvetica=28 16.4}', \
#      data_dir.file_name.".201605.".type.".txt" using 4 with linespoints ls 6 title '{/Helvetica=28 16.5}'



###########################################################################
###########################################################################
###########################################################################
###########################################################################
###########################################################################
###########################################################################
###########################################################################
###########################################################################




###########################################################################
classifier = "NaiveBayes"
file_name = classifier.".time"
type = "norm.fix"
typen = "norm_fix"

set output fig_dir.fig_name."_".classifier."_".typen."_prec.eps"
set ylabel '{/Helvetica=28 Precision}' offset character 2.5, 0, 0

plot data_dir.file_name.".201504.".type.".txt" using 2 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
     data_dir.file_name.".201507.".type.".txt" using 2 with linespoints ls 2 title '{/Helvetica=28 15.7}', \
     data_dir.file_name.".201510.".type.".txt" using 2 with linespoints ls 3 title '{/Helvetica=28 15.10}', \
     data_dir.file_name.".201605.".type.".txt" using 2 with linespoints ls 4 title '{/Helvetica=28 16.03}'

# plot data_dir.file_name.".201504.".type.".txt" using 2 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
#      data_dir.file_name.".201505.".type.".txt" using 2 with linespoints ls 2 title '{/Helvetica=28 15.5}', \
#      data_dir.file_name.".201506.".type.".txt" using 2 with linespoints ls 3 title '{/Helvetica=28 15.6}', \
#      data_dir.file_name.".201507.".type.".txt" using 2 with linespoints ls 4 title '{/Helvetica=28 15.7}', \
#      data_dir.file_name.".201508.".type.".txt" using 2 with linespoints ls 5 title '{/Helvetica=28 15.8}', \
#      data_dir.file_name.".201509.".type.".txt" using 2 with linespoints ls 6 title '{/Helvetica=28 15.9}', \
#      data_dir.file_name.".201510.".type.".txt" using 2 with linespoints ls 7 title '{/Helvetica=28 15.10}', \
#      data_dir.file_name.".201511.".type.".txt" using 2 with linespoints ls 8 title '{/Helvetica=28 15.11}', \
#      data_dir.file_name.".201512.".type.".txt" using 2 with linespoints ls 1 title '{/Helvetica=28 15.12}', \
#      data_dir.file_name.".201601.".type.".txt" using 2 with linespoints ls 2 title '{/Helvetica=28 16.1}', \
#      data_dir.file_name.".201604.".type.".txt" using 2 with linespoints ls 3 title '{/Helvetica=28 16.2}', \
#      data_dir.file_name.".201605.".type.".txt" using 2 with linespoints ls 4 title '{/Helvetica=28 16.3}', \
#      data_dir.file_name.".201608.".type.".txt" using 2 with linespoints ls 5 title '{/Helvetica=28 16.4}'

###########################################################################
set output fig_dir.fig_name."_".classifier."_".typen."_recall.eps"
set ylabel '{/Helvetica=28 Recall}' offset character 2.5, 0, 0

plot data_dir.file_name.".201504.".type.".txt" using 3 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
     data_dir.file_name.".201507.".type.".txt" using 3 with linespoints ls 2 title '{/Helvetica=28 15.7}', \
     data_dir.file_name.".201510.".type.".txt" using 3 with linespoints ls 3 title '{/Helvetica=28 15.10}', \
     data_dir.file_name.".201605.".type.".txt" using 3 with linespoints ls 4 title '{/Helvetica=28 16.03}'

# plot data_dir.file_name.".201504.".type.".txt" using 3 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
#      data_dir.file_name.".201505.".type.".txt" using 3 with linespoints ls 2 title '{/Helvetica=28 15.5}', \
#      data_dir.file_name.".201506.".type.".txt" using 3 with linespoints ls 3 title '{/Helvetica=28 15.6}', \
#      data_dir.file_name.".201507.".type.".txt" using 3 with linespoints ls 4 title '{/Helvetica=28 15.7}', \
#      data_dir.file_name.".201508.".type.".txt" using 3 with linespoints ls 5 title '{/Helvetica=28 15.8}', \
#      data_dir.file_name.".201509.".type.".txt" using 3 with linespoints ls 6 title '{/Helvetica=28 15.9}', \
#      data_dir.file_name.".201510.".type.".txt" using 3 with linespoints ls 7 title '{/Helvetica=28 15.10}', \
#      data_dir.file_name.".201511.".type.".txt" using 3 with linespoints ls 8 title '{/Helvetica=28 15.11}', \
#      data_dir.file_name.".201512.".type.".txt" using 3 with linespoints ls 1 title '{/Helvetica=28 15.12}', \
#      data_dir.file_name.".201601.".type.".txt" using 3 with linespoints ls 2 title '{/Helvetica=28 16.1}', \
#      data_dir.file_name.".201604.".type.".txt" using 3 with linespoints ls 3 title '{/Helvetica=28 16.2}', \
#      data_dir.file_name.".201605.".type.".txt" using 3 with linespoints ls 4 title '{/Helvetica=28 16.3}', \
#      data_dir.file_name.".201608.".type.".txt" using 3 with linespoints ls 5 title '{/Helvetica=28 16.4}'

###########################################################################
set output fig_dir.fig_name."_".classifier."_".typen."_f1.eps"
set ylabel '{/Helvetica=28 F1-Score}' offset character 2.5, 0, 0

plot data_dir.file_name.".201504.".type.".txt" using 4 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
     data_dir.file_name.".201507.".type.".txt" using 4 with linespoints ls 2 title '{/Helvetica=28 15.7}', \
     data_dir.file_name.".201510.".type.".txt" using 4 with linespoints ls 3 title '{/Helvetica=28 15.10}', \
     data_dir.file_name.".201605.".type.".txt" using 4 with linespoints ls 4 title '{/Helvetica=28 16.03}'
# plot data_dir.file_name.".201504.".type.".txt" using 4 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
#      data_dir.file_name.".201505.".type.".txt" using 4 with linespoints ls 2 title '{/Helvetica=28 15.5}', \
#      data_dir.file_name.".201506.".type.".txt" using 4 with linespoints ls 3 title '{/Helvetica=28 15.6}', \
#      data_dir.file_name.".201507.".type.".txt" using 4 with linespoints ls 4 title '{/Helvetica=28 15.7}', \
#      data_dir.file_name.".201508.".type.".txt" using 4 with linespoints ls 5 title '{/Helvetica=28 15.8}', \
#      data_dir.file_name.".201509.".type.".txt" using 4 with linespoints ls 6 title '{/Helvetica=28 15.9}', \
#      data_dir.file_name.".201510.".type.".txt" using 4 with linespoints ls 7 title '{/Helvetica=28 15.10}', \
#      data_dir.file_name.".201511.".type.".txt" using 4 with linespoints ls 8 title '{/Helvetica=28 15.11}', \
#      data_dir.file_name.".201512.".type.".txt" using 4 with linespoints ls 1 title '{/Helvetica=28 15.12}', \
#      data_dir.file_name.".201601.".type.".txt" using 4 with linespoints ls 2 title '{/Helvetica=28 16.1}', \
#      data_dir.file_name.".201604.".type.".txt" using 4 with linespoints ls 3 title '{/Helvetica=28 16.2}', \
#      data_dir.file_name.".201605.".type.".txt" using 4 with linespoints ls 4 title '{/Helvetica=28 16.3}', \
#      data_dir.file_name.".201608.".type.".txt" using 4 with linespoints ls 5 title '{/Helvetica=28 16.4}'
