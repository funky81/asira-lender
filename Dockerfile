FROM golang:alpine

ARG APPNAME="asira_lender"
ARG ENV="dev"

RUN adduser -D -g '' newuser

ADD . $GOPATH/src/"${APPNAME}"
WORKDIR $GOPATH/src/"${APPNAME}"

RUN apk add --update git gcc libc-dev;
#  tzdata wget gcc libc-dev make openssl py-pip;

RUN go get -u github.com/golang/dep/cmd/dep
RUN go build

EXPOSE 8000
