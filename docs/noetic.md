# ROS Noetic 環境構築
```sh
git clone https://github.com/CA-Giken/docker-noetic-ursim.git
```

## catkin_ws ディレクトリの作成

```sh
mkdir -p ~/noetic/catkin_ws/src
```

## 初回ビルド

```sh
cd /path/to/docker-noetic-ursim
docker compose up --build
```
