FROM golang:1.12 as builder
WORKDIR /prometheus-exporter-sample
COPY . .
RUN go get
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app

FROM alpine
COPY --from=builder /prometheus-exporter-sample/app /usr/local/bin/app
CMD ["app"]