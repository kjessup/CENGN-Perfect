# Perfect-NIO-CENGN (DRAFT)

## Introduction

Perfect is an open source server framework for Swift. It contains a built-in HTTP/S server and URI routing system and is primarily focused on building network APIs and REST services. 
	
When Apple announced their intent to open source the Swift language and port it to Linux we were excited about the possibility of running Swift on the server and taking advantage, not only of Swift's strong type safety and clean syntax, but of the benefits of code sharing between clients and servers. Immediately after Apple's announcement (some several months before any actual release) we had embarked on bringing our experience with servers and server-side languages to the platform, resulting in Perfect.
	
Since then, we have continued to develop and mature Perfect and have been using it ourselves for internal and for client projects with good results.
	
Perfect is built upon our own general purpose networking library (written in Swift, of course) called Perfect-Net. Perfect-Net utilizes the OS level kqueue/epoll APIs (for macOS and Linux, respectively) and provides asynchronous accept, read, and write support, and serves as the basis for not only Perfect's HTTP server, but various other networking related code we and our users have written over the last few years.
	
SwiftNIO (henceforth referred to as NIO) is a relatively new open source project from Apple. Written in Swift, NIO itself provides asynchronous networking APIs as well as several concrete protocol implementations such as HTTP and WebSockets. NIO is (I'm told) modeled after Netty; a Java package with the same reason for being. 
	
NIO's APIs would be considered more high level than Perfect-Net's. While Perfect-Net provides a simple system for installing a callback to be invoked when a network event occurs, NIO's system involves chaining handlers using a pipelining scheme, where each component handles a particular aspect of network protocol encoding, decoding, and framing.
	
While NIO is certainly interesting (any open source package produced and released by Apple would qualify as such), we were initially skeptical as to whether we could benefit from it. We have generally approached Perfect's core in a conservative manner, keeping APIs stable and only adding features which we knew could be done without disruption to existing code bases. Perfect-Net had been working quite well for us; it performed efficiently and with a negligible memory footprint. We wrote it and understood how it worked. Fixes and improvements could be added rapidly and with a good deal of assurance that the impacts would be minimal.
	
That said, there are certainly advantages in not having to maintain every aspect of a complex software project. Benefits come from being able to participate in a larger ecosystem, giving and receiving contributions from a much grander team than we alone could muster. Additionally, our users had begun to ask if and when we would be adopting NIO into Perfect. An answer of "we don't think it will be of benefit", without any evidence either way, is unsatisfactory. Finally, we had begun development of a new URI routing system which capitalized on newer additions to the Swift langage. This new system would be presented in a planned Perfect 4.0 release and so, if we were to adopt NIO, this would be the best time to do it. However, performance is very important for us. If moving to NIO was going to be a degradation to any degree then we would be hard pressed to spend the time migrating to it just because it was there.
	
We decided that if we were going to move to NIO we would do it in an informed manner. This would involve doing an initial implementation of Perfect running with our new routing system and with NIO at its core. We would then do a series of performance related tests pitting Perfect 3 against Perfect-NIO and see how they compared. We also wanted to run the same tests on several of the more popular HTTP frameworks in common usage today. The purpose of this was to help us gauge where Perfect (with or without NIO) currently stood in relation to the pack. If, during our testing, there was anything we could discover and change to improve our outcomes, then we would try and do so.
	
Luckily, we had a coinciding opportunity to work with the Centre of Excellence in Next Generation Networks (CENGN). CENGN provides programs and resources with the goal of helping Canadian small and medium sized information technology focused businesses to grow. CENGN was able to provide us with a closed networking environment and several pieces of hardware which would have been difficult for us to acquire on our own. We planned to use these resources to perform heavy stress testing of Perfect 3 and Perfect-NIO, as well as the other candidate frameworks we had identified.
	
## Test Plan

The hardware provided to us was a pair of Cisco UCS C240 M5 rack servers. These each contained 36 Intel Xeon Gold 6140 CPUs running at 2.30GHz, with 384GB of RAM, and were connected with a 10G link. We figured this would suffice for our purposes.
	
One of the machines was split into four, 4 CPU VMs (the clients), and the other was left bare metal (the server). The server was where the server frameworks would run while the VMs would run JMeter to perform the tests. Ubuntu 16.04 was installed on all.
	
With the four client, one would be employed as a JMeter master while the other three would be JMeter minions. Zabbix with Postgres was installed on one of these VMs as well, and the Zabbix agent was placed on the server. The purpose of this was to be able to garner additional metrics from the server while the tests are being run. In the end we used Zabbix only to gather the ongoing CPU usage while the tests were being run. Zabbix was configured to collect CPU usage once a second.
	
The server and all clients had their ephemeral port range widened, max open files increased, and tcp_tw_recycle and tcp_tw_reuse enabled.

All the frameworks we intended to test were then installed on the server. We settled on the following:
	
	Django (2.1.2, Python 3.7, Apache+fcgi)
	Go (1.11)
	Kitura (2.5, Swift 4.2.1)
	Laravel (5.7.9, PHP 7.1.19, Apache+mod_php)
	Node (10.11, cluster mode)
	Perfect (3, Swift 4.2.1)
	Perfect-NIO
	Rails (5.2.1, Ruby 2.5.1, Apache+Passenger)
	Spring MVC (2.0.5, Kotlin 1.2.51, Java 1.8)
	Vapor (3.1, Swift 4.2.1)

Important notes:

* The version of Vapor being tested was itself already running on NIO while Kitura was not (it's apparently an option that can be enabled, but we did not do that). This provided a great opportunity to compare performance of the various Swift frameworks while running on a few different networking cores.
* Rails with Passenger had its minimum number of processes increased to 72 in order to match the number of available cores (with hyper-threading: 36x2). This Apache instance would be started and I would wait until all instances had launched and quieted down before commencing any test run. After completion that Apache instance would be halted.
* Node was running in cluster mode, meaning a node process was launched for each available core, so 72 processes.
	
We then proceeded to add the test related endpoints to each of the frameworks. We settled on the following and implemented them for each framework and tested them individually to ensure they were operational and returning proper results.
	
	/empty
		Empty request and response
	/2048
		Empty request, 2048 byte response
	/32768
		Empty request 32768 byte response
	/getArgs2048
		Receive, decode and iterate through 26 search arguments, 2048 byte response
	/postArgs2048
		Receive, decode and iterate through 26 url-encoded POST arguments, 2048 byte response
	/postArgsMulti2048
		Receive, decode and iterate through 26 multipart form encoded POST arguments, 2048 byte response
	/json
		Receive, decode and echo JSON post body data
	/mix
		Randomly runs all POST/GET tests, 2048 & 8192 response, and JSON echo

All endpoint response data consisted of a series of 'A's repeated. Since we weren't concerned with comparing programming language performance per se, this response data was pre-calculated and served from a constant variable as best each language permitted. For the same reason, an attempt was also made to do as little work as possible within each URI handler.

We then created the JMeter test plan files (.jmx) for each endpoint and some shell scripts to help drive the test procedure. As described earlier, the clients consisted of one JMeter master and three minions. All actual traffic to the server would be coming from the three clients and all final result data would be sent to the master for aggregation. Most tests would generate up to a maximum of 9000 concurrent requests, ramping up in steps over a four minute period. The traffic level would then be held at peak for three minutes before the test was complete. Each test for each framework would take seven minutes to run, plus a trailing several minutes for the JMeter master to process and combine all client results into one log file in csv format.

In addition, an export of the collected CPU usage data would be copied to csv from the Zabbix related Postgres server. Only data corresponding to the individual test's run time would be exported.

The resulting log files from JMeter, from which all result data was gathered, could be quite large, up to several hundred GB each, depending on how many requests the respective server was able to handle. Because of this, the driving test scripts would zip up the result data and delete the raw csv files (a full run of all framework tests would easily fill up the available drive space without this step, which is generally sub-optimal). These final zip files would then be manually scp'd from the server to a local machine outside of the CENGN network for further processing.

## Post-Processing

### Import

Running an individual test produces two csv files. One contains the log file from JMeter, the other contains the CPU usage data gathered from Zabbix. A shell script would unzip the CPU data (which was ultimately much smaller than the JMeter data) to a temporary location and would streaming-unzip the JMeter data while piping it to a custom (Swift based) process. This process would normalize all the time data from the source such that the first request occurred at zero seconds, aiding greatly in creating charts for the result data. It would also insert the matching CPU data for each span of seconds as an additional csv column and drop some columns which were not relevent to the final reporting process. And finally, it would output the resulting data as csv which was streamed into Postgres.

Each framework/test combination would have its data stored in its own table. This made working with the data much more efficient. The tests were run many, many times as the process was improved and as Perfect-NIO was developed and iterated on. Old test data was dropped for each new run.

### Export

Before a chart for any framework/test combination was generated, the data was exported from Postgres as csv. However, this data was first reprocessed. This processing was done in Postgres itself. Timestamp data was truncated to seconds (stripping off milliseconds) and all rows were grouped and ordered by this resulting time data. For each second, the request elapsed time, thread count, and latency were averaged. The elapsed request time's 25th/50th/75th/95th percentiles were calculated, and finaly the average cpu usage per second was calculated.

The above was only done for successful requests. Any failed requests were separately selected and written to their own file using the same seconds calculation and grouping.

### Charting

Once a framework/test combination's data was exported, it was fed into gnuplot. Gnuplot would then spit out a pdf containing three charts. These charts show:

* Requests per second over time, including load level and overall average requests per sec.
* CPU utilization over time, including load level.
* Request elapsed time by percentile 25/50/75/95 over time, including load level and request errors, if any.
	
## Results


### Anomalies

### Take Aways

### Subsequent Work

### Future Work
















