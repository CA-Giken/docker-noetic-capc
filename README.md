# ROS1 Noetic コンテナ環境構築

- [当レポジトリの作成経緯](docs/purpose.md)

# 動作環境

- docker 24.0.2
- docker-compose 2.19.1
- MX Linux 23.2 Libretto (Linux Kernel 6.6.12)

# インストール手順

## Dockerインストール
[docs/docker.md](docs/docker.md)

## ROS Kinetic + PhoXi Camera 環境構築 と PhoXi利用方法
[docs/kinetic.md](docs/kinetic.md)

## ROS Noetic 環境構築
[docs/noetic.md](docs/noetic.md)

## Xserverセットアップ
[docs/xserver.md](docs/xserver.md)

## マウントディレクトリ作成
ホスト側で以下のディレクトリを作成する。
- `~/catkin_ws/src`: ROSパッケージ群
- `~/src`: ROSパッケージ以外の共有ファイル
- `~/.ros/log`: ログファイル出力先

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
## ファイルマウント
`docker-compose.yml`ファイルの中の`volumes`を変更する
```yaml
    volumes:
      - type: bind
        source: ~/catkin_ws/src
        target: /app/catkin_ws/src
      - type: bind
        source: ~/src
        target: /app/src
```

`source`がホスト側、`target`がコンテナ側で、ファイル共有を行える。

`source`を書き換えればホスト側のホーム直下の`catkin_ws`以外も共有できる。

(`catkin_ws/src`をマウントしているのは、`devel`等はアンマウントごとに消去したいため)

`catkin_ws`以外のファイルを共有したい場合には、

## USB ポートを共有

`docker-compose.yml`の、`devices`以下にホストと共有するシリアルポート追加
