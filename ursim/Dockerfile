
FROM universalrobots/ursim_e-series

WORKDIR /root/

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y git python3-venv python3-pip 

# URCapインストール
RUN apt-get install -y policykit-1
COPY ./programs/* /urcaps/*
COPY ./programs /ursim/programs

# MX Linux対応 venv環境作成
RUN python3 -m venv ursim

# IOmonitUR対応 https://github.com/KazukiHiraizumi/IOmonitUR
RUN apt-get install -y python3-tk tk-dev
RUN . ./ursim/bin/activate && \
    python3 -m pip install PySimpleGUI && \
    python3 -m pip install git+https://github.com/UniversalRobots/RTDE_Python_Client_Library.git


# キャッシュクリア
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* 