# syntax=docker/dockerfile:1.3
FROM --platform=${BUILDPLATFORM} golang:1.18-alpine as compiler
WORKDIR /app
COPY . .
RUN go install -v -ldflags '-d -s -w'

FROM --platform=${BUILDPLATFORM} alpine:3.16
RUN apk add --no-cache curl git bind-tools ca-certificates aria2 tmux
COPY --from=redis /usr/local/bin/redis-cli /usr/local/bin/
COPY --from=compiler /go/bin/forever /usr/local/bin/
CMD [ "forever" ]
