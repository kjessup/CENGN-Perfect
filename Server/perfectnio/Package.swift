// swift-tools-version:4.0

import PackageDescription

let package = Package(
	name: "PerfectTemplate",
	products: [
		.executable(name: "PerfectTemplate", targets: ["PerfectTemplateExe"]),
		.library(name: "PerfectTemplateLib2", targets: ["PerfectTemplateLib2"])
	],
	dependencies: [
		.package(url: "https://github.com/PerfectlySoft/Perfect-HTTP.git", from: "3.0.0"),
		.package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", from: "3.0.0"),
		.package(url: "https://github.com/apple/swift-nio.git", from: "1.9.0"),
	],
	targets: [
		.target(name: "PerfectTemplateExe", dependencies: ["PerfectTemplateLib2", "PerfectHTTPServer"]),
		.target(name: "PerfectTemplateLib2", dependencies: ["NIO", "NIOHTTP1", "PerfectHTTP"])
	]
)
