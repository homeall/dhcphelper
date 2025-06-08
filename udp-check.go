package main

import (
	"fmt"
	"net"
	"os"
	"time"
)

func main() {
	conn, err := net.DialTimeout("udp", "127.0.0.1:67", 3*time.Second)
	if err != nil {
		fmt.Fprintf(os.Stderr, "UDP port 67 check failed: %v\n", err)
		os.Exit(1)
	}
	defer conn.Close()
	fmt.Println("UDP port 67 is open and responding.")
}
