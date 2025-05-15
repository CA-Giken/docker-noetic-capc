# 簡易版 Docker + ROS1 環境構築

## インストール方法

### Docker インストール

[docs/docker.md](../../docs/docker.md)

### ROS 用セットアップ

以下3つのディレクトリを作成する。
- `~/catkin_ws/src`: ROS パッケージ群
- `~/src`: ROS パッケージ以外の共有ファイル
- `~/.ros/log`: ログファイル出力先

```sh
mkdir -p ~/catkin_ws/src
mkdir -p ~/src
mkdir -p ~/.ros/log
```

### GUI (Xserver) セットアップ

[../../docs/xserver.md](../../docs/xserver.md)

## 利用方法

### ホスト側で Xserver のアクセスを許可
```sh
xhost +
```

### Dockerコンテナの起動
```sh
cd path/to/docker-noetic-capc/examples/simple
docker compose up
```

### roslaunch や rviz 等を起動
```sh
docker compose exec rosnoetic bash

# dockerコンテナ内
cd catkin_ws
cd roslaunch xxx xxx.launch