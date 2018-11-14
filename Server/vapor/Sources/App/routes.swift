import Vapor
import Multipart

let big2048 = String(repeating: "A", count: 2048)
let big8192 = String(repeating: "A", count: 8192)
let big32768 = String(repeating: "A", count: 32768)

struct CRUDUser: Codable, Content {
	let id: String
	let firstName: String
	let lastName: String
}

/// Register your application's routes here.
public func routes(_ router: Router) throws {
	
	router.get("/empty") {
		req in
		return ""
	}
	router.get("/2048") {
		req in
		return big2048
	}
	router.get("/8192") {
		req in
		return big8192
	}
	router.get("/32768") {
		req in
		return big32768
	}
	
	let prefix = "abc"
	router.get("/getArgs2048") {
		req -> String in
		for c in "abcdefghijklmnopqrstuvwxyz" {
			let _ = try? req.query.get(String.self, at: prefix + String(c))
//			print(v)
		}
		return big2048
	}
	
	router.post("/postArgs2048") {
		req -> String in
		for c in "abcdefghijklmnopqrstuvwxyz" {
			let _ = try? req.content.syncGet(String.self, at: prefix + String(c))
//			print(v)
		}
		return big2048
	}
	
	router.post("/postArgsMulti2048") {
		req -> Future<String> in
		let d = req.http.body.consumeData(max: Int.max, on: req)
		return d.map(to: String.self) {
			data in
			let b = req.http.contentType?.parameters["boundary"] ?? "error"
			if let mp = try? MultipartParser().parse(data: data, boundary: b) {
				for c in "abcdefghijklmnopqrstuvwxyz" {
					if let v = mp.firstPart(named: prefix + String(c)) {
//						print(String(data: v.data, encoding: .utf8))
					}
				}
			}
			return big2048
		}
	}
	router.post("/json") {
		req -> Future<CRUDUser> in
		return try req.content.decode(CRUDUser.self)
	}
}
