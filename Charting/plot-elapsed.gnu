#
# time,elapsed,threads,hits,latency,
# elapsed_min,elapsed_max,latency_min,latency_max,percentile_25,
# percentile_50,percentile_75,percentile_95,cpu
#

load 'plot-style-1.gp'

stats successfile using 4 nooutput
avgHits = (STATS_sum/STATS_records)

set multiplot layout 2,1

set ylabel "Requests"
set title title1
plot successfile using 1:4:3 lt palette w boxes t "Req Per Sec", \
	'' using 1:(avgHits) w lines t sprintf("Average %d", avgHits)
#	, '' using 1:14 lw 1 w lines

min(x,y) = (x<y?x:y)
set bmargin at screen 0.08
set ylabel "Request Time (ms)"
set title title2
#set style fill solid noborder
plot failurefile using 1:(50):(min($2,25)) w points t "Error" pt 6 ps variable lc rgb "pink", \
	successfile using 1:13:3 lw 4 lt palette w lines, \
	'' using 1:12 lw 2 w lines, \
	'' using 1:11 lw 2 w lines, \
	'' using 1:10 lw 1 w lines
	