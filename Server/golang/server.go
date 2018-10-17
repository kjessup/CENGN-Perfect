package main

import (
    "log"
    "net/http"
)

func Repeat(s string, count int) string {
    b := make([]byte, len(s)*count)
    bp := copy(b, s)
    for bp < len(b) {
        copy(b[bp:], b[:bp])
        bp *= 2
    }
    return string(b)
}

var s1024 = []byte(Repeat("A", 1024))

func handlerEmpty(w http.ResponseWriter, r *http.Request) {
    
}

func handler1024(w http.ResponseWriter, r *http.Request) {
    w.Write(s1024)
}

func main() {
    http.HandleFunc("/empty", handlerEmpty)
    http.HandleFunc("/1024", handler1024)
    log.Fatal(http.ListenAndServe(":8282", nil))
}