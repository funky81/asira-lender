FROM golang:alpine

ARG APPNAME="asira_lender"
ARG ENV="dev"

RUN ln -sf /bin/bash /bin/sh
RUN useradd -ms /bin/bash newuser
USER newuser
WORKDIR /go/src/asira_lender


RUN apk add --update git gcc libc-dev;
#  tzdata wget gcc libc-dev make openssl py-pip;

RUN go get -u github.com/golang/dep/cmd/dep

CMD if [ "${ENV}" = "dev" ] ; then \
        cp deploy/dev-config.yaml config.yaml ; \
    fi \
    && dep ensure -v \
    && go build -v -o $GOPATH/bin/"${APPNAME}" \
    # run app mode
    && "${APPNAME}" run \
    # update db structure
    && if [ "${ENV}" = "dev"] ; then \
        "${APPNAME}" migrate up \
        && "${APPNAME}" seed ; \
    fi \
    && go test tests/*_test.go -failfast -v ;

EXPOSE 8000
