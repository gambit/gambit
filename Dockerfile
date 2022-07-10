FROM gcc:9.3.0
WORKDIR gambit_install
COPY . .
RUN make clean && ./configure --enable-single-host && make -j$(nproc) && make check && make modules && make doc && make install
RUN ln -s /gambit_install/gsi/gsi /bin/gsi && ln -s /gambit_install/gsc/gsc /bin/gsc
WORKDIR /workdir
