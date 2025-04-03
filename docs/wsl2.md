# WSL2 環境で Docker + ROS1 Noetic を動作させる手順

## WSL2 の有効化と Ubuntu のインストール

https://learn.microsoft.com/ja-jp/windows/wsl/install

Dockerコンテナ上で ROS1 Noetic を実行するので、Ubuntuのバージョンは最新版で問題ありません。

## Docker Desktop のインストール

https://www.docker.com/ja-jp/products/docker-desktop/

※大企業の場合は有料サブスクリプションが必要です。

## docker-noetic-capcのコンテナ作成前準備

Ubuntuのシェルを開き、
```sh
mkdir ~/src
mkdir -p ~/catkin_ws/src
mkdir -p ~/.ros/log
```

Ubuntuの.bashrcに以下を追加
```
export DISPLAY=:0
export LIBGL_ALWAYS_INDIRECT=1
```

## docker-noetic-capcのコンテナ作成

Ubuntuのシェルを開き、

```sh
sudo apt update
sudo apt upgrade -y
sudo apt install -y git
git clone https://github.com/CA-Giken/docker-noetic-capc
cd ./docker-noetic-capc

docker compose up rosnoetic --build
```

## Rvizの実行テスト

Ubuntuのシェルを開き、
```sh
docker compose exec rosnoetic bash
source /opt/ros/noetic/setup.bash
roscore

# 別シェルを開き、
docker compose exec rosnoetic bash
source /opt/ros/noetic/setup.bash
rviz
```

## Catkin Workspace を作成する

Ubuntuのシェルを開き、
```sh
docker compose exec rosnoetic bash
cd catkin_ws
source /opt/ros/noetic/setup.bash
catkin build
source devel/setup.bash
roscore
```