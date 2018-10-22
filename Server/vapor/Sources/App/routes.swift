import Vapor

let big1024 = String(repeating: "A", count: 1024)
let big2048 = String(repeating: "A", count: 2048)
let big4096 = String(repeating: "A", count: 4096)
let big8192 = String(repeating: "A", count: 8192)

/// Register your application's routes here.
public func routes(_ router: Router) throws {
	
	router.get("/empty") {
		req in
		return ""
	}
	router.get("/1024") {
		req in
		return big1024
	}
	router.get("/2048") {
		req in
		return big2048
	}
	router.get("/4096") {
		req in
		return big4096
	}
	router.get("/8192") {
		req in
		return big8192
	}
}
