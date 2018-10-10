import PerfectHTTP
import PerfectTemplateLib2

var routes = Routes()

let big1024 = String(repeating: "A", count: 1024)
let big2048 = String(repeating: "A", count: 2048)
let big4096 = String(repeating: "A", count: 4096)

routes.add(uri: "/empty") {
	req, resp in
	resp.completed()
}
routes.add(uri: "/1024") {
	req, resp in
	resp.setBody(string: big1024).completed()
}
routes.add(uri: "/2048") {
	req, resp in
	resp.setBody(string: big2048).completed()
}
routes.add(uri: "/4096") {
	req, resp in
	resp.appendBody(string: big4096).completed()
}
routes.add(uri: "/push/8192") {
	req, resp in
	var sent = 0
	resp.isStreaming = true
	func send() {
		if sent >= 8192 {
			resp.completed()
		} else {
			resp.setBody(string: big1024).push {
				b in
				if b {
					sent += 1024
					send()
				}
			}
		}
	}
	send()
}
routes.add(uri: "/args") {
	req, resp in
	resp.setBody(string:
		"<html><body>" +
			req.params().map { "\($0.0) = \($0.1)" }.joined(separator: "<br>\n") +
		"</body></html>")
		.completed()
}
routes.add(uri: "/sleep") {
	req, resp in
	
}


let s = HTTPServer(routes)
let b = try s.bind(port: 8080)
let p = try b.start()
try p.wait()
