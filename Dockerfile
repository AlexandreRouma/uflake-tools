FROM ubuntu:latest

# Setup container
WORKDIR /root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update -y

# Install dependencies
RUN apt install -y build-essential cmake automake clang bison flex libreadline-dev gawk tcl-dev libffi-dev git graphviz xdot pkgconf python3-dev libboost-all-dev zlib1g-dev wget libeigen3-dev libftdi1-dev gnat unzip

# Install Yosys
RUN wget https://github.com/YosysHQ/yosys/archive/refs/tags/yosys-0.12.zip
RUN unzip yosys-0.12.zip
WORKDIR /root/yosys-yosys-0.12
RUN make -j$(nproc) config-gcc && make -j$(nproc) && make install
WORKDIR /root

# Install Icestorm
RUN git clone https://github.com/YosysHQ/icestorm
WORKDIR /root/icestorm
RUN make -j$(nproc) && make install
WORKDIR /root

# Install NextPnR
RUN git clone https://github.com/YosysHQ/nextpnr
WORKDIR /root/nextpnr
RUN cmake . -DARCH=ice40 -DCMAKE_PREFIX_PATH=/usr/share/cmake/Modules/ && make -j$(nproc) && make install
WORKDIR /root

# Install GHDL
RUN git clone https://github.com/ghdl/ghdl
WORKDIR /root/ghdl
RUN ./configure && make -j$(nproc) && make install
WORKDIR /root

# Install GHDL plugin for Yosys
RUN git clone https://github.com/ghdl/ghdl-yosys-plugin
WORKDIR /root/ghdl-yosys-plugin
RUN make -j$(nproc) && mkdir -p /usr/local/share/yosys/plugins && cp ghdl.so /usr/local/share/yosys/plugins/
WORKDIR /root

# Install PiPico SDK
RUN git clone --recurse-submodules https://github.com/raspberrypi/pico-sdk
ENV PICO_SDK_PATH=/root/pico-sdk
RUN apt install -y xxd gcc-arm-none-eabi