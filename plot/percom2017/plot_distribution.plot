reset
set terminal postscript eps enhanced color 28 dl 4.0
# set terminal png enhanced 28 size 800,600
# set terminal jpeg enhanced font helvetica 28
set size ratio 0.5

data_dir = "./data/feature_dist/"
fig_dir  = "./figs/"

set xlabel '{/Helvetica=28 Feature Value}' offset character 0, 0, 0
set ylabel '{/Helvetica=28 PDF}' offset character 3, 0, 0

set tics font "Helvetica,24"
set xtics nomirror rotate by 0
set ytics nomirror
# set format x "10^{%L}"

# set xrange [X_RANGE_S:X_RANGE_E]
# set yrange [0:1]

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

#set style line 1 lc rgb "red"     lt 1 lw 5 pt 1 ps 1.5 pi -1  ## +
#set style line 2 lc rgb "blue"    lt 2 lw 5 pt 2 ps 1.5 pi -1  ## x
#set style line 3 lc rgb "#00CC00" lt 5 lw 5 pt 3 ps 1.5 pi -1  ## *
#set style line 4 lc rgb "#7F171F" lt 4 lw 5 pt 4 ps 1.5 pi -1  ## box
#set style line 5 lc rgb "#FFD800" lt 3 lw 5 pt 5 ps 1.5 pi -1  ## solid box
#set style line 6 lc rgb "#000078" lt 6 lw 5 pt 6 ps 1.5 pi -1  ## circle
#set style line 7 lc rgb "#732C7B" lt 7 lw 5 pt 7 ps 1.5 pi -1
#set style line 8 lc rgb "black"   lt 8 lw 5 pt 8 ps 1.5 pi -1  ## triangle
set style line 1 lc rgb "#e41a1c" lt 1 lw 5  pt 1 ps 2 pi -1 dt 1  ## +
set style line 2 lc rgb "#377eb8" lt 2 lw 5  pt 2 ps 2 pi -1 dt 2  ##
set style line 3 lc rgb "#4daf4a" lt 5 lw 5  pt 6 ps 2 pi -1 dt 3  ## *
set style line 4 lc rgb "#984ea3" lt 4 lw 5  pt 5 ps 2 pi -1 dt 4  ## box
set style line 5 lc rgb "#ff7f00" lt 3 lw 15 pt 5 ps 1 pi -1 dt 5  ## solid box
set style line 6 lc rgb "#ffff33" lt 6 lw 18 pt 6 ps 1 pi -1 dt 6  ## circle
set style line 7 lc rgb "#a65628" lt 7 lw 5  pt 7 ps 1 pi -1 dt 7  ##
set style line 8 lc rgb "#f781bf" lt 8 lw 5  pt 8 ps 1 pi -1 dt 8  ## triangle
set style line 9 lc rgb "#999999" lt 9 lw 5  pt 9 ps 1 pi -1 dt 9  ##
# set pointintervalbox 2  ## interval to a point



###########################################################################
file_name = "time_dist"
fig_name  = "time_dist"
feature   = 28

set xrange [50:120]
set key right top reverse nobox vertical spacing 0.9 samplen 1.5 width -1
set output fig_dir.fig_name."f".feature.".eps"

plot data_dir.file_name.".201504.f".feature.".txt" using 1:2 with linespoints ls 1 title '{/Helvetica=28 201504}', \
     data_dir.file_name.".201512.f".feature.".txt" using 1:2 with linespoints ls 2 title '{/Helvetica=28 201512}', \
     data_dir.file_name.".201601.f".feature.".txt" using 1:2 with linespoints ls 3 title '{/Helvetica=28 201601}', \
     data_dir.file_name.".201608.f".feature.".txt" using 1:2 with linespoints ls 4 title '{/Helvetica=28 201604}'



###########################################################################
file_name = "time_dist"
fig_name  = "time_dist"
feature   = 64

set xrange [50:110]
set key right top reverse nobox vertical spacing 0.9 samplen 1.5 width -1
set output fig_dir.fig_name."f".feature.".eps"

plot data_dir.file_name.".201504.f".feature.".txt" using 1:2 with linespoints ls 1 title '{/Helvetica=28 201504}', \
     data_dir.file_name.".201512.f".feature.".txt" using 1:2 with linespoints ls 2 title '{/Helvetica=28 201512}', \
     data_dir.file_name.".201601.f".feature.".txt" using 1:2 with linespoints ls 3 title '{/Helvetica=28 201601}', \
     data_dir.file_name.".201608.f".feature.".txt" using 1:2 with linespoints ls 4 title '{/Helvetica=28 201604}'



###########################################################################
file_name = "time_dist"
fig_name  = "time_dist"
feature   = 93

set xrange [60:120]
set key left top reverse nobox vertical spacing 0.9 samplen 1.5 width -1
set output fig_dir.fig_name."f".feature.".eps"

plot data_dir.file_name.".201504.f".feature.".txt" using 1:2 with linespoints ls 1 title '{/Helvetica=28 201504}', \
     data_dir.file_name.".201512.f".feature.".txt" using 1:2 with linespoints ls 2 title '{/Helvetica=28 201512}', \
     data_dir.file_name.".201601.f".feature.".txt" using 1:2 with linespoints ls 3 title '{/Helvetica=28 201601}', \
     data_dir.file_name.".201608.f".feature.".txt" using 1:2 with linespoints ls 4 title '{/Helvetica=28 201604}'



###########################################################################
file_name = "space_dist.201504"
fig_name  = "space_dist"
feature   = 66

set xrange [50:120]
set key right top reverse nobox vertical spacing 0.9 samplen 1.5 width -1
set output fig_dir.fig_name."f".feature.".eps"

plot data_dir.file_name.".412_108.f".feature.".txt" using 1:2 with linespoints ls 1 title '{/Helvetica=28 spot1}', \
     data_dir.file_name.".414_114.f".feature.".txt" using 1:2 with linespoints ls 2 title '{/Helvetica=28 spot2}', \
     data_dir.file_name.".417_110.f".feature.".txt" using 1:2 with linespoints ls 3 title '{/Helvetica=28 spot3}', \
     data_dir.file_name.".424_109.f".feature.".txt" using 1:2 with linespoints ls 4 title '{/Helvetica=28 spot4}'

###########################################################################
file_name = "space_dist.201504"
fig_name  = "space_dist"
feature   = 79

set style line 1 lc rgb "#e41a1c" lt 1 lw 3  pt 1 ps 1 pi 5 dt 1  ## +
set style line 2 lc rgb "#377eb8" lt 2 lw 3  pt 2 ps 1 pi 5 dt 1  ##
set style line 3 lc rgb "#4daf4a" lt 5 lw 3  pt 6 ps 1 pi 5 dt 1  ## *
set style line 4 lc rgb "#984ea3" lt 4 lw 3  pt 5 ps 1 pi 5 dt 1  ## box

set xrange [-800:1200]
set yrange [0:0.004]
set xtics -800,300,1200
set ytics 0,0.001,0.005
set key right top reverse nobox vertical spacing 0.9 samplen 1.5 width -1
set output fig_dir.fig_name."f".feature.".eps"

plot data_dir.file_name.".412_108.f".feature.".txt" using 1:2 with linespoints ls 1 title '{/Helvetica=28 spot1}', \
     data_dir.file_name.".414_114.f".feature.".txt" using 1:2 with linespoints ls 2 title '{/Helvetica=28 spot2}', \
     data_dir.file_name.".417_110.f".feature.".txt" using 1:2 with linespoints ls 3 title '{/Helvetica=28 spot3}', \
     data_dir.file_name.".424_109.f".feature.".txt" using 1:2 with linespoints ls 4 title '{/Helvetica=28 spot4}'

