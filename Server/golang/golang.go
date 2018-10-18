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
var s2048 = []byte(Repeat("A", 2048))
var s4096 = []byte(Repeat("A", 4096))

func handlerEmpty(w http.ResponseWriter, r *http.Request) {
    
}

func handler1024(w http.ResponseWriter, r *http.Request) {
    w.Write(s1024)
}

func handler2048(w http.ResponseWriter, r *http.Request) {
    w.Write(s2048)
}

func handler4096(w http.ResponseWriter, r *http.Request) {
    w.Write(s4096)
}

func main() {
    http.HandleFunc("/empty", handlerEmpty)
    http.HandleFunc("/1024", handler1024)
    http.HandleFunc("/2048", handler2048)
    http.HandleFunc("/4096", handler4096)
    log.Fatal(http.ListenAndServe(":8282", nil))
}