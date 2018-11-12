package ca.treefrog.spring

import org.springframework.web.bind.annotation.*
import org.springframework.web.multipart.MultipartFile
import org.springframework.http.MediaType
import org.springframework.util.MultiValueMap
import org.springframework.web.multipart.MultipartHttpServletRequest

var s2048 = "A".repeat(2048)
var s8192 = "A".repeat(8192)
var s32768 = "A".repeat(32768)

@RestController
class RoutesController {
    @GetMapping("/empty")
    fun empty() = ""
    
    @GetMapping("/2048")
    fun s2048() = s2048
    
    @GetMapping("/8192")
    fun s8192() = s8192
    
    @GetMapping("/32768")
    fun s32768() = s32768
    
    fun printArgs(body: Map<String,String>) {
        val prefix = "abc"
        for (char in 'a'..'z') {
            val v = body[prefix + char]
            //print(v)
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
            //print(v)
        }
        return s2048
    }
}