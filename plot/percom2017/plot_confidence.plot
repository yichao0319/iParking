reset
set terminal postscript eps enhanced color 28 dl 4.0
# set terminal png enhanced 28 size 800,600
# set terminal jpeg enhanced font helvetica 28
set size ratio 0.7

data_dir = "./data/"
fig_dir  = "./figs/"
file_name = "time"
fig_name  = "temporal_stability"

set xlabel '{/Helvetica=28 Month}' offset character 0, 0, 0

set tics font "Helvetica,24"
set xtics nomirror rotate by 0
set ytics nomirror
# set format x "10^{%L}"

# set xrange [X_RANGE_S:X_RANGE_E]
set yrange [0:1]

## Make tics at 0, 0.5, 1, 1.5, ..., 9.5, 10.
set xtics 0,1,10
## Make tics at ..., -10, -5, 0, 5, 10, ...
# set xtics 5

# set logscale x
# set logscale y

# set lmargin 4.5
# set rmargin 5.5
# set bmargin 3.7
# set tmargin 4.4

# set key right top
# set key at 10,5  ## coordinate of right top corner of the legend
set key Left above reverse nobox horizontal spacing 0.9 samplen 3.5 width 0
# set nokey

#set style line 1 lc rgb "red"     lt 1 lw 5 pt 1 ps 1.5 pi -1  ## +
#set style line 2 lc rgb "blue"    lt 2 lw 5 pt 2 ps 1.5 pi -1  ## x
#set style line 3 lc rgb "#00CC00" lt 5 lw 5 pt 3 ps 1.5 pi -1  ## *
#set style line 4 lc rgb "#7F171F" lt 4 lw 5 pt 4 ps 1.5 pi -1  ## box
#set style line 5 lc rgb "#FFD800" lt 3 lw 5 pt 5 ps 1.5 pi -1  ## solid box
#set style line 6 lc rgb "#000078" lt 6 lw 5 pt 6 ps 1.5 pi -1  ## circle
#set style line 7 lc rgb "#732C7B" lt 7 lw 5 pt 7 ps 1.5 pi -1
#set style line 8 lc rgb "black"   lt 8 lw 5 pt 8 ps 1.5 pi -1  ## triangle
set style line 1 lc rgb "#e41a1c" lt 1 lw 5 pt 1 ps 3 pi -1  ## +
set style line 2 lc rgb "#377eb8" lt 2 lw 6 pt 2 ps 3 pi -1  ## x
set style line 3 lc rgb "#4daf4a" lt 5 lw 10 pt 3 ps 3 pi -1  ## *
set style line 4 lc rgb "#984ea3" lt 4 lw 12 pt 4 ps 3 pi -1  ## box
set style line 5 lc rgb "#ff7f00" lt 3 lw 15 pt 5 ps 3 pi -1  ## solid box
set style line 6 lc rgb "#ffff33" lt 6 lw 18 pt 6 ps 1 pi -1  ## circle
set style line 7 lc rgb "#a65628" lt 7 lw 5 pt 7 ps 3 pi -1
set style line 8 lc rgb "#f781bf" lt 8 lw 5 pt 8 ps 3 pi -1  ## triangle
set style line 9 lc rgb "#999999" lt 9 lw 5 pt 9 ps 3 pi -1  ##
set pointintervalbox 2  ## interval to a point



###########################################################################
set output fig_dir.fig_name.".prec.eps"
set ylabel '{/Helvetica=28 Precision}' offset character 0, 0, 0

plot data_dir.file_name.".4.txt" using 1:2 with linespoints ls 1 title '{/Helvetica=28 4}', \
     data_dir.file_name.".45.txt" using 1:2 with linespoints ls 2 title '{/Helvetica=28 4-5}', \
     data_dir.file_name.".456.txt" using 1:2 with linespoints ls 3 title '{/Helvetica=28 4-6}', \
     data_dir.file_name.".4567.txt" using 1:2 with linespoints ls 4 title '{/Helvetica=28 4-7}', \
     data_dir.file_name.".45678.txt" using 1:2 with linespoints ls 5 title '{/Helvetica=28 4-8}', \
     data_dir.file_name.".next.txt" using 1:2 with linespoints ls 6 title '{/Helvetica=28 prev}'


###########################################################################
set output fig_dir.fig_name.".recall.eps"
set ylabel '{/Helvetica=28 Recall}' offset character 0, 0, 0

plot data_dir.file_name.".4.txt" using 1:3 with linespoints ls 1 title '{/Helvetica=28 4}', \
     data_dir.file_name.".45.txt" using 1:3 with linespoints ls 2 title '{/Helvetica=28 4-5}', \
     data_dir.file_name.".456.txt" using 1:3 with linespoints ls 3 title '{/Helvetica=28 4-6}', \
     data_dir.file_name.".4567.txt" using 1:3 with linespoints ls 4 title '{/Helvetica=28 4-7}', \
     data_dir.file_name.".45678.txt" using 1:3 with linespoints ls 5 title '{/Helvetica=28 4-8}', \
     data_dir.file_name.".next.txt" using 1:3 with linespoints ls 6 title '{/Helvetica=28 prev}'


###########################################################################
set output fig_dir.fig_name.".f1.eps"

plot data_dir.file_name.".4.txt" using 1:4 with linespoints ls 1 title '{/Helvetica=28 4}', \
     data_dir.file_name.".45.txt" using 1:4 with linespoints ls 2 title '{/Helvetica=28 4-5}', \
     data_dir.file_name.".456.txt" using 1:4 with linespoints ls 3 title '{/Helvetica=28 4-6}', \
     data_dir.file_name.".4567.txt" using 1:4 with linespoints ls 4 title '{/Helvetica=28 4-7}', \
     data_dir.file_name.".45678.txt" using 1:4 with linespoints ls 5 title '{/Helvetica=28 4-8}', \
     data_dir.file_name.".next.txt" using 1:4 with linespoints ls 6 title '{/Helvetica=28 prev}'
