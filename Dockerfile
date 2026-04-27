FROM ubuntu:focal
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
  wget make cmake gcc g++ gfortran git vim pkg-config \
  libeigen3-dev python3-pip libboost-all-dev libhdf5-dev \
  libssl-dev libxml2-dev libpciaccess-dev libopenblas-dev \
  liblapack-dev python3-pybind11 stunnel4

RUN pip3 install --upgrade pip
RUN pip3 install "setuptools==59.8.0"
RUN pip3 install numpy==1.24.2 scipy==1.10.1

RUN wget https://github.com/mongodb/mongo-c-driver/releases/download/1.17.3/mongo-c-driver-1.17.3.tar.gz
RUN tar -xzf mongo-c-driver-1.17.3.tar.gz
RUN mkdir -p mongo-c-driver-1.17.3/cmake-build
RUN cd mongo-c-driver-1.17.3/cmake-build && cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_PREFIX_PATH=/usr ..
RUN cd mongo-c-driver-1.17.3/cmake-build && make install

RUN wget https://github.com/mongodb/mongo-cxx-driver/archive/r3.6.2.tar.gz
RUN tar -xzf r3.6.2.tar.gz
RUN mkdir -p mongo-cxx-driver-r3.6.2/build
RUN cd mongo-cxx-driver-r3.6.2/build && cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_VERSION=3.6.2 -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_PREFIX_PATH=/usr ..
RUN cd mongo-cxx-driver-r3.6.2/build && make install

RUN git clone https://github.com/qcscine/puffin.git
RUN cd puffin && pip3 install .

ENV PUFFIN_PROGRAMS_XTB_AVAILABLE=true

RUN python3 -m scine_puffin configure
RUN sed -i 's/march: native/march: ""/g' puffin.yaml
RUN python3 -m scine_puffin -c puffin.yaml bootstrap
RUN mv puffin.sh /scratch/puffin.sh
RUN mv puffin.yaml /scratch/puffin.yaml.template
RUN chmod u+x /scratch/puffin.sh
RUN sed -i 's/export OMP_NUM_THREADS=1/export OMP_NUM_THREADS=${OMP_NUM_THREADS:-1}/' /scratch/puffin.sh

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
