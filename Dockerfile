FROM golang:alpine AS build
WORKDIR /go/src/gdrive
RUN apk add --no-cache git ca-certificates
COPY . .
#ENV GO111MODULE=off
#RUN go get github.com/tools/godep \
#  && godep restore
#RUN go mod init
#RUN go build  -ldflags '-w -s'
RUN go get -v -u github.com/monakez/gdrive

FROM alpine:latest AS bin
COPY --from=build /go/bin/gdrive /
ENTRYPOINT ["/gdrive"]
