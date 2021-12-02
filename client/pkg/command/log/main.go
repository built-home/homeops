package main

import (
	"context"
	"fmt"
	stlog "log"

	"github.com/teaglebuilt/homelab/pkg/log"
	"github.com/teaglebuilt/homelab/pkg/service"
)

func main() {
	log.Run("./app.log")

	host, port := "localhost", "4000"

	ctx, err := service.Start(
		context.Background(),
		"Log Service",
		host, port, log.RegisterHandlers,
	)
	if err != nil {
		stlog.Fatal(err)
	}
	<-ctx.Done()
	fmt.Println("shutting down log service")
}
