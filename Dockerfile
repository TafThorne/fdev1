# GNU GCC & other Libraries ontop of Debian

#Compile any tools we cannot install from packages
FROM gcc:7 as builder
USER 0
RUN \
  apt-get -y update && \
  apt-get -y install \
    clang \
    libc++-dev \
    libgflags-dev \
    libgtest-dev
RUN \
  # Protocol Buffer & gRPC
  # install protobuf first, then grpc
  git clone -b $(curl -L https://grpc.io/release) \
      https://github.com/grpc/grpc /var/local/git/grpc && \
    cd /var/local/git/grpc && \
    git submodule update --init && \
    echo "--- installing protobuf ---" && \
    cd third_party/protobuf && \
    ./autogen.sh && ./configure --enable-shared && \
    make -j$(nproc) && make install && make clean && ldconfig 

FROM gcc:7
LABEL \
 Description="Basic GNU gcc Debian environment with a number of libraries configured" \
 MAINTAINER="Thomas Thorne <TafThorne@GoogleMail.com>"
# Copy over pre-made tools
# Protocol Buffer
COPY --from=builder /usr/local/lib/libproto* /usr/local/lib/
COPY --from=builder /usr/local/bin/protoc /usr/local/bin/
COPY --from=builder /usr/local/include/google/protobuf /usr/local/include/google/protobuf
RUN apt-get -y update && \
  apt-get -y install \
    uuid-dev \
    cppcheck \
    cpputest \
    lcov \
    libhdf5-cpp-100 \
    libhdf5-dev \
    libhdf5-serial-dev \
    libspdlog-dev \
    libwebsockets-dev \
    libwebsocketpp-dev \
    netcat-openbsd \
    zip;\
  adduser builder -uid 1000 --disabled-password --gecos "Bob Builder,1,2,3"; \
  echo "builder:.builder" chpasswd
USER builder

