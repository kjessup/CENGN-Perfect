import LoggerAPI
import Health
import KituraContracts

let big1024 = String(repeating: "A", count: 1024)
let big2048 = String(repeating: "A", count: 2048)
let big4096 = String(repeating: "A", count: 4096)
let big8192 = String(repeating: "A", count: 8192)

func initializeRoutes(app: App) {
	
	app.router.get("/empty") {
		_, response, next in
		try response.send("").end()
	}
	app.router.get("/1024") {
		_, response, next in
		try response.send(big1024).end()
	}
	app.router.get("/2048") {
		_, response, next in
		try response.send(big2048).end()
	}
	app.router.get("/4096") {
		_, response, next in
		try response.send(big4096).end()
	}
	app.router.get("/8192") {
		_, response, next in
		try response.send(big8192).end()
	}
    
}
