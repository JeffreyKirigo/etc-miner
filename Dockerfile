# Base image
FROM ubuntu:focal
ARG DEBIAN_FRONTEND=noninteractive
# Install required packages
RUN apt-get update && apt-get install build-essential git cmake libcrypto++-dev libgmp-dev libreadline-dev libcurl4-gnutls-dev ocl-icd-libopencl1 opencl-headers mesa-common-dev libmicrohttpd-dev wget unzip -y
RUN mkdir neo
RUN cd neo &&\ 
    wget https://github.com/intel/compute-runtime/releases/download/19.07.12410/intel-gmmlib_18.4.1_amd64.deb &&\ 
    wget https://github.com/intel/compute-runtime/releases/download/19.07.12410/intel-igc-core_18.50.1270_amd64.deb &&\ 
    wget https://github.com/intel/compute-runtime/releases/download/19.07.12410/intel-igc-opencl_18.50.1270_amd64.deb &&\ 
    wget https://github.com/intel/compute-runtime/releases/download/19.07.12410/intel-opencl_19.07.12410_amd64.deb &&\ 
    wget https://github.com/intel/compute-runtime/releases/download/19.07.12410/intel-ocloc_19.07.12410_amd64.deb &&\
    apt install ./*.deb -y
# Download and extract Ethereum mining software
RUN wget https://github.com/ethereum-mining/ethminer/releases/download/v0.18.0/ethminer-0.18.0-cuda-8-linux-x86_64.tar.gz
RUN tar -zxvf ethminer-0.18.0-cuda-8-linux-x86_64.tar.gz

# Build Ethereum mining software
WORKDIR /bin

# Set entrypoint
ENTRYPOINT ["./ethminer"]

# Set default command
CMD ["--farm-recheck", "200", "-G", "-P", "stratum://0xBF34397049c7B7834C96590798D70fF58ec586b7@us1-etc.ethermine.org:14444"]
