#
# time,elapsed,threads,hits,latency,
# elapsed_min,elapsed_max,latency_min,latency_max,percentile_25,
# percentile_50,percentile_75,percentile_95
#

load 'plot-style-1.gp'
set ylabel "Request Time (ms)"
#stats successfile u 2 nooutput
set style fill solid noborder
plot successfile using 1:13:3 lw 3 lt palette w lines, \
	'' using 1:12 lw 2 w lines, \
	'' using 1:11 lw 2 w lines, \
	'' using 1:10 lw 1 w lines, \
	failurefile using 1:(50):2 w points t "Error" pt 6 ps variable lc rgb "red"

	