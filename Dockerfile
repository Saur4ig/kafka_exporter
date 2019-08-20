FROM golang:1.12.6-alpine3.9 AS builder
ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GOLANGCI=1.13 GO111MODULE=on

WORKDIR /build-dir
RUN apk add --no-cache git
COPY ./go.mod ./go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build \
    -o /exporter-bin .

FROM quay.io/prometheus/busybox:latest
WORKDIR /exporter
USER nobody

COPY --from=builder /exporter-bin ./exporter-bin

EXPOSE     9308
ENTRYPOINT [ "/exporter/exporter-bin" ]
