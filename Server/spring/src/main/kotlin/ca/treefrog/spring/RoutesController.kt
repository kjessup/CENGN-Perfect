package ca.treefrog.spring

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

var s1024 = "A".repeat(1024)
var s2048 = "A".repeat(2048)
var s4096 = "A".repeat(4096)
var s8192 = "A".repeat(8192)

@RestController
class RoutesController {
    @GetMapping("/empty")
    fun empty() = ""
    
    @GetMapping("/1024")
    fun s1024() = s1024
    
    @GetMapping("/2048")
    fun s2048() = s2048
    
    @GetMapping("/4096")
    fun s4096() = s4096
    
    @GetMapping("/8192")
    fun s8192() = s8192
}