FROM golang:alpine AS build
WORKDIR /src
RUN apk add --no-cache git ca-certificates
COPY . .
ENV GO111MODULE=off
#RUN go get github.com/tools/godep \
#  && godep restore
#RUN go build -o /out/ .
RUN go get github.com/monakez/gdrive

FROM alpine:latest AS bin
COPY --from=build /go/bin/gdrive /
ENTRYPOINT ["/gdrive"]
