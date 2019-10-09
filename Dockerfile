FROM golang:alpine

ARG APPNAME="asira_lender"

RUN go get github.com/golang/dep/cmd/dep

# Gopkg.toml and Gopkg.lock lists project dependencies
# These layers will only be re-built when Gopkg files are updated
COPY Gopkg.lock Gopkg.toml /go/src/"${APPNAME}"
WORKDIR /go/src/"${APPNAME}"
# Install library dependencies
RUN dep ensure -vendor-only

# Copy all project and build it
# This layer will be rebuilt when ever a file has changed in the project directory
COPY . /go/src/"${APPNAME}"
RUN go build -o /bin/"${APPNAME}"

# This results in a single layer image
FROM scratch
COPY --from=build /bin/"${APPNAME}" /bin/"${APPNAME}"
ENTRYPOINT ["/bin/"${APPNAME}""]
CMD ["--help"]
