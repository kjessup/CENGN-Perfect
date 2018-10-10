
import NIO
import NIOHTTP1
import PerfectHTTP
import PerfectNet

func logInfo(_ msg: String) {
	print("[INFO] \(msg)")
}

public protocol UnboundServer {
	 func bind(port: Int, address: String) throws -> BoundServer
}

public protocol BoundServer {
	func start() throws ->  EventLoopFuture<Void>
	func stop() throws
}

final class HTTPHandler: ChannelInboundHandler {
	public typealias InboundIn = HTTPServerRequestPart
	public typealias OutboundOut = HTTPServerResponsePart
	let routeNavigator: RouteNavigator
	var response: NHTTPResponse?
	init(routeNavigator: RouteNavigator) {
//		logInfo("HTTPHandler.init")
		self.routeNavigator = routeNavigator
	}
	
	func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
		let reqPart = self.unwrapInboundIn(data)
//		logInfo("HTTPHandler.channelRead \(reqPart)")
		switch reqPart {
		case .head(let head):
			response = NHTTPResponse(nioHandler: self, request: NHTTPRequest(ctx: ctx, head: head))
		case .body(var body):
			let avail = body.readableBytes
			if let read = body.readBytes(length: avail) {
				response?.request.postBodyBytes?.append(contentsOf: read)
			}
		case .end(_):
			guard let response = self.response else {
				return
			}
			routeRequest(response.request, response: response)
		}
	}
	
	private func routeRequest(_ request: HTTPRequest, response: HTTPResponse) {
		let nav = routeNavigator
		if let handlers = nav.findHandlers(pathComponents: request.pathComponents, webRequest: request) {
			handlers.last?(request, response)
		} else {
			response.status = .notFound
			response.setBody(string: "The file \(request.path) was not found.")
			response.completed()
		}
	}
	
	func userInboundEventTriggered(ctx: ChannelHandlerContext, event: Any) {
		if event is IdleStateHandler.IdleStateEvent {
			_ = ctx.close()
		} else {
			ctx.fireUserInboundEventTriggered(event)
		}
	}
}

struct BoundHTTPServer: BoundServer {
	private let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
	private let channel: Channel
	
	init(routeNavigator: RouteNavigator, port: Int, address: String) throws {
		let bootstrap = ServerBootstrap(group: group)
			.serverChannelOption(ChannelOptions.backlog, value: 256)
			.serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
			.childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
			.childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
			.childChannelOption(ChannelOptions.maxMessagesPerRead, value: 1)
			.childChannelOption(ChannelOptions.allowRemoteHalfClosure, value: true)
			.childChannelInitializer { channel in
				channel.pipeline.configureHTTPServerPipeline(withErrorHandling: true)
//				.then {
//					channel.pipeline.add(handler: IdleStateHandler(readTimeout: TimeAmount.minutes(1)))
//				}
				.then {
					channel.pipeline.add(handler: HTTPHandler(routeNavigator: routeNavigator))
				}
			}
		channel = try bootstrap.bind(host: address, port: port).wait()
		logInfo("Server bound on \(address):\(port).")
	}
	
	func start() throws ->  EventLoopFuture<Void> {
		let ret = channel.closeFuture
		logInfo("Server started.")
		return ret
	}
	
	func stop() throws {
		// ...?
		try! group.syncShutdownGracefully()
	}
}

public struct HTTPServer: UnboundServer {
	private let routeNavigator: RouteNavigator
	init(_ routeNavigator: RouteNavigator) {
		self.routeNavigator = routeNavigator
	}
	public init(_ routes: Routes) {
		self.init(routes.navigator)
	}
	public func bind(port: Int, address: String = "0.0.0.0") throws -> BoundServer {
		return try BoundHTTPServer(routeNavigator: routeNavigator, port: port, address: address)
	}
}

