ARG ubuntu_version
FROM ubuntu:$ubuntu_version

RUN apt-get update -y

ENV DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime

ARG repkalinux_packages
RUN apt-get install -y $repkalinux_packages

RUN curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN curl https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list'
RUN sh -c 'echo "deb [trusted=yes] https://content.runescape.com/downloads/ubuntu trusty non-free" > /etc/apt/sources.list.d/runescape.list'
RUN sh -c 'echo "deb https://download.sublimetext.com/ apt/stable/" > /etc/apt/sources.list.d/runescape.list'

RUN apt-get update -y

ARG repkalinux_deb
COPY $repkalinux_deb /debs/
RUN gdebi -n /debs/*.deb

ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics,utility

ARG user_name
ARG user_id
RUN adduser --disabled-password --gecos "" --uid $user_id $user_name
RUN adduser $user_name sudo
RUN echo "$user_name ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && chmod 0440 /etc/sudoers.d/user
USER $user_name
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics,utility
WORKDIR /home/$user_name/RepkaLinux

CMD ["/bin/bash", "-c", "Xephyr :1 -ac -br -screen 1920x1080 -resizeable -reset -terminate"]