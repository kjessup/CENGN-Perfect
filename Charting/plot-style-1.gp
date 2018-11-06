#
# bar charts with thread count z axis
#

set autoscale
set key autotitle columnhead
set datafile separator ","
set terminal png size 2048,1024 enhanced font "arial,20" noenhanced
set title title
set xlabel "Seconds"
set zlabel "Client Threads"
set xtics 30
set xrange [0:425]
set grid
set style fill solid 1.0
set palette rgb 33,13,10
set key inside left top vertical
