//
//  NHTTPResponse.swift
//  PerfectTemplateLib2
//
//  Created by Kyle Jessup on 2018-10-01.
//

import NIO
import NIOHTTP1
import PerfectHTTP
import PerfectNet

private let zeroBuf = ByteBufferAllocator().buffer(capacity: 0)

class NHTTPResponse: HTTPResponse {
	let nioHandler: HTTPHandler
	var ctx: ChannelHandlerContext { return nrequest.ctx }
	let channel: Channel
	var request: HTTPRequest { return nrequest }
	let nrequest: NHTTPRequest
	var status: PerfectHTTP.HTTPResponseStatus = .ok
	var isStreaming = false
	var bodyBytes: [UInt8] {
		get {
			return bodyMaybe?.getBytes(at: 0, length: body.readableBytes) ?? []
		}
		set {
			if nil == bodyMaybe {
				bodyMaybe = channel.allocator.buffer(capacity: newValue.count)
			}
			bodyMaybe?.clear()
			bodyMaybe?.write(bytes: newValue)
		}
	}
	var headerStore = Array<(HTTPResponseHeader.Name, String)>()
	var wroteHeaders = false
	var handlers: IndexingIterator<[RequestHandler]>?
	var body: ByteBuffer {
		if let real = bodyMaybe {
			return real
		}
		let b = channel.allocator.buffer(capacity: 128)
		bodyMaybe = b
		return b
	}
	var bodyMaybe: ByteBuffer? = nil
	var headers: AnyIterator<(HTTPResponseHeader.Name, String)> {
		var g = self.headerStore.makeIterator()
		return AnyIterator<(HTTPResponseHeader.Name, String)> {
			g.next()
		}
	}
	
	init(nioHandler: HTTPHandler, request: NHTTPRequest) {
		self.nioHandler = nioHandler
		nrequest = request
		channel = nrequest.ctx.channel
	}
	
	func header(_ named: HTTPResponseHeader.Name) -> String? {
		for (n, v) in headerStore where n == named {
			return v
		}
		return nil
	}
	@discardableResult
	func addHeader(_ name: HTTPResponseHeader.Name, value: String) -> Self {
		headerStore.append((name, value))
		return self
	}
	@discardableResult
	func setHeader(_ name: HTTPResponseHeader.Name, value: String) -> Self {
		var fi = [Int]()
		for i in 0..<headerStore.count {
			let (n, _) = headerStore[i]
			if n == name {
				fi.append(i)
			}
		}
		fi = fi.reversed()
		for i in fi {
			headerStore.remove(at: i)
		}
		return addHeader(name, value: value)
	}
	
	func push(callback: @escaping (Bool) -> ()) {
		let p: EventLoopPromise<Void> = ctx.eventLoop.newPromise()
		p.futureResult.whenSuccess({callback(true)})
		p.futureResult.whenFailure({_ in callback(false)})
		push(p)
	}
	
	func push(_ promise: EventLoopPromise<Void>) {
		promise.futureResult.whenFailure { _ in
			self.abort()
		}
		promise.futureResult.whenComplete {
			self.bodyMaybe?.clear()
		}
		let hasBody = nil != bodyMaybe && bodyMaybe!.readableBytes > 0
		if !wroteHeaders {
			wroteHeaders = true
			if hasBody {
				channel.write(nioHandler.wrapOutboundOut(.head(responseHead())), promise: nil)
			} else {
				return channel.writeAndFlush(nioHandler.wrapOutboundOut(.head(responseHead())), promise: promise)
			}
		}
		if !hasBody {
			// if we do not have a body here then we also did not write the headers in this call
			return promise.succeed(result: ())
		} else {
			let out = nioHandler.wrapOutboundOut(.body(.byteBuffer(body)))
			channel.writeAndFlush(out, promise: promise)
		}
	}
		
	func responseHead() -> HTTPResponseHead {
		wroteHeaders = true
		if !isStreaming {
			addHeader(.contentLength, value: "\(body.readableBytes)")
		}
		let req = nrequest.head
		return HTTPResponseHead(version: req.version,
								status: HTTPResponseStatus.init(statusCode: status.code),
								headers: HTTPHeaders(headerStore.map {($0.0.standardName, $0.1)}))
	}
	
	func abort() {
		nioHandler.response = nil
		ctx.close(promise: nil)
	}
		
	func completed() {
		let p: EventLoopPromise<Void> = ctx.eventLoop.newPromise()
		p.futureResult.whenComplete {
			self.completeResponse(self.ctx, trailers: nil, promise: nil)
		}
		push(p)
	}
	
	func next() {
		if let n = handlers?.next() {
			n(request, self)
		} else {
			completed()
		}
	}
	
	private func completeResponse(_ ctx: ChannelHandlerContext, trailers: HTTPHeaders?, promise: EventLoopPromise<Void>?) {
		let keepAlive = nrequest.head.isKeepAlive
		let promise = keepAlive ? promise : (promise ?? ctx.eventLoop.newPromise())
		if !keepAlive {
			promise!.futureResult.whenComplete {
				ctx.close(promise: nil)
			}
		}
		nioHandler.response = nil
		channel.writeAndFlush(nioHandler.wrapOutboundOut(.end(trailers)), promise: promise)
	}
}
