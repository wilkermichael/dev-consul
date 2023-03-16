package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
)

/*
Usage
./forwardsrv <http-address-to-use> <name-of-service>

Endpoints
/forward
* Forwards a request to an address provided as part of the addr query parameter
* eg. /forward?addr=localhost:8558/err

/err
* Returns the string error along with the name of this service

/
* Returns a friendly `hi` message along with the name of this service
*/

func forward(w http.ResponseWriter, r *http.Request) {
	addr := r.URL.Query().Get("addr")
	resp, err := http.Get("http://" + addr)
	if err != nil {
		w.WriteHeader(500)
		fmt.Fprintf(w, "Err. %v\n", err)
		return
	}
	defer resp.Body.Close()
	io.Copy(w, resp.Body)
}

func err(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(500)
	fmt.Fprintf(w, "Err. %s\n", os.Args[2])
}

func handle(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "Hi.", os.Args[2])
}

// Args
// 1) http address
// 2) service name
func main() {
	http.HandleFunc("/", handle)
	http.HandleFunc("/error", err)
	http.HandleFunc("/forward", forward)
	log.Println("Starting.")

	// Get address from input
	// eg. forwardsrv "localhost:8558"
	log.Fatalln(http.ListenAndServe(os.Args[1], nil))
}
