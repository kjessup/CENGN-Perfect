#
# time,elapsed,threads,hits,latency,elapsed_min,elapsed_max,latency_min,latency_max
#

load 'plot-style-1.gp'
set ylabel "Request Time (ms)"
plot successfile using 1:2:3 lt palette w boxes
