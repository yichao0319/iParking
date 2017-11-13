reset
set terminal postscript eps enhanced color 28 dl 0.5
# set terminal png enhanced 28 size 800,600
# set terminal jpeg enhanced font helvetica 28
set size ratio 0.5

data_dir = "./data/confidence/"
fig_dir  = "./figs/"

set xlabel '{/Helvetica=28 Confidence}' offset character 0, 0, 0
set ylabel '{/Helvetica=28 CDF}' offset character 1, 0, 0

set tics font "Helvetica,28"
set xtics nomirror rotate by 0
set ytics nomirror
set format y "10^{%L}"

## Make tics at 0, 0.5, 1, 1.5, ..., 9.5, 10.
# set xtics 0,1,10
## Make tics at ..., -10, -5, 0, 5, 10, ...
# set xtics 5

# set logscale x
set logscale y

set lmargin 6.5
set rmargin 2
set bmargin 1
set tmargin 1

set grid

set style line 1 lc rgb "#e41a1c" lt 1 lw 15 pt 1 ps 3   pi -1 dt 1  ## +
set style line 2 lc rgb "#377eb8" lt 2 lw 11 pt 6 ps 2   pi -1 dt 1  ##
set style line 3 lc rgb "#4daf4a" lt 5 lw 8  pt 8 ps 2   pi -1 dt 1  ## *
# set pointintervalbox 2  ## interval to a point



###########################################################################
file_name = "conf.201608.201601.cdf"
fig_name  = "conf_201608_201601_cdf"
set output fig_dir.fig_name.".eps"
set xrange [0.6:1]
set yrange [:1]
set key at 0.6,8 left reverse Left nobox horizontal spacing 0.9 samplen 2.5 width 0.6

plot data_dir.file_name.".txt" using 1:2 with linespoints ls 1 title '{/Helvetica=28 TP+TN}', \
     "" using 1:4 with linespoints ls 2 title '{/Helvetica=28 FP}', \
     "" using 1:5 with linespoints ls 3 title '{/Helvetica=28 FN}'


###########################################################################
file_name = "conf.cdf"
fig_name  = "conf_cdf"
set output fig_dir.fig_name.".eps"
set xrange [0.4:1]
set yrange [:1]
set key at 0.4,8 left reverse Left nobox horizontal spacing 0.9 samplen 2.5 width 0.6

plot data_dir.file_name.".txt" using 1:2 with linespoints ls 1 title '{/Helvetica=28 TP+TN}', \
     "" using 1:4 with linespoints ls 2 title '{/Helvetica=28 FP}', \
     "" using 1:5 with linespoints ls 3 title '{/Helvetica=28 FN}'
