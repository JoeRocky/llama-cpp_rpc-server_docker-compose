# Stage 1: Build
FROM ubuntu:24.04 AS builder
RUN apt-get update && apt-get install -y \
    build-essential cmake git libcurl4-openssl-dev

WORKDIR /build
RUN git clone https://github.com/ggml-org/llama.cpp.git .

# For Cuda support add: -DGGML_CUDA=ON
RUN cmake -B build -DGGML_RPC=ON -DCMAKE_BUILD_TYPE=Release
RUN cmake --build build --config Release -j$(nproc)

# Stage 2: Runtime
FROM ubuntu:24.04
RUN apt-get update && apt-get install -y libgomp1 curl && apt-get clean
WORKDIR /app

COPY --from=builder /build/build/bin/* .
