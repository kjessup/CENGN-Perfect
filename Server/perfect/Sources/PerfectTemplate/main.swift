//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectHTTP
import PerfectHTTPServer

var routes = Routes()

let big2048 = String(repeating: "A", count: 2048)
let big8192 = String(repeating: "A", count: 8192)
let big32768 = String(repeating: "A", count: 32768)

routes.add(uri: "/empty") {
	req, resp in
	resp.completed()
}
routes.add(uri: "/2048") {
	req, resp in
	resp.setBody(string: big2048).completed()
}
routes.add(uri: "/8192") {
	req, resp in
	resp.setBody(string: big8192).completed()
}
routes.add(uri: "/32768") {
	req, resp in
	resp.setBody(string: big32768).completed()
}

routes.add(uri: "/getArgs2048") {
	req, resp in
	let prefix = "abc"
	for c in "abcdefghijklmnopqrstuvwxyz" {
		_ = req.param(name: prefix + String(c)) ?? ""
	}
	resp.setBody(string: big2048).completed()
}
routes.add(uri: "/postArgs2048") {
	req, resp in
	let prefix = "abc"
	for c in "abcdefghijklmnopqrstuvwxyz" {
		_ = req.param(name: prefix + String(c)) ?? ""
	}
	resp.setBody(string: big2048).completed()
}
routes.add(uri: "/postArgsMulti2048") {
	req, resp in
	let prefix = "abc"
	for c in "abcdefghijklmnopqrstuvwxyz" {
		_ = req.param(name: prefix + String(c)) ?? ""
	}
	resp.setBody(string: big2048).completed()
}

try HTTPServer.launch(name: "localhost",
					  port: 8181,
					  routes: routes)
