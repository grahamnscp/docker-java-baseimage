FROM golang:1.8-alpine
COPY hello-docker-web.go /go
RUN go build hello-docker-web.go

FROM alpine:latest
COPY --from=0 /go/hello-docker-web /
EXPOSE 8080
CMD /hello-docker-web
