package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/ping", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "PONG")
	})

	fmt.Printf("server running on port %d\n", 8081)
	log.Fatal(http.ListenAndServe(":8081", nil))
}
