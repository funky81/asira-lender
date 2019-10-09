FROM golang:alpine  AS build-env

ARG APPNAME="asira_lender"
ARG ENV="dev"

#RUN adduser -D -g '' golang
#USER root

ADD . $GOPATH/src/"${APPNAME}"
WORKDIR $GOPATH/src/"${APPNAME}"

RUN apk add --update git gcc libc-dev;
#  tzdata wget gcc libc-dev make openssl py-pip;
RUN go get -u github.com/golang/dep/cmd/dep

RUN cd $GOPATH/src/"${APPNAME}"
RUN cp deploy/dev-config.yaml config.yaml
RUN dep ensure -v
RUN go build -v -o "${APPNAME}-res"

RUN ls -alh $GOPATH/src/
RUN ls -alh $GOPATH/src/"${APPNAME}"
RUN pwd

FROM alpine
WORKDIR /app/
COPY --from=build-env $GOPATH/src/"${APPNAME}"/"${APPNAME}-res" /app/

RUN ls -alh
RUN ls -alh /app/
ENTRYPOINT /app/"${APPNAME}-res"

EXPOSE 8000
