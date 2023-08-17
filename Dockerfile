FROM golang:1.20-alpine AS builder
WORKDIR /app
ARG TARGETARCH
RUN apk --no-cache --update add build-base gcc wget unzip
COPY . .
RUN env CGO_ENABLED=1 go build -o build/x-ui main.go
RUN ./DockerInitFiles.sh "$TARGETARCH"

FROM alpine
LABEL maintainer="Mr.Philipp <d3vilh@github.com>" org.opencontainers.image.authors="alireza7@gmail.com"
ENV TZ=Europe/Kyiv
WORKDIR /app

RUN apk add ca-certificates tzdata

COPY --from=builder  /app/build/ /app/
VOLUME [ "/etc/x-ui" ]
CMD [ "./x-ui" ]