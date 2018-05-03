package main

import (
	"fmt"
	"net/http"
)

func main() {
  http.HandleFunc("/", index)
  err := http.ListenAndServe(":8080", nil)

  if err != nil {
    fmt.Println("Serve Http:", err)
  }
}

func index(w http.ResponseWriter, r *http.Request) {

  fmt.Fprint(w,"\n")
  fmt.Fprint(w,"                              ##\n")
  fmt.Fprint(w,"                        ## ## ##        ==\n")
  fmt.Fprint(w,"                     ## ## ## ## ##    ===\n")
  fmt.Fprint(w,"                 /`````````````````\\___/ ===\n")
  fmt.Fprint(w,"            ~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~~/~ === ~~~\n")
  fmt.Fprint(w,"                 \\______ o           __/\n")
  fmt.Fprint(w,"                   \\    \\         __/\n")
  fmt.Fprint(w,"                    \\____\\_______/\n")
  fmt.Fprint(w," _           _    _                _            _\n")
  fmt.Fprint(w,"| |     ___ | |  | |    ___     __| | ___   ___| | _____ _ __\n")
  fmt.Fprint(w,"| |___ / _ \\| |  | |   / _ \\   / _  |/ _ \\ / __| |/ / _ \\ '__|\n")
  fmt.Fprint(w,"|  _  |  __/| |__| |__| (_) | | (_| | (_) | (__|   <  __/ |\n")
  fmt.Fprint(w,"|_| |_|\\___/ \\___|\\___|\\___/   \\__,_|\\___/ \\___|_|\\_\\___|_|\n")
  fmt.Fprint(w,"\n")
}
