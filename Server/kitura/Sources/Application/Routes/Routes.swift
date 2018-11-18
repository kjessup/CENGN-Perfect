import LoggerAPI
import Health
import Kitura


let prefix = "abc"

let big2048 = String(repeating: "A", count: 2048)
let big8192 = String(repeating: "A", count: 8192)
let big32768 = String(repeating: "A", count: 32768)

func printTupes(_ t: [String:String]) {
	for c in "abcdefghijklmnopqrstuvwxyz" {
		let key = prefix + String(c)
		let fnd = t[key]
		print(fnd)
	}
}

struct CRUDUser: Codable {
	let id: String
	let firstName: String
	let lastName: String
}

func initializeRoutes(app: App) {
	app.router.post("/json") {
		(user: CRUDUser, completion: @escaping (CRUDUser?, RequestError?) -> Void) in
		completion(user, nil)
	}
	app.router.all(middleware: BodyParser())
	app.router.get("/empty") {
		_, response, next in
		try response.send("").end()
	}
	app.router.get("/2048") {
		_, response, next in
		try response.send(big2048).end()
	}
	app.router.get("/8192") {
		_, response, next in
		try response.send(big8192).end()
	}
	app.router.get("/32768") {
		_, response, next in
		try response.send(big32768).end()
	}
	app.router.get("/getArgs2048") {
		req, response, next in
		let q = req.queryParameters
		printTupes(q)
		try response.send(big2048).end()
	}
	app.router.post("/postArgs2048") {
		req, response, next in
		if let body = req.body?.asURLEncoded {
			printTupes(body)
		}
		try response.send(big2048).end()
	}
	app.router.post("/postArgsMulti2048") {
		req, response, next in
		if let body = req.body?.asMultiPart {
			for c in "abcdefghijklmnopqrstuvwxyz" {
				let key = prefix + String(c)
				let fnd = body.first { $0.name == key }
				print(fnd?.body.asText)
			}
		}
		try response.send(big2048).end()
	}
}
