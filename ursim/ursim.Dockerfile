
FROM universalrobots/ursim_e-series

WORKDIR /root/

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y git python3-pip 

# URCapインストール
RUN apt-get install -y policykit-1

# IOmonitUR対応 https://github.com/KazukiHiraizumi/IOmonitUR
RUN apt-get install -y python3-tk tk-dev
RUN . ./ursim/bin/activate && \
    python3 -m pip install PySimpleGUI && \
    python3 -m pip install git+https://github.com/UniversalRobots/RTDE_Python_Client_Library.git

# キャッシュクリア
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* 