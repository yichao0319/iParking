reset
set terminal postscript eps enhanced color 28
# set terminal postscript eps enhanced monochrome 28
# set terminal png enhanced 28 size 800,600
# set terminal jpeg enhanced font helvetica 28
set size ratio 1.5

data_dir = "./data/train_size/"
fig_dir  = "./figs/"

set xlabel '{/Helvetica=28 Training Size (Months)}' offset character 0, 0, 0

set xtics nomirror rotate by 0
set ytics nomirror
set tics font "Helvetica,28"

set xrange [-0.5:5.5]
set yrange [0:1]

set style data histogram
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 1.8

set style fill pattern 2
# set style fill solid 0.8
set palette color
# set palette gray

set lmargin 1
set rmargin 1
set bmargin 3.3
set tmargin 1

# set key right top
# set key at 10,5  ## coordinate of right top corner of the legend
# set key Left above reverse horizontal spacing 0.9 samplen 1.5 width 1
set nokey


# set style line 1 lc rgb "red"     lt 1 lw 1 pt 1 ps 1.5 pi -1  ## +
# set style line 2 lc rgb "blue"    lt 2 lw 1 pt 2 ps 1.5 pi -1  ## x
# set style line 3 lc rgb "#00CC00" lt 1 lw 1 pt 3 ps 1.5 pi -1  ## *
# set style line 4 lc rgb "#7F171F" lt 4 lw 1 pt 4 ps 1.5 pi -1  ## box
# set style line 5 lc rgb "#FFD800" lt 3 lw 1 pt 5 ps 1.5 pi -1  ## solid box
# set style line 6 lc rgb "#000078" lt 6 lw 1 pt 6 ps 1.5 pi -1  ## circle
# set style line 7 lc rgb "#732C7B" lt 7 lw 1 pt 7 ps 1.5 pi -1
# set style line 8 lc rgb "black"   lt 8 lw 1 pt 8 ps 1.5 pi -1  ## triangle

set style line 1 lc rgb "#e41a1c" lt 1 lw 5 pt 1 ps 1.5 pi -1  ## +
set style line 2 lc rgb "#377eb8" lt 1 lw 5 pt 2 ps 1.5 pi -1  ## x
set style line 3 lc rgb "#4daf4a" lt 1 lw 5 pt 3 ps 1.5 pi -1  ## *
set style line 4 lc rgb "#984ea3" lt 1 lw 5 pt 4 ps 1.5 pi -1  ## box
set style line 5 lc rgb "#ff7f00" lt 1 lw 5 pt 5 ps 1.5 pi -1  ## solid box
set style line 6 lc rgb "#ffff33" lt 1 lw 5 pt 6 ps 1.5 pi -1  ## circle
set style line 7 lc rgb "#a65628" lt 1 lw 5 pt 7 ps 1.5 pi -1
set style line 8 lc rgb "#f781bf" lt 1 lw 5 pt 8 ps 1.5 pi -1  ## triangle
set style line 9 lc rgb "#999999" lt 1 lw 5 pt 9 ps 1.5 pi -1  ##


classifier = "NaiveBayes"
file_name = classifier.".dataset_size"

###############################################################
fig_name  = classifier."_dataset_size_prec"
set output fig_dir.fig_name.".eps"
set ylabel '{/Helvetica=28 Precision}' offset character 2, 0, 0

plot data_dir.file_name.".txt" using 2:xtic(1) fs pattern 3 ls 2


###############################################################
fig_name  = classifier."_dataset_size_recall"
set output fig_dir.fig_name.".eps"
set ylabel '{/Helvetica=28 Recall}'

plot data_dir.file_name.".txt" using 3:xtic(1) fs pattern 4 ls 3


###############################################################
fig_name  = classifier."_dataset_size_f1"
set output fig_dir.fig_name.".eps"
set ylabel '{/Helvetica=28 F1-Score}'

plot data_dir.file_name.".txt" using 4:xtic(1) fs pattern 2 ls 1

