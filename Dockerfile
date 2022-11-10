FROM ubuntu:18.04

LABEL maintainer="June Kim" version="1.0"

ARG USERNAME=myuser
ARG UID=9001
ARG GID=9001
ARG ROS_MASTER_URI=http://localhost:11311
ARG ROS_HOSTNAME=localhost

ENV DEBIAN_FRONTEND=noninteractive \
  LANG=en_US.UTF-8 \
  LANGUAGE=en_US \
  TZ=Asia/Seoul \
  APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn \
  ROS_MASTER_URI=$ROS_MASTER_URI \
  ROS_HOSTNAME=$ROS_HOSTNAME

RUN set -eux \
  && apt-get update \
  && apt-get install -y apt-utils locales \
  && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && dpkg-reconfigure --frontend=noninteractive locales \
  && update-locale LANG=en_US.UTF-8 \
  && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
  && apt-get install -y systemd vim man-db manpages curl lsb-release gnupg2 \
  && sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
  && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - \
  && apt-get update \
  && apt-get install -y ros-melodic-ros-base \
  python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential \
  && rosdep init

RUN set -eux \
  && mkdir /xycar_ws \
  && echo ". /opt/ros/melodic/setup.bash" >> ~/.bashrc \
  && echo ". /xycar_ws/devel/setup.bash" >> ~/.bashrc \
  && echo "alias chx='find /xycar_ws -type f -exec chmod +x {} +'" > ~/.bash_aliases \
  && echo "alias cm='chx && cd /xycar_ws && catkin_make'" >> ~/.bash_aliases \
  && rosdep update

VOLUME /xycar_ws
WORKDIR /xycar_ws

# For slave(non-ros-core) mode
ENTRYPOINT ["/bin/bash","-c", "mkdir -p /xycar_ws/src; . /opt/ros/melodic/setup.bash && catkin_make; trap : TERM INT; sleep infinity & wait"]

# For master(ros-core) mode
#ENTRYPOINT ["/bin/bash","-c", "mkdir -p /xycar_ws/src; . /opt/ros/melodic/setup.bash && catkin_make && roscore"]
