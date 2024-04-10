# osrfが提供するrosイメージ（タグがnoetic-desktop-full）をベースとしてダウンロード
FROM osrf/ros:noetic-desktop-full

# Docker実行してシェルに入ったときの初期ディレクトリ（ワークディレクトリ）の設定
WORKDIR /root/

RUN apt-get update && \
    apt-get install -y psmisc openjdk-8-jdk libjava3d-java policykit-1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 

# ROSの環境整理
# ROSのセットアップシェルスクリプトを.bashrcファイルに追記
RUN echo "source /opt/ros/noetic/setup.sh" >> .bashrc
# 自分のワークスペース作成のためにフォルダを作成
RUN mkdir -p catkin_ws/src
# srcディレクトリまで移動して，catkin_init_workspaceを実行．
# ただし，Dockerfileでは，.bashrcに追記した分はRUNごとに反映されないため，
# source /opt/ros/noetic/setup.shを実行しておかないと，catkin_init_workspaceを実行できない
RUN cd catkin_ws/src && . /opt/ros/noetic/setup.sh && catkin_init_workspace
# ~/に移動してから，catkin_wsディレクトリに移動して，上と同様にしてcatkin_makeを実行．
RUN cd && cd catkin_ws && . /opt/ros/noetic/setup.sh && catkin_make
# 自分のワークスペースが反映されるように，.bashrcファイルに追記．
RUN echo "source ./catkin_ws/devel/setup.bash" >> .bashrc

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