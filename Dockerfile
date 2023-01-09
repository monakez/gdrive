FROM golang:alpine AS build
WORKDIR /go/src/gdrive
RUN apk add --no-cache git ca-certificates
COPY . .
#ENV GO111MODULE=off
#RUN go get github.com/tools/godep \
#  && godep restore
RUN go mod init \
  && go get -u \
  && go mod tidy
RUN go build  -ldflags '-w -s'
#RUN go install  github.com/monakez/gdrive@latest

FROM alpine:latest AS bin
ARG UID=1000
ARG GID=1000

RUN addgroup -g $GID gdrive && \
    adduser --shell /sbin/nologin --disabled-password \
    --no-create-home --uid $UID --ingroup gdrive gdrive

USER gdrive
ENV GDRIVE_CONFIG_DIR=/config

COPY --from=build /go/src/gdrive/gdrive /
ENTRYPOINT ["/gdrive"]
