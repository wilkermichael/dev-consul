FROM ubuntu:22.04
RUN apt-get update && apt-get install -y iptables curl
ENV ENVOY_VERSION_STRING=1.24.9
#ENV FUNC_E_PLATFORM=linux/amd64
RUN curl -L https://func-e.io/install.sh | bash -s -- -b /usr/local/bin
RUN func-e use $ENVOY_VERSION_STRING
RUN cp ~/.func-e/versions/$ENVOY_VERSION_STRING/bin/envoy /usr/local/bin/

# Copy Consul and the simple service
COPY ./consul /usr/local/bin
COPY ./forwardsrv /usr/local/bin
