FROM golang:1.12 AS builder

WORKDIR /go/src/github.com/rcperlin/rds_exporter
COPY . ./
RUN make build

FROM        alpine:latest

COPY --from=builder /go/src/github.com/rcperlin/rds_exporter/rds_exporter /bin/rds_exporter
#COPY rds_exporter  /bin/
# COPY config.yml           /etc/rds_exporter/config.yml

RUN apk update && \
    apk add ca-certificates && \
    update-ca-certificates

EXPOSE      9042
ENTRYPOINT  [ "/bin/rds_exporter", "--config.file=/etc/rds_exporter/config.yml" ]
