package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	cloudevents "github.com/cloudevents/sdk-go"
)

// HelloWorld defines the Data of CloudEvent with type=dev.knative.samples.helloworld
type HelloWorld struct {
	// Msg holds the message from the event
	Msg string `json:"msg,omitempty"`
}

// HiFromKnative defines the Data of CloudEvent with type=dev.knative.samples.hifromknative
type HiFromKnative struct {
	// Msg holds the message from the event
	Msg string `json:"msg,omitempty"`
}
type eventData struct {
	Message string `json:"message,omitempty,string"`
}

func receive(ctx context.Context, event cloudevents.Event, response *cloudevents.EventResponse) error {
	log.Printf("%s\n", time.Now())
	time.Sleep(1000 * time.Millisecond)
	// fmt.Printf("☁️ %s cloudevents.Event\n%s", event.String(), time.Now())

	return nil
}

func handler(w http.ResponseWriter, r *http.Request) {
	log.Print("Hello world received a request.")
	target := os.Getenv("TARGET")
	if target == "" {
		target = "World"
	}
	fmt.Fprintf(w, "Hello %s!\n", target)
}

func main() {
	c, err := cloudevents.NewDefaultClient()
	if err != nil {
		log.Fatalf("failed to create client, %v", err)
	}
	log.Fatal(c.StartReceiver(context.Background(), receive))
}
