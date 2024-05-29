# tiryohの提供する Noetic + VNC イメージ
FROM tiryoh/ros-desktop-vnc:noetic

# Docker実行してシェルに入ったときの初期ディレクトリ（ワークディレクトリ）の設定
WORKDIR /app/

# Python
RUN apt-get update && \
    apt-get install -y software-properties-common
RUN add-apt-repository universe && apt-get update   
RUN apt-get install -y git build-essential python3 python3-venv python3-pip python3-tk tk-dev

RUN apt-get install -y iputils-ping telnet x11-apps

# Python packages
RUN python3 -m pip install PySimpleGUI pytk tkfilebrowser pymsgbox
RUN python3 -m pip install open3d

# for rviz_animted_view_controller
RUN apt-get install -y qt5-default qtscript5-dev libqwt-qt5-dev

# Rovi setup
ENV LIBGL_ALWAYS_SOFTWARE=1
ENV ORGE_RTT_MODE=Copy
RUN apt-get install -y automake intltool libgstreamer*-dev
RUN wget http://ftp.gnome.org/pub/GNOME/sources/aravis/0.6/aravis-0.6.0.tar.xz
RUN tar -xvf aravis-0.6.0.tar.xz
RUN cd aravis-0.6.0 && ./configure && make && make install

# CAPC
RUN pip install pyserial	

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* 

# Command copy
COPY ./entrypoint.sh /app/
CMD ["/bin/sh", "-c", "./entrypoint.sh"]