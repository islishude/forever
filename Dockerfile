# syntax=docker/dockerfile:1.3
FROM --platform=${BUILDPLATFORM} golang:1.18.3-bullseye as compiler
WORKDIR /app
COPY . .
RUN go install -v -ldflags '-d -s -w'

FROM --platform=${BUILDPLATFORM} debian:bullseye
RUN apt-get update && apt-get install -y dnsutils aria2 tmux git curl tar lz4 && rm -rf /var/lib/apt/lists/*
COPY --from=compiler /go/bin/forever /usr/local/bin/
CMD [ "forever" ]
