FROM golang:alpine  AS build-env

ARG APPNAME="asira_lender"
ARG ENV="dev"

RUN adduser -D -g '' golang
USER root

ADD . $GOPATH/src/"${APPNAME}"
WORKDIR $GOPATH/src/"${APPNAME}"

RUN apk add --update git gcc libc-dev;
#  tzdata wget gcc libc-dev make openssl py-pip;
RUN go get -u github.com/golang/dep/cmd/dep

RUN cp deploy/dev-config.yaml config.yaml
RUN dep ensure -v
RUN go build -v -o "${APPNAME}"

RUN ls -alh $GOPATH/src/
RUN ls -alh $GOPATH/src/"${APPNAME}"

FROM alpine
WORKDIR /app/
COPY --from=build-env $GOPATH/src/"${APPNAME}" /app/

RUN ls -alh
RUN ls -alh /app/
RUN "${APPNAME}"

EXPOSE 8000
