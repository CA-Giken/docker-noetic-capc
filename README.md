# ROS1 Noetic コンテナ環境構築

- [当レポジトリの作成経緯](docs/purpose.md)

# 動作環境

- docker 24.0.2
- docker-compose 2.19.1
- MX Linux 23.2 Libretto (Linux Kernel 6.6.12)

# インストール手順

## Dockerインストール
[docs/docker.md]

## ROS Kinetic + PhoXi Camera 環境構築 と PhoXi利用方法
[docs/PhoXi.md]

## ROS Noetic 環境構築
[docs/noetic.md]

## Xserverセットアップ
[docs/xserver.md]

# 利用方法

1. ホスト側で、Xserver のアクセスを許可

```sh
xhost +
```

2. コンテナ立ち上げ

```sh
cd path/to/docker-noetic-ursim
docker compose up rosnoetic
```
Kineticなら`roskinetic`

3. コンテナに入り、roscoreやcatkin buildを実行
```sh
cd path/to/docker-noetic-ursim
docker compose exec noetic bash
cd catkin_ws
catkin build
```

# 設定

## 画面解像度の変更

`docker-compose.yml`の`rosnoetic`サービスの環境変数`RESOLUTION=1920x1080`を変更

1440x900, 1280x760

## USB ポートを共有

`docker-compose.yml`の、`devices`以下にホストと共有するシリアルポート追加
