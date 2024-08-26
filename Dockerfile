FROM ubuntu:18.04
RUN apt update && apt-get install -y python3-venv python3-pip git lsb-release

# Used for installing binwalk.
# Binwalk is mostly used for firmware analysis

RUN python3 -m pip install --upgrade pip setuptools wheel
RUN pip3 install nose coverage pycryptodome capstone cstruct ubi_reader Pillow

RUN apt-get install -y wget mtd-utils gzip bzip2 tar arj lhasa p7zip p7zip-full cabextract cramfsswap squashfs-tools sleuthkit default-jdk lzop srecord zlib1g-dev liblzma-dev liblzo2-dev python-lzo libjpeg-dev

RUN git clone https://github.com/devttys0/sasquatch
WORKDIR /sasquatch
RUN ./build.sh

WORKDIR /
# RUN (cd sasquatch && ./build.sh && cd ..)

# Install jefferson to extract JFFS2 file systems
RUN git clone https://github.com/sviehb/jefferson

WORKDIR /jefferson
RUN python3 setup.py install
WORKDIR /

# Install yaffshiv to extract YAFFS file systems
RUN git clone https://github.com/devttys0/yaffshiv
WORKDIR /yaffshiv

RUN python3 setup.py install

WORKDIR /

RUN git clone https://github.com/ReFirmLabs/binwalk.git
WORKDIR /binwalk
RUN python3 setup.py install

WORKDIR /

# Binwalk cleanup

RUN rm -rf /yaffshiv /jefferson /sasquatch /binwalk

# # Binref installation
# RUN mkdir ~/tools && mkdir ~/tools/binref
# RUN python3 -m venv ~/tools/binref/
# # RUN /bin/bash -c "source ~/tools/binref/ && pip install -U pip setuptools && pip install -U binary-refinery[all] && deactivate"