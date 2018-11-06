#
# time,elapsed,threads,hits,latency,elapsed_min,elapsed_max,latency_min,latency_max,elapsed_median
#

load 'plot-style-1.gp'
set ylabel "Requests"
plot successfile using 1:4:3 lt palette w boxes
