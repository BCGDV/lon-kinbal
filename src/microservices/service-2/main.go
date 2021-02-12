package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"time"
)

// Message ...
type Message struct {
	Service string
	Res     string
}

func main() {
	http.HandleFunc("/ping", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "PONG")
	})

	http.HandleFunc("/service/info", func(w http.ResponseWriter, r *http.Request) {
		timestamp := strconv.FormatInt(time.Now().UTC().UnixNano(), 10)
		timestampRes := fmt.Sprintf("Request received on %s", timestamp)
		m := &Message{"service-2", timestampRes}
		b, err := json.Marshal(m)
		if err != nil {
			fmt.Println(err)
			return
		}
		fmt.Fprintf(w, string(b))
	})

	fmt.Printf("server running on port %d\n", 8081)
	log.Fatal(http.ListenAndServe(":8081", nil))
}
