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

CMD if [ "${ENV}" = "dev" ] ; then \
        cp deploy/dev-config.yaml config.yaml ; \
    fi \
    && dep ensure -v \
    && go build -v -o "${APPNAME}" 
RUN ls -alh $GOPATH/src/
RUN ls -alh $GOPATH/src/"${APPNAME}"

FROM alpine
WORKDIR $GOPATH/src/"${APPNAME}"
COPY --from=build-env $GOPATH/src/"${APPNAME}" /app/
RUN ls -alh $GOPATH/src/"${APPNAME}"
RUN ls -alh $GOPATH/src/
RUN ls -alh /app/
ENTRYPOINT ./app/"${APPNAME}"

EXPOSE 8000
