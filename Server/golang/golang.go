package main

import (
    "log"
    "net/http"
    "runtime"
    "encoding/json"
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

var s2048 = []byte(Repeat("A", 2048))
var s8192 = []byte(Repeat("A", 8192))
var s32768 = []byte(Repeat("A", 32768))

type CRUDUser struct {
    Id string `json:"id"`
    FirstName string `json:"firstName"`
    LastName string `json:"lastName"`
}

func handlerEmpty(w http.ResponseWriter, r *http.Request) {
    
}

func handler2048(w http.ResponseWriter, r *http.Request) {
    w.Write(s2048)
}

func handler8192(w http.ResponseWriter, r *http.Request) {
	w.Write(s8192)
}

func handler32768(w http.ResponseWriter, r *http.Request) {
	w.Write(s32768)
}

// --

func read(r *http.Request) {
    prefix := "abc"
    for i := byte('a'); i <= byte('z'); i++ {
        s := prefix + string(byte(i))
        v := r.FormValue(s)
        _ = v
    }
}

func handlerGetArgs2048(w http.ResponseWriter, r *http.Request) {
    read(r)
	w.Write(s2048)
}
func handlerPostArgs2048(w http.ResponseWriter, r *http.Request) {
    r.ParseForm()
    read(r)
	w.Write(s2048)
}
func handlerPostArgsMulti2048(w http.ResponseWriter, r *http.Request) {
    r.ParseMultipartForm(32 << 20)
    read(r)
	w.Write(s2048)
}

func handlerJson(w http.ResponseWriter, r *http.Request) {
    var t CRUDUser
    err := json.NewDecoder(r.Body).Decode(&t)
    if err != nil {
        panic(err)
    }
    json.NewEncoder(w).Encode(t)
}


func main() {
    runtime.GOMAXPROCS(runtime.NumCPU())

    http.HandleFunc("/empty", handlerEmpty)
    http.HandleFunc("/2048", handler2048)
    http.HandleFunc("/8192", handler8192)
    http.HandleFunc("/32768", handler32768)

	http.HandleFunc("/getArgs2048", handlerGetArgs2048)
	http.HandleFunc("/postArgs2048", handlerPostArgs2048)
	http.HandleFunc("/postArgsMulti2048", handlerPostArgsMulti2048)
	http.HandleFunc("/json", handlerJson)

    log.Fatal(http.ListenAndServe(":8282", nil))
}
