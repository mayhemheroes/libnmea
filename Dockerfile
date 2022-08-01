# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang git build-essential

## Add source code to the build stage.
ADD . /libnmea
WORKDIR /libnmea

## Build
RUN mkdir -p build
WORKDIR build
RUN CC=clang cmake .. -DNMEA_BUILD_FUZZ=1
RUN make -j$(nproc)

# Package Stage
FROM --platform=linux/amd64 ubuntu:20.04
COPY --from=builder /libnmea/build/bin/libnmea-fuzz /

## Configure corpus
COPY --from=builder /libnmea/tests/parse_stdin_test_in.txt /
RUN mkdir /corpus
RUN split -l 1 /parse_stdin_test_in.txt /corpus/seed

## Set up fuzzing!
ENTRYPOINT []
CMD /libnmea-fuzz /corpus
