# GNU GCC & other Libraries ontop of Debian

# Setup basic image for tool complication to take place in
FROM debian as base
USER 0
RUN \
  apt-get -y update && \
  apt-get -y install \
    autoconf \
    clang \
    curl \
    build-essential \
    libc++-dev \
    libgflags-dev \
    libgtest-dev \
    libtool \
    make \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Compile any tools we cannot install from packages
FROM base as builder
USER 0
RUN \
  apt-get -y update && \
  apt-get -y install \
    git \
    && rm -rf /var/lib/apt/lists/* \
    && \
  # Protocol Buffer & gRPC
  # install protobuf first, then grpc, then grpc_cli
  git clone -b $(curl -L https://grpc.io/release) \
      https://github.com/grpc/grpc /var/local/git/grpc && \
    cd /var/local/git/grpc && \
    git submodule update --init && \
    echo "--- installing protobuf ---" && \
    cd third_party/protobuf && \
    ./autogen.sh && ./configure --enable-shared && \
    make -j$(nproc) && make install && make clean && ldconfig && \
    echo "--- installing grpc ---" && \
    cd /var/local/git/grpc && \
    make -j$(nproc) && make install && make clean && ldconfig && \
    make -j$(nproc) grpc_cli

# Put the main image together
FROM base
LABEL \
 Description="Basic GNU gcc Debian environment with a number of libraries configured" \
 MAINTAINER="Thomas Thorne <TafThorne@GoogleMail.com>"
# Copy over pre-made tools
# Protocol Buffer
COPY --from=builder /usr/local/bin/protoc /usr/local/bin/
COPY --from=builder /usr/local/include/google/protobuf /usr/local/include/google/protobuf
COPY --from=builder /usr/local/lib/libproto* /usr/local/lib/
COPY --from=builder /usr/local/lib/pkgconfig/protobuf*.pc /usr/local/lib/pkgconfig/
# gRPC
COPY --from=builder /usr/local/bin/grpc_* /usr/local/bin/
COPY --from=builder /usr/local/include/grpc /usr/local/include/grpc
COPY --from=builder /usr/local/include/grpc++ /usr/local/include/grpc++
COPY --from=builder /usr/local/include/grpcpp /usr/local/include/grpcpp
COPY --from=builder /usr/local/lib/libaddress_sorting* \
                    /usr/local/lib/libgpr* \
                    /usr/local/lib/libgrpc* \
                    /usr/local/lib/
COPY --from=builder /usr/local/lib/pkgconfig/gpr.pc \
                    /usr/local/lib/pkgconfig/grpc*.pc \
                    /usr/local/lib/pkgconfig/
# grpc_cli
COPY --from=builder /var/local/git/grpc/bins/opt/grpc_cli /usr/local/bin/
# Install remaining tools using apt-get
RUN \
  apt-get -y update && \
  apt-get -y install \
    cppcheck \
    cpputest \
    git \
    lcov \
    libhdf5-cpp-100 \
    libhdf5-dev \
    libhdf5-serial-dev \
    libspdlog-dev \
    libwebsockets-dev \
    libwebsocketpp-dev \
    netcat-openbsd \
    pkg-config \
    uuid-dev \
    valgrind \
    zip \
  && rm -rf /var/lib/apt/lists/*; \
  adduser builder -uid 1000 --disabled-password --gecos "Bob Builder,1,2,3"; \
  echo "builder:.builder" chpasswd
USER builder

