reset
set terminal postscript eps enhanced color 28 dl 0.5
# set terminal png enhanced 28 size 800,600
# set terminal jpeg enhanced font helvetica 28
set size ratio 0.5

data_dir = "./data/sensor/"
fig_dir  = "./figs/"

set xlabel '{/Helvetica=28 Test Month}' offset character 0, 0, 0

set tics font "Helvetica,28"
set xtics nomirror rotate by 0
set ytics nomirror
# set format y "10^{%L}"

set xtics ("Sep" 0, "Oct" 1, "Nov" 2, "Dec" 3, "Jan" 4, "Feb" 5, "Mar" 6, "Apr" 7)

## Make tics at 0, 0.5, 1, 1.5, ..., 9.5, 10.
# set xtics 0,1,10
## Make tics at ..., -10, -5, 0, 5, 10, ...
# set xtics 5

# set logscale x
# set logscale y

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
fig_name  = "sensor_f1"
set output fig_dir.fig_name.".eps"
# set ytics 0,0.1,1
# set yrange [0.7:1]
# set logscale y
# set format y "10^{%L}"
set ylabel '{/Helvetica=28 F1-Score}' offset character 2, 0, 0
set key at 0,1.05 left reverse Left nobox horizontal spacing 0.9 samplen 2.5 width -2

plot data_dir."always_off.txt" using 3 with linespoints ls 1 title '{/Helvetica=28 off}', \
     data_dir."always_on.txt" using 3 with linespoints ls 2 title '{/Helvetica=28 on}', \
     data_dir."opt.txt" using 3 with linespoints ls 3 title '{/Helvetica=28 adaptive}'


###########################################################################
fig_name  = "sensor_power"
set output fig_dir.fig_name.".eps"
set yrange [1000:1020000]
set logscale y
set format y "10^{%L}"
set ylabel '{/Helvetica=28 Avg. Power (J)}' offset character 0.5, 0, 0
set key at 0,3020000 left reverse Left nobox horizontal spacing 0.9 samplen 2.5 width -2

plot data_dir."always_off.txt" using 4 with linespoints ls 1 title '{/Helvetica=28 off}', \
     data_dir."always_on.txt" using 4 with linespoints ls 2 title '{/Helvetica=28 on}', \
     data_dir."opt.txt" using 4 with linespoints ls 3 title '{/Helvetica=28 adaptive}'
