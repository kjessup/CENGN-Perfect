#
# bar charts with thread count z axis
#

set autoscale
set key autotitle columnhead
set datafile separator ","
set terminal pdf size 8.5in,11in font "arial,20" noenhanced
set xlabel "Seconds"
set zlabel "Client Threads"
set xtics 30
set xrange [1:419]
set grid
set style fill solid 1.0
set palette rgb 33,13,10
set key inside left top vertical
