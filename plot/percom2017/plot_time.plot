reset
set terminal postscript eps enhanced color 28 dl 0.4
# set terminal png enhanced 28 size 800,600
# set terminal jpeg enhanced font helvetica 28
set size ratio 0.7

data_dir = "./data/"
fig_dir  = "./figs/"
fig_name  = "temporal_stability"

set xlabel '{/Helvetica=28 Test Month}' offset character 0, 0, 0

set tics font "Helvetica,24"
set xtics nomirror rotate by 0
set ytics nomirror
# set format x "10^{%L}"

# set xrange [X_RANGE_S:X_RANGE_E]
set yrange [0:1]

## Make tics at 0, 0.5, 1, 1.5, ..., 9.5, 10.
# set xtics 0,1,10
set xtics ("Apr" 0, "May" 1, "Jun" 2, "Jul" 3, "Apr" 4, "May" 5)
## Make tics at ..., -10, -5, 0, 5, 10, ...
# set xtics 5

# set logscale x
# set logscale y

# set lmargin 4.5
# set rmargin 5.5
# set bmargin 3.7
set tmargin 3

# set key right top
# set key at 10,5  ## coordinate of right top corner of the legend
# set key Left above reverse nobox horizontal spacing 0.9 samplen 1.5 width -8
set key at 5.2,1.2 reverse Left nobox horizontal spacing 0.9 samplen 1.5 width -5
# set nokey

set style line 1 lc rgb "red"     lt 1 lw 15 pt 1 ps 1.5 pi -1 dt 1 ## +
set style line 2 lc rgb "blue"    lt 2 lw 13 pt 2 ps 1.5 pi -1 dt 2  ## x
set style line 3 lc rgb "#00CC00" lt 5 lw 11 pt 3 ps 1.5 pi -1 dt 3  ## *
set style line 4 lc rgb "#7F171F" lt 4 lw 8 pt 4 ps 1.5 pi -1 dt 4  ## box
set style line 5 lc rgb "#FFD800" lt 3 lw 5 pt 5 ps 1.5 pi -1 dt 5  ## solid box
set style line 6 lc rgb "#000078" lt 6 lw 4 pt 6 ps 1.5 pi -1 dt 6  ## circle
set style line 7 lc rgb "#732C7B" lt 7 lw 3 pt 7 ps 1.5 pi -1 dt 7
set style line 8 lc rgb "black"   lt 8 lw 2 pt 8 ps 1.5 pi -1 dt 8  ## triangle
# set style line 1 lc rgb "#e41a1c" lt 1 lw 5 pt 1 ps 3 pi -1  ## +
# set style line 2 lc rgb "#377eb8" lt 2 lw 6 pt 2 ps 3 pi -1  ## x
# set style line 3 lc rgb "#4daf4a" lt 5 lw 10 pt 3 ps 3 pi -1  ## *
# set style line 4 lc rgb "#984ea3" lt 4 lw 12 pt 4 ps 3 pi -1  ## box
# set style line 5 lc rgb "#ff7f00" lt 3 lw 15 pt 5 ps 3 pi -1  ## solid box
# set style line 6 lc rgb "#ffff33" lt 6 lw 18 pt 6 ps 1 pi -1  ## circle
# set style line 7 lc rgb "#a65628" lt 7 lw 5 pt 7 ps 3 pi -1
# set style line 8 lc rgb "#f781bf" lt 8 lw 5 pt 8 ps 3 pi -1  ## triangle
# set style line 9 lc rgb "#999999" lt 9 lw 5 pt 9 ps 3 pi -1  ##
# set pointintervalbox 2  ## interval to a point



###########################################################################
classifier = "C45"
file_name = classifier.".time"
type = "norm.fix"

set output fig_dir.fig_name.".".classifier.".".type.".prec.eps"
set ylabel '{/Helvetica=28 Precision}' offset character 0, 0, 0

plot data_dir.file_name.".201504.".type.".txt" using 2 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
     data_dir.file_name.".545.".type.".txt" using 2 with linespoints ls 2 title '{/Helvetica=28 15.4-5}', \
     data_dir.file_name.".5456.".type.".txt" using 2 with linespoints ls 3 title '{/Helvetica=28 15.4-6}', \
     data_dir.file_name.".54567.".type.".txt" using 2 with linespoints ls 4 title '{/Helvetica=28 15.4-7}', \
     data_dir.file_name.".5456764.".type.".txt" using 2 with linespoints ls 5 title '{/Helvetica=28 15.4-7,16.4}', \
     data_dir.file_name.".54567645.".type.".txt" using 2 with linespoints ls 6 title '{/Helvetica=28 15.4-7,16.4-5}'#, \
     # data_dir.file_name.".next.".type.".txt" using 2 with linespoints ls 7 title '{/Helvetica=28 prev}'


###########################################################################
set output fig_dir.fig_name.".".classifier.".".type.".recall.eps"
set ylabel '{/Helvetica=28 Recall}' offset character 0, 0, 0

plot data_dir.file_name.".201504.".type.".txt" using 3 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
     data_dir.file_name.".545.".type.".txt" using 3 with linespoints ls 2 title '{/Helvetica=28 15.4-5}', \
     data_dir.file_name.".5456.".type.".txt" using 3 with linespoints ls 3 title '{/Helvetica=28 15.4-6}', \
     data_dir.file_name.".54567.".type.".txt" using 3 with linespoints ls 4 title '{/Helvetica=28 15.4-7}', \
     data_dir.file_name.".5456764.".type.".txt" using 3 with linespoints ls 5 title '{/Helvetica=28 15.4-7,16.4}', \
     data_dir.file_name.".54567645.".type.".txt" using 3 with linespoints ls 6 title '{/Helvetica=28 15.4-7,16.4-5}'#, \
     # data_dir.file_name.".next.".type.".txt" using 3 with linespoints ls 7 title '{/Helvetica=28 prev}'



###########################################################################
set output fig_dir.fig_name.".".classifier.".".type.".f1.eps"
set ylabel '{/Helvetica=28 F1-Score}' offset character 0, 0, 0

plot data_dir.file_name.".201504.".type.".txt" using 4 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
     data_dir.file_name.".545.".type.".txt" using 4 with linespoints ls 2 title '{/Helvetica=28 15.4-5}', \
     data_dir.file_name.".5456.".type.".txt" using 4 with linespoints ls 3 title '{/Helvetica=28 15.4-6}', \
     data_dir.file_name.".54567.".type.".txt" using 4 with linespoints ls 4 title '{/Helvetica=28 15.4-7}', \
     data_dir.file_name.".5456764.".type.".txt" using 4 with linespoints ls 5 title '{/Helvetica=28 15.4-7,16.4}', \
     data_dir.file_name.".54567645.".type.".txt" using 4 with linespoints ls 6 title '{/Helvetica=28 15.4-7,16.4-5}'#, \
     # data_dir.file_name.".next.".type.".txt" using 4 with linespoints ls 7 title '{/Helvetica=28 prev}'


###########################################################################
type = "norm.fix.fltr"

set output fig_dir.fig_name.".".classifier.".".type.".prec.eps"
set ylabel '{/Helvetica=28 Precision}' offset character 0, 0, 0

plot data_dir.file_name.".201504.".type.".txt" using 2 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
     data_dir.file_name.".545.".type.".txt" using 2 with linespoints ls 2 title '{/Helvetica=28 15.4-5}', \
     data_dir.file_name.".5456.".type.".txt" using 2 with linespoints ls 3 title '{/Helvetica=28 15.4-6}', \
     data_dir.file_name.".54567.".type.".txt" using 2 with linespoints ls 4 title '{/Helvetica=28 15.4-7}', \
     data_dir.file_name.".5456764.".type.".txt" using 2 with linespoints ls 5 title '{/Helvetica=28 15.4-7,16.4}', \
     data_dir.file_name.".54567645.".type.".txt" using 2 with linespoints ls 6 title '{/Helvetica=28 15.4-7,16.4-5}'#, \
     # data_dir.file_name.".next.".type.".txt" using 2 with linespoints ls 7 title '{/Helvetica=28 prev}'


###########################################################################
set output fig_dir.fig_name.".".classifier.".".type.".recall.eps"
set ylabel '{/Helvetica=28 Recall}' offset character 0, 0, 0

plot data_dir.file_name.".201504.".type.".txt" using 3 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
     data_dir.file_name.".545.".type.".txt" using 3 with linespoints ls 2 title '{/Helvetica=28 15.4-5}', \
     data_dir.file_name.".5456.".type.".txt" using 3 with linespoints ls 3 title '{/Helvetica=28 15.4-6}', \
     data_dir.file_name.".54567.".type.".txt" using 3 with linespoints ls 4 title '{/Helvetica=28 15.4-7}', \
     data_dir.file_name.".5456764.".type.".txt" using 3 with linespoints ls 5 title '{/Helvetica=28 15.4-7,16.4}', \
     data_dir.file_name.".54567645.".type.".txt" using 3 with linespoints ls 6 title '{/Helvetica=28 15.4-7,16.4-5}'#, \
     # data_dir.file_name.".next.".type.".txt" using 3 with linespoints ls 7 title '{/Helvetica=28 prev}'



###########################################################################
set output fig_dir.fig_name.".".classifier.".".type.".f1.eps"
set ylabel '{/Helvetica=28 F1-Score}' offset character 0, 0, 0

plot data_dir.file_name.".201504.".type.".txt" using 4 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
     data_dir.file_name.".545.".type.".txt" using 4 with linespoints ls 2 title '{/Helvetica=28 15.4-5}', \
     data_dir.file_name.".5456.".type.".txt" using 4 with linespoints ls 3 title '{/Helvetica=28 15.4-6}', \
     data_dir.file_name.".54567.".type.".txt" using 4 with linespoints ls 4 title '{/Helvetica=28 15.4-7}', \
     data_dir.file_name.".5456764.".type.".txt" using 4 with linespoints ls 5 title '{/Helvetica=28 15.4-7,16.4}', \
     data_dir.file_name.".54567645.".type.".txt" using 4 with linespoints ls 6 title '{/Helvetica=28 15.4-7,16.4-5}'#, \
     # data_dir.file_name.".next.".type.".txt" using 4 with linespoints ls 7 title '{/Helvetica=28 prev}'


#############################################################################
#############################################################################
#############################################################################
#############################################################################
#############################################################################
#############################################################################
#############################################################################
#############################################################################
#############################################################################


###########################################################################
classifier = "NaiveBayes"
file_name = classifier.".time"
type = "norm.fix"

set output fig_dir.fig_name.".".classifier.".".type.".prec.eps"
set ylabel '{/Helvetica=28 Precision}' offset character 0, 0, 0

plot data_dir.file_name.".201504.".type.".txt" using 2 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
     data_dir.file_name.".545.".type.".txt" using 2 with linespoints ls 2 title '{/Helvetica=28 15.4-5}', \
     data_dir.file_name.".5456.".type.".txt" using 2 with linespoints ls 3 title '{/Helvetica=28 15.4-6}', \
     data_dir.file_name.".54567.".type.".txt" using 2 with linespoints ls 4 title '{/Helvetica=28 15.4-7}', \
     data_dir.file_name.".5456764.".type.".txt" using 2 with linespoints ls 5 title '{/Helvetica=28 15.4-7,16.4}', \
     data_dir.file_name.".54567645.".type.".txt" using 2 with linespoints ls 6 title '{/Helvetica=28 15.4-7,16.4-5}'#, \
     # data_dir.file_name.".next.".type.".txt" using 2 with linespoints ls 7 title '{/Helvetica=28 prev}'


###########################################################################
set output fig_dir.fig_name.".".classifier.".".type.".recall.eps"
set ylabel '{/Helvetica=28 Recall}' offset character 0, 0, 0

plot data_dir.file_name.".201504.".type.".txt" using 3 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
     data_dir.file_name.".545.".type.".txt" using 3 with linespoints ls 2 title '{/Helvetica=28 15.4-5}', \
     data_dir.file_name.".5456.".type.".txt" using 3 with linespoints ls 3 title '{/Helvetica=28 15.4-6}', \
     data_dir.file_name.".54567.".type.".txt" using 3 with linespoints ls 4 title '{/Helvetica=28 15.4-7}', \
     data_dir.file_name.".5456764.".type.".txt" using 3 with linespoints ls 5 title '{/Helvetica=28 15.4-7,16.4}', \
     data_dir.file_name.".54567645.".type.".txt" using 3 with linespoints ls 6 title '{/Helvetica=28 15.4-7,16.4-5}'#, \
     # data_dir.file_name.".next.".type.".txt" using 3 with linespoints ls 7 title '{/Helvetica=28 prev}'



###########################################################################
set output fig_dir.fig_name.".".classifier.".".type.".f1.eps"
set ylabel '{/Helvetica=28 F1-Score}' offset character 0, 0, 0

plot data_dir.file_name.".201504.".type.".txt" using 4 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
     data_dir.file_name.".545.".type.".txt" using 4 with linespoints ls 2 title '{/Helvetica=28 15.4-5}', \
     data_dir.file_name.".5456.".type.".txt" using 4 with linespoints ls 3 title '{/Helvetica=28 15.4-6}', \
     data_dir.file_name.".54567.".type.".txt" using 4 with linespoints ls 4 title '{/Helvetica=28 15.4-7}', \
     data_dir.file_name.".5456764.".type.".txt" using 4 with linespoints ls 5 title '{/Helvetica=28 15.4-7,16.4}', \
     data_dir.file_name.".54567645.".type.".txt" using 4 with linespoints ls 6 title '{/Helvetica=28 15.4-7,16.4-5}'#, \
     # data_dir.file_name.".next.".type.".txt" using 4 with linespoints ls 7 title '{/Helvetica=28 prev}'


###########################################################################
type = "norm.fix.fltr"

set output fig_dir.fig_name.".".classifier.".".type.".prec.eps"
set ylabel '{/Helvetica=28 Precision}' offset character 0, 0, 0

plot data_dir.file_name.".201504.".type.".txt" using 2 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
     data_dir.file_name.".545.".type.".txt" using 2 with linespoints ls 2 title '{/Helvetica=28 15.4-5}', \
     data_dir.file_name.".5456.".type.".txt" using 2 with linespoints ls 3 title '{/Helvetica=28 15.4-6}', \
     data_dir.file_name.".54567.".type.".txt" using 2 with linespoints ls 4 title '{/Helvetica=28 15.4-7}', \
     data_dir.file_name.".5456764.".type.".txt" using 2 with linespoints ls 5 title '{/Helvetica=28 15.4-7,16.4}', \
     data_dir.file_name.".54567645.".type.".txt" using 2 with linespoints ls 6 title '{/Helvetica=28 15.4-7,16.4-5}'#, \
     # data_dir.file_name.".next.".type.".txt" using 2 with linespoints ls 7 title '{/Helvetica=28 prev}'


###########################################################################
set output fig_dir.fig_name.".".classifier.".".type.".recall.eps"
set ylabel '{/Helvetica=28 Recall}' offset character 0, 0, 0

plot data_dir.file_name.".201504.".type.".txt" using 3 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
     data_dir.file_name.".545.".type.".txt" using 3 with linespoints ls 2 title '{/Helvetica=28 15.4-5}', \
     data_dir.file_name.".5456.".type.".txt" using 3 with linespoints ls 3 title '{/Helvetica=28 15.4-6}', \
     data_dir.file_name.".54567.".type.".txt" using 3 with linespoints ls 4 title '{/Helvetica=28 15.4-7}', \
     data_dir.file_name.".5456764.".type.".txt" using 3 with linespoints ls 5 title '{/Helvetica=28 15.4-7,16.4}', \
     data_dir.file_name.".54567645.".type.".txt" using 3 with linespoints ls 6 title '{/Helvetica=28 15.4-7,16.4-5}'#, \
     # data_dir.file_name.".next.".type.".txt" using 3 with linespoints ls 7 title '{/Helvetica=28 prev}'



###########################################################################
set output fig_dir.fig_name.".".classifier.".".type.".f1.eps"
set ylabel '{/Helvetica=28 F1-Score}' offset character 0, 0, 0

plot data_dir.file_name.".201504.".type.".txt" using 4 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
     data_dir.file_name.".545.".type.".txt" using 4 with linespoints ls 2 title '{/Helvetica=28 15.4-5}', \
     data_dir.file_name.".5456.".type.".txt" using 4 with linespoints ls 3 title '{/Helvetica=28 15.4-6}', \
     data_dir.file_name.".54567.".type.".txt" using 4 with linespoints ls 4 title '{/Helvetica=28 15.4-7}', \
     data_dir.file_name.".5456764.".type.".txt" using 4 with linespoints ls 5 title '{/Helvetica=28 15.4-7,16.4}', \
     data_dir.file_name.".54567645.".type.".txt" using 4 with linespoints ls 6 title '{/Helvetica=28 15.4-7,16.4-5}'#, \
     # data_dir.file_name.".next.".type.".txt" using 4 with linespoints ls 7 title '{/Helvetica=28 prev}'




#############################################################################
#############################################################################
#############################################################################
#############################################################################
#############################################################################
#############################################################################
#############################################################################
#############################################################################
#############################################################################


###########################################################################
classifier = "SVM"
file_name = classifier.".time"
type = "norm.fix"

set output fig_dir.fig_name.".".classifier.".".type.".prec.eps"
set ylabel '{/Helvetica=28 Precision}' offset character 0, 0, 0

plot data_dir.file_name.".201504.".type.".txt" using 2 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
     data_dir.file_name.".545.".type.".txt" using 2 with linespoints ls 2 title '{/Helvetica=28 15.4-5}', \
     data_dir.file_name.".5456.".type.".txt" using 2 with linespoints ls 3 title '{/Helvetica=28 15.4-6}', \
     data_dir.file_name.".54567.".type.".txt" using 2 with linespoints ls 4 title '{/Helvetica=28 15.4-7}', \
     data_dir.file_name.".5456764.".type.".txt" using 2 with linespoints ls 5 title '{/Helvetica=28 15.4-7,16.4}', \
     data_dir.file_name.".54567645.".type.".txt" using 2 with linespoints ls 6 title '{/Helvetica=28 15.4-7,16.4-5}'#, \
     # data_dir.file_name.".next.".type.".txt" using 2 with linespoints ls 7 title '{/Helvetica=28 prev}'


###########################################################################
set output fig_dir.fig_name.".".classifier.".".type.".recall.eps"
set ylabel '{/Helvetica=28 Recall}' offset character 0, 0, 0

plot data_dir.file_name.".201504.".type.".txt" using 3 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
     data_dir.file_name.".545.".type.".txt" using 3 with linespoints ls 2 title '{/Helvetica=28 15.4-5}', \
     data_dir.file_name.".5456.".type.".txt" using 3 with linespoints ls 3 title '{/Helvetica=28 15.4-6}', \
     data_dir.file_name.".54567.".type.".txt" using 3 with linespoints ls 4 title '{/Helvetica=28 15.4-7}', \
     data_dir.file_name.".5456764.".type.".txt" using 3 with linespoints ls 5 title '{/Helvetica=28 15.4-7,16.4}', \
     data_dir.file_name.".54567645.".type.".txt" using 3 with linespoints ls 6 title '{/Helvetica=28 15.4-7,16.4-5}'#, \
     # data_dir.file_name.".next.".type.".txt" using 3 with linespoints ls 7 title '{/Helvetica=28 prev}'



###########################################################################
set output fig_dir.fig_name.".".classifier.".".type.".f1.eps"
set ylabel '{/Helvetica=28 F1-Score}' offset character 0, 0, 0

plot data_dir.file_name.".201504.".type.".txt" using 4 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
     data_dir.file_name.".545.".type.".txt" using 4 with linespoints ls 2 title '{/Helvetica=28 15.4-5}', \
     data_dir.file_name.".5456.".type.".txt" using 4 with linespoints ls 3 title '{/Helvetica=28 15.4-6}', \
     data_dir.file_name.".54567.".type.".txt" using 4 with linespoints ls 4 title '{/Helvetica=28 15.4-7}', \
     data_dir.file_name.".5456764.".type.".txt" using 4 with linespoints ls 5 title '{/Helvetica=28 15.4-7,16.4}', \
     data_dir.file_name.".54567645.".type.".txt" using 4 with linespoints ls 6 title '{/Helvetica=28 15.4-7,16.4-5}'#, \
     # data_dir.file_name.".next.".type.".txt" using 4 with linespoints ls 7 title '{/Helvetica=28 prev}'


###########################################################################
type = "norm.fix.fltr"

set output fig_dir.fig_name.".".classifier.".".type.".prec.eps"
set ylabel '{/Helvetica=28 Precision}' offset character 0, 0, 0

plot data_dir.file_name.".201504.".type.".txt" using 2 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
     data_dir.file_name.".545.".type.".txt" using 2 with linespoints ls 2 title '{/Helvetica=28 15.4-5}', \
     data_dir.file_name.".5456.".type.".txt" using 2 with linespoints ls 3 title '{/Helvetica=28 15.4-6}', \
     data_dir.file_name.".54567.".type.".txt" using 2 with linespoints ls 4 title '{/Helvetica=28 15.4-7}', \
     data_dir.file_name.".5456764.".type.".txt" using 2 with linespoints ls 5 title '{/Helvetica=28 15.4-7,16.4}', \
     data_dir.file_name.".54567645.".type.".txt" using 2 with linespoints ls 6 title '{/Helvetica=28 15.4-7,16.4-5}'#, \
     # data_dir.file_name.".next.".type.".txt" using 2 with linespoints ls 7 title '{/Helvetica=28 prev}'


###########################################################################
set output fig_dir.fig_name.".".classifier.".".type.".recall.eps"
set ylabel '{/Helvetica=28 Recall}' offset character 0, 0, 0

plot data_dir.file_name.".201504.".type.".txt" using 3 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
     data_dir.file_name.".545.".type.".txt" using 3 with linespoints ls 2 title '{/Helvetica=28 15.4-5}', \
     data_dir.file_name.".5456.".type.".txt" using 3 with linespoints ls 3 title '{/Helvetica=28 15.4-6}', \
     data_dir.file_name.".54567.".type.".txt" using 3 with linespoints ls 4 title '{/Helvetica=28 15.4-7}', \
     data_dir.file_name.".5456764.".type.".txt" using 3 with linespoints ls 5 title '{/Helvetica=28 15.4-7,16.4}', \
     data_dir.file_name.".54567645.".type.".txt" using 3 with linespoints ls 6 title '{/Helvetica=28 15.4-7,16.4-5}'#, \
     # data_dir.file_name.".next.".type.".txt" using 3 with linespoints ls 7 title '{/Helvetica=28 prev}'



###########################################################################
set output fig_dir.fig_name.".".classifier.".".type.".f1.eps"
set ylabel '{/Helvetica=28 F1-Score}' offset character 0, 0, 0

plot data_dir.file_name.".201504.".type.".txt" using 4 with linespoints ls 1 title '{/Helvetica=28 15.4}', \
     data_dir.file_name.".545.".type.".txt" using 4 with linespoints ls 2 title '{/Helvetica=28 15.4-5}', \
     data_dir.file_name.".5456.".type.".txt" using 4 with linespoints ls 3 title '{/Helvetica=28 15.4-6}', \
     data_dir.file_name.".54567.".type.".txt" using 4 with linespoints ls 4 title '{/Helvetica=28 15.4-7}', \
     data_dir.file_name.".5456764.".type.".txt" using 4 with linespoints ls 5 title '{/Helvetica=28 15.4-7,16.4}', \
     data_dir.file_name.".54567645.".type.".txt" using 4 with linespoints ls 6 title '{/Helvetica=28 15.4-7,16.4-5}'#, \
     # data_dir.file_name.".next.".type.".txt" using 4 with linespoints ls 7 title '{/Helvetica=28 prev}'


