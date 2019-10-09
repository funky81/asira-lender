FROM golang:alpine

ARG APPNAME="asira_lender"
ARG ENV="dev"

RUN mkdir -p /go/src/asira_lender
WORKDIR /go/src/asira_lender

RUN apk add --update git gcc libc-dev;
#  tzdata wget gcc libc-dev make openssl py-pip;

RUN go get -u github.com/golang/dep/cmd/dep

COPY . /go/src/asira_lender
RUN go build

EXPOSE 8000
