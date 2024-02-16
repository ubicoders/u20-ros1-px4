FROM osrf/ros:noetic-desktop-full

RUN apt update
RUN apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential -y
RUN rosdep update

RUN apt-get update && apt-get -y --quiet --no-install-recommends install \
	apt-utils \
	autoconf \
	automake \
	bison \
	bzip2 \
	build-essential \
	ca-certificates \
	ccache \
	cmake \
	cppcheck \
	curl \
	dmidecode \
	dirmngr \
	dirmngr \
	doxygen \
	file \
	flex \
	g++ \
	genromfs \
	gcc \
	gdb \
	git \
	gnupg2 \         
	gosu \
	gperf \
	lcov \
	libncurses-dev \
	libcunit1-dev \
	libfreetype6-dev \
	libgtest-dev \
	libpng-dev \
	libssl-dev \
	libasio-dev \
	libtinyxml2-dev \
	libtool \ 
	lsb-release \
	make \
	nano \
	ninja-build \
	openjdk-8-jdk \
	openjdk-8-jre \
	openssh-client \
	picocom \
	screen \
	pkg-config \
	python3-dev \
	python3-pip \
	rsync \
	software-properties-common \
	shellcheck \
	tzdata \
	tree \
	uncrustify \
	unzip \
	valgrind \
	vim-common \
	wget \
	xsltproc \
	zip \
	&& apt-get -y autoremove \
	&& apt-get clean autoclean \
	&& rm -rf /var/lib/apt/lists/*

RUN echo "source /opt/ros/noetic/setup.zsh" >> ~/.zshrc
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash >> /root/.bashrc"

RUN apt install curl -y

RUN apt update
RUN apt-get install python3-catkin-tools python3-rosinstall-generator -y
RUN mkdir -p /home/ubuntu/catkin_ws/src
WORKDIR /home/ubuntu/catkin_ws/
RUN catkin init
RUN wstool init src
RUN wstool init

WORKDIR /home/ubuntu
COPY ./download_px4_autopilot.bash /home/ubuntu/download_px4_autopilot.bash
COPY ./install_px4.bash /home/ubuntu/install_px4.bash
RUN bash install_px4.bash
RUN rm -r /home/ubuntu/install_px4.bash

RUN rosinstall_generator --rosdistro noetic mavlink | tee /tmp/mavros.rosinstall
RUN rosinstall_generator --upstream mavros | tee -a /tmp/mavros.rosinstall
COPY ./install_mavros.bash /home/ubuntu/install_mavros.bash


# Install miniconda to /miniconda
RUN curl -LO http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -p /miniconda -b
RUN rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH=/miniconda/bin:${PATH}
RUN conda update -y conda
RUN conda install -c anaconda -y python=3.11.0
RUN conda install -c anaconda  conda-build
RUN conda init bash
COPY ./requirements.txt /home/ubuntu/requirements.txt
RUN pip install -r /home/ubuntu/requirements.txt
RUN pip3 install -r /home/ubuntu/requirements.txt
RUN rm -r /home/ubuntu/requirements.txt

RUN apt-get install python3-tk -y