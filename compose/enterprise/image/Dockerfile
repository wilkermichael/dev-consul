FROM golang:1.20.7-bullseye
RUN apt-get update && apt-get install -y iptables curl

RUN go install github.com/go-delve/delve/cmd/dlv@latest

ENV ENVOY_VERSION_STRING=1.24.8
#ENV FUNC_E_PLATFORM=linux/amd64
RUN curl -L https://func-e.io/install.sh | bash -s -- -b /usr/local/bin
RUN echo func-e versions
RUN func-e use $ENVOY_VERSION_STRING
RUN cp ~/.func-e/versions/$ENVOY_VERSION_STRING/bin/envoy /usr/local/bin/

# Copy Consul and the simple service
COPY ./consul /usr/local/bin
COPY ./forwardsrv /usr/local/bin
