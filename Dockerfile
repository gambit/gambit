FROM gcc:latest as builder

ARG ENABLE_SINGLE_HOST="--enable-single-host"
ARG ENABLE_MARCH="--enable-march=native"
ARG ENABLE_DCLIB="--enable-dynamic-clib"
ARG NPROC=1

WORKDIR gambit_install

COPY . .

RUN ./configure $ENABLE_SINGLE_HOST $ENABLE_MARCH $ENABLE_DCLIB
RUN make -j${NPROC}
RUN make check
RUN make modules
RUN make doc
RUN make install
RUN make clean

RUN ln -s /gambit_install/gsi/gsi /bin/gsi && ln -s /gambit_install/gsc/gsc /bin/gsc

WORKDIR /workdir
