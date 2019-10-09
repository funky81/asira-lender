FROM golang:alpine

ARG APPNAME="asira-lender"
ARG ENV="dev"

ADD . $GOPATH/src/"${APPNAME}"
WORKDIR $GOPATH/src/"${APPNAME}"

RUN apk add --update git gcc libc-dev sudo;
#  tzdata wget gcc libc-dev make openssl py-pip;

RUN go get -u github.com/golang/dep/cmd/dep

CMD if [ "${ENV}" = "dev" ] ; then \
        sudo cp deploy/dev-config.yaml config.yaml ; \
    fi \
    && sudo attrib -R +S vendor \
    && sudo dep ensure -v \
    && sudo go build -v -o $GOPATH/bin/"${APPNAME}" \
    # run app mode
    && sudo "${APPNAME}" run \

RUN go get ./
RUN go build

EXPOSE 8000
