reset
set terminal postscript eps enhanced color 28 dl 0.5
# set terminal png enhanced 28 size 800,600
# set terminal jpeg enhanced font helvetica 28
set size ratio 0.5

data_dir = "./data/dist_converge/"
fig_dir  = "./figs/"

set xlabel '{/Helvetica=28 Time (Minutes)}' offset character 0, 0, 0

set tics font "Helvetica,28"
set xtics nomirror rotate by 0
set ytics nomirror
# set format y "10^{%L}"

## Make tics at 0, 0.5, 1, 1.5, ..., 9.5, 10.
# set xtics 0,1,10
## Make tics at ..., -10, -5, 0, 5, 10, ...
# set xtics 5

# set logscale x
# set logscale y

set lmargin 8.5
set rmargin 2
set bmargin 1
set tmargin 1

set grid

set style line 1 lc rgb "#e41a1c" lt 1 lw 10 pt 6 ps 1.5 pi -1 dt 1  ## +
set style line 2 lc rgb "#377eb8" lt 2 lw 8  pt 1 ps 1.5 pi -1 dt 1  ##
set style line 3 lc rgb "#4daf4a" lt 5 lw 5  pt 8 ps 1.5 pi -1 dt 1  ## *
set style line 4 lc rgb "#984ea3" lt 4 lw 3  pt 5 ps 1.5 pi -1 dt 4  ## box
# set pointintervalbox 2  ## interval to a point



###########################################################################
file_name = "mon201504.converge.hellinger"
fig_name  = "converge_hellinger_201504"
set output fig_dir.fig_name.".eps"
set xrange [0:400]
set ylabel '{/Helvetica=28 Hellinger}' offset character 2, 0, 0
set nokey

plot data_dir.file_name.".txt" using 1:2 with linespoints ls 1 title '{/Helvetica=28 201504}'


###########################################################################
file_name = "mon201504.converge.ks"
fig_name  = "converge_ks_201504"
set output fig_dir.fig_name.".eps"
set xrange [0:600]
# set yrange [:1]
set ylabel '{/Helvetica=28 KS}' offset character 2, 0, 0
set key at 0.6,8 left reverse Left nobox horizontal spacing 0.9 samplen 2.5 width 0.6

plot data_dir.file_name.".txt" using 1:2 with linespoints ls 1 notitle


###########################################################################
# file_name = "mon201504.converge.kw"
# fig_name  = "converge_kw_201504"
# set output fig_dir.fig_name.".eps"
# # set xrange [0.6:1]
# # set yrange [:1]
# set ylabel '{/Helvetica=28 KW}' offset character 1, 0, 0
# set key at 0.6,8 left reverse Left nobox horizontal spacing 0.9 samplen 2.5 width 0.6

# plot data_dir.file_name.".txt" using 1:2 with linespoints ls 1 notitle


###########################################################################
file_name = "converge.hellinger"
fig_name  = "converge_hellinger"
set output fig_dir.fig_name.".eps"
set xrange [0:12]
set yrange [0:24]
set tics font "Helvetica,24"
set xtics ("Apr" 0, "May" 1, "Jun" 2, "Jul" 3, "Aug" 4, "Sep" 5, "Oct" 6, "Nov" 7, "Dec" 8, "Jan" 9, "Feb" 10, "Mar" 11, "Apr" 12)
set xlabel '{/Helvetica=28 Month}' offset character 0, 0, 0
set ylabel '{/Helvetica=28 Detection Time (hour)}' offset character 2, 0, 0
# set key at 0.6,8 left reverse Left nobox horizontal spacing 0.9 samplen 2.5 width 0.6
set nokey

set lmargin 5.5
set rmargin 2
set bmargin 1
set tmargin 1

plot data_dir.file_name.".txt" using ($1/60) with linespoints ls 1 title '{/Helvetica=28 201504}'
