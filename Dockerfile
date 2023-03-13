# Base image
FROM ubuntu:latest

# Install required packages
RUN apt-get update && apt-get install build-essential git cmake libcrypto++-dev libgmp-dev libreadline-dev libcurl4-gnutls-dev ocl-icd-libopencl1 opencl-headers mesa-common-dev libmicrohttpd-dev wget unzip -y
# RUN apt-get update && apt-get install -y\
#     wget \
#     unzip \
#     build-essential \
#     cmake \
#     git \
#     libboost-all-dev \
#     libssl-dev \
#     libprotobuf-dev \
#     protobuf-compiler \
#     libcurl4-openssl-dev \
#     libjansson-dev \
#     libjemalloc-dev

# Download and extract Ethereum mining software
RUN wget https://github.com/ethereum-mining/ethminer/releases/download/v0.18.0/ethminer-0.18.0-cuda-8-linux-x86_64.tar.gz
RUN tar -zxvf ethminer-0.18.0-cuda-8-linux-x86_64.tar.gz

# Build Ethereum mining software
WORKDIR /bin

# Set entrypoint
ENTRYPOINT ["./ethminer"]
EXPOSE 5000

# Set default command
CMD ["--farm-recheck 200 -G -P stratum://0xBF34397049c7B7834C96590798D70fF58ec586b7@us1-etc.ethermine.org:14444"]
