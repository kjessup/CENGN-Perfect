
import PerfectLib
import PerfectCrypto
import Foundation
import Dispatch

let linefeed = UInt8(10)
let comma = UInt8(44)

let csvPath = ProcessInfo.processInfo.arguments[1]
let label = ProcessInfo.processInfo.arguments[2]
let outFile = fileStdout

let dbHost = "localhost"
let dbName = "postgresdb"
let dbUser = "postgresuser"
let dbPassword = "postgresuser"

let wantColumns = Set([0, 1, 3, 7, 9, 10, 12, 14, 15, 16])

let file = File(csvPath)
assert(file.exists)
try file.open(.read)

var buffer: [UInt8] = []
var baseTime = 0
var lineCount = 0
/*
timeStamp,label,elapsed,responseCode,success,bytes,sentBytes,allThreads,latency,idleTime,connect
*/
func processLines(_ lines: [[UInt8]]) throws {
	var buffer: [UInt8] = []
	for line in lines {
		var components = wantedOnly(line.split(separator: comma, omittingEmptySubsequences: false).map(Array.init))
		func i(_ a: [UInt8]) -> Int {
			return Int(String(validatingUTF8: a)!)!
		}
		let time = i(components.remove(at: 0))
		let newTime = time - baseTime
		assert(newTime >= 0)
		
		components = [Array("\(newTime)".utf8), Array(label.utf8)] + components
		components[3] = Array("\(Int(String(validatingUTF8: components[3])!) ?? 500)".utf8)
		let bytes = components.joined(separator: [comma]).flatMap{$0}
		buffer.append(contentsOf: bytes)
		buffer.append(linefeed)
		lineCount += 1
	}
	try outFile.write(bytes: buffer)
}

func wantedOnly(_ a: [[UInt8]]) -> [[UInt8]] {
	var ret = [[UInt8]]()
	for i in 0..<a.count {
		guard wantColumns.contains(i) else {
			continue
		}
		ret.append(a[i])
	}
	return ret
}

do {
	func minTime(_ lines: [[UInt8]]) -> Int {
		var minTime = Int.max
		for line in lines {
			let component = Array(line.split(separator: comma)[0])
			let str = String(validatingUTF8: component)!
			let time = Int(str)!
			minTime = min(minTime, time)
		}
		return minTime
	}
	
	buffer = try file.readSomeBytes(count: 1024*16)
	var lines = buffer.split(separator: linefeed).map(Array.init)

	lines.remove(at: 0)
	let firstLine = "timestamp,label,elapsed,responsecode,success,bytes,sentbytes,allthreads,latency,idletime,connect\n"
	try outFile.write(bytes: Array(firstLine.utf8))
	
	buffer = lines.popLast()!
	baseTime = minTime(lines)
	try processLines(lines)
};

while true {
	let read = try file.readSomeBytes(count: 1024*256)
	if read.isEmpty {
		try processLines([buffer])
		break
	}
	buffer.append(contentsOf: read)
	var lines = buffer.split(separator: linefeed).map(Array.init)
	buffer = lines.popLast()!
	try processLines(lines)
//	print("\(lineCount) lines")
}


