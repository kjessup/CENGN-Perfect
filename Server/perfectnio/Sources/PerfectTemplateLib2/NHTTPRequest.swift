//
//  NHTTPRequest.swift
//  PerfectTemplateLib2
//
//  Created by Kyle Jessup on 2018-10-01.
//

import NIO
import NIOHTTP1
import PerfectHTTP
import PerfectNet

class NHTTPRequest: PerfectHTTP.HTTPRequest {
	var method: PerfectHTTP.HTTPMethod {
		get {
			switch head.method {
			case .GET:
				return .get
			case .PUT:
				return .put
			case .HEAD:
				return .head
			case .POST:
				return .post
			case .PATCH:
				return .patch
			case .TRACE:
				return .trace
			case .DELETE:
				return .delete
			case .CONNECT:
				return .connect
			case .OPTIONS:
				return .options
			case .RAW(let value):
				return .custom(value)
			default:
				return .custom("\(head.method)")
			}
		}
		set {
			switch newValue {
			case .options:
				head.method = .OPTIONS
			case .get:
				head.method = .GET
			case .head:
				head.method = .HEAD
			case .post:
				head.method = .POST
			case .patch:
				head.method = .PATCH
			case .put:
				head.method = .PUT
			case .delete:
				head.method = .DELETE
			case .trace:
				head.method = .TRACE
			case .connect:
				head.method = .CONNECT
			case .custom(let r):
				head.method = .RAW(value: r)
			}
		}
	}
	var path: String
	var pathComponents: [String]
	var queryString = ""
	lazy var queryParams: [(String, String)] = {
		return NHTTPRequest.deFormURLEncoded(string: queryString)
	}()
	var postParams: [(String, String)] = []
	var postBodyBytes: [UInt8]? = nil
	var postBodyString: String? = nil
	var postFileUploads: [MimeReader.BodySpec]? = nil
	var protocolVersion: (Int, Int) = (1, 1)
	var remoteAddress: (host: String, port: UInt16) = ("", 0)
	var serverAddress: (host: String, port: UInt16) = ("", 0)
	var serverName: String = ""
	var documentRoot: String = ""
	var connection: NetTCP = NetTCP() // !FIX!
	var urlVariables: [String : String] = [:]
	var scratchPad: [String : Any] = [:]
	
	let ctx: ChannelHandlerContext
	var head: HTTPRequestHead
	init(ctx: ChannelHandlerContext, head: HTTPRequestHead) {
		self.ctx = ctx
		self.head = head
		let (c, q) = NHTTPRequest.parseURI(head.uri)
		self.path = "/" + c.joined(separator: "/")
		self.pathComponents = c
		self.queryString = q
		
	}
	
	func header(_ named: HTTPRequestHeader.Name) -> String? {
		return head.headers.first { $0.name.lowercased() == named.standardName.lowercased() }?.value
	}
	func addHeader(_ named: HTTPRequestHeader.Name, value: String) {
		head.headers.add(name: named.standardName, value: value)
	}
	func setHeader(_ named: HTTPRequestHeader.Name, value: String) {
		head.headers.replaceOrAdd(name: named.standardName, value: value)
	}
	var headers: AnyIterator<(HTTPRequestHeader.Name, String)> {
		var g = head.headers.makeIterator()
		return AnyIterator<(HTTPRequestHeader.Name, String)> {
			if let n = g.next() {
				return (HTTPRequestHeader.Name.fromStandard(name: n.name), n.value)
			}
			return nil
		}
	}
	static func parseURI(_ uri: String) -> (components: [String], query: String) {
		enum ParseURLState {
			case slash, component, query
		}
		var state = ParseURLState.slash
		var gen = uri.makeIterator()
		var pathComponents = ["/"]
		var component = ""
		var queryString = ""
		
		let question = Character("?")
		let slash = Character("/")
		
		while let uchar = gen.next() {
			switch state {
				case .slash:
					if uchar == question {
						state = .query
						if pathComponents.count > 1 {
							pathComponents.append("/")
						}
					} else if uchar != slash {
						state = .component
						component = String(uchar)
					}
				case .component:
					if uchar == question {
						state = .query
						pathComponents.append(component.stringByDecodingURL ?? "")
					} else if uchar == slash {
						state = .slash
						pathComponents.append(component.stringByDecodingURL ?? "")
					} else {
						component.append(uchar)
					}
				case .query:
					queryString.append(uchar)
			}
		}
		switch state {
			case .slash:
				if pathComponents.count > 1 {
					pathComponents.append("/")
				}
			case .component:
				pathComponents.append(component.stringByDecodingURL ?? "")
			case .query:
				()
		}
		return (pathComponents, queryString)
	}
	
	static func deFormURLEncoded(string: String) -> [(String, String)] {
		return string.split(separator: "&").map(String.init).compactMap {
			let d = $0.split(separator: "=", maxSplits: 1).compactMap { String($0).stringByDecodingURL }
			if d.count == 2 { return (d[0], d[1]) }
			if d.count == 1 { return (d[0], "") }
			return nil
		}
	}
}
