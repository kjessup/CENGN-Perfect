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
	resp.setBody(string: big4096).completed()
}

try HTTPServer.launch(name: "localhost",
					  port: 8181,
					  routes: routes)
