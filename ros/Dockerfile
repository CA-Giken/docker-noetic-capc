# tiryohの提供する Noetic + VNC イメージ
FROM tiryoh/ros-desktop-vnc:noetic

# Docker実行してシェルに入ったときの初期ディレクトリ（ワークディレクトリ）の設定
WORKDIR /app/

# Python
RUN apt-get update && \
    apt-get install -y software-properties-common
RUN add-apt-repository universe && apt-get update   
RUN apt-get install -y git build-essential python3 python3-venv python3-pip python3-tk tk-dev

# Python packages
RUN python3 -m pip install PySimpleGUI pytk

# for rviz_animted_view_controller
RUN apt-get install -y qt5-default qtscript5-dev libqwt-qt5-dev

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* 

# Command copy
COPY ./run.sh /app/