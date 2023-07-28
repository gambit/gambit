FROM gcc:latest

ARG ENABLE_SINGLE_HOST="--enable-single-host"
ARG ENABLE_MARCH="--enable-march=native"
ARG ENABLE_DCLIB="--enable-dynamic-clib"

WORKDIR gambit_install

COPY . .

RUN ./configure $ENABLE_SINGLE_HOST $ENABLE_MARCH $ENABLE_DCLIB
RUN make -j$(nproc)
RUN make check
RUN make modules
RUN make doc
RUN make install

RUN ln -s /gambit_install/gsi/gsi /bin/gsi && ln -s /gambit_install/gsc/gsc /bin/gsc

WORKDIR /workdir
