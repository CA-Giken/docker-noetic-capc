# tiryohの提供する Noetic + VNC イメージ
FROM tiryoh/ros-desktop-vnc:noetic

# Docker実行してシェルに入ったときの初期ディレクトリ（ワークディレクトリ）の設定
WORKDIR /root/

# URSim Setup
RUN apt-get update && \ 
    apt-get install -y psmisc openjdk-8-jdk libjava3d-java policykit-1
# COPY ./ursim-dependencies /root/ursim-dependencies
# RUN dpkg -i ./ursim-dependencies/*.deb

# SSH Setup
RUN apt-get install -y openssh-server

# Python
RUN apt-get update && \
    apt-get install -y software-properties-common
RUN add-apt-repository universe && apt-get update   
RUN apt-get install -y git build-essential python3 python3-venv python3-pip python3-tk tk-dev

# Python packages
RUN python3 -m pip install git+https://github.com/UniversalRobots/RTDE_Python_Client_Library.git
RUN python3 -m pip install PySimpleGUI pytk

# Pyenv
RUN python3 -m venv ursim-env

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* 

# Command copy
COPY ./run.sh /root/