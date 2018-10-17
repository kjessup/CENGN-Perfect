// swift-tools-version:4.0

import PackageDescription

let package = Package(
	name: "PerfectTemplate",
	products: [
		.executable(name: "perfect", targets: ["PerfectTemplate"])
	],
	dependencies: [
		.package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", from: "3.0.0"),
	],
	targets: [
		.target(name: "PerfectTemplate", dependencies: ["PerfectHTTPServer"])
	]
)
