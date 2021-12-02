package main

import (
	"log"

	"github.com/teaglebuilt/homelab/pkg/command"
)

func main() {
	log.Printf("command")
	command.Watch()
}
