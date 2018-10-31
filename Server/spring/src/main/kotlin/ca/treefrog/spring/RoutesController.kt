package ca.treefrog.spring

import org.springframework.web.bind.annotation.*
import org.springframework.web.multipart.MultipartFile
import org.springframework.http.MediaType
import org.springframework.util.MultiValueMap
import org.springframework.web.multipart.MultipartHttpServletRequest

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
    
    fun printArgs(body: Map<String,String>) {
        val prefix = "abc"
        for (char in 'a'..'z') {
            val v = body[prefix + char]
            print(v)
        }
    }

    @GetMapping("/getArgs2048")
    fun getArgs2048(@RequestParam queryParameters: Map<String, String>): String {
        printArgs(queryParameters)
        return s2048
    }
    
    @RequestMapping(value="/postArgs2048", method=[RequestMethod.POST],
                    consumes=[MediaType.APPLICATION_FORM_URLENCODED_VALUE])
    fun postArgs2048(@RequestParam body: Map<String,String>): String {
        printArgs(body)
        return s2048
    }
    
    @RequestMapping(value="/postArgsMulti2048", method=[RequestMethod.POST],
                    consumes=[MediaType.MULTIPART_FORM_DATA_VALUE])
    fun postArgsMulti2048(s: MultipartHttpServletRequest): String {
         val prefix = "abc"
        for (char in 'a'..'z') {
            val v = s.getParameter(prefix + char)
            print(v)
        }
        return s2048
    }
}