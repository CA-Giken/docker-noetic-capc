# ROS Kinetic + PhoXi Camera 環境構築

```sh
git clone https://github.com/CA-Giken/docker-noetic-ursim.git
```

## catkin_ws ディレクトリの作成

```sh
mkdir -p ~/kinetic/catkin_ws/src
```

## PhoXiControl のダウンロード

1. [https://www.photoneo.com/downloads/phoxi-control/]から`PhoXi Control 1.2.35`をダウンロードます。
2. 解凍し、`kinetic/phoxi/PhotoneoPhoXiControlInstaller-1.2.35-Ubuntu16-STABLE.run`に配置します。

## 初回ビルド

```sh
cd /path/to/docker-noetic-ursim
docker compose up --build
```

# PhoXi 利用方法

## PhoXiControlの起動

1. 
```sh
cd path/to/docker-noetic-ursim
docker compose exec roskinetic bash -c "PhoXiControl"
```
2. 左カラムからデバイスを選択し、`Connect`

## scanner_idの設定

コンテナ内で、
`/app/catkin_ws/src/phoxi_camera/config/phoxi_camera.yaml`
にある`scanner_id`に値を設定する。(ホスト側から変更してもいい)

テストIDの場合は、`scanner_id=InstalledExamples-basic-example`に設定する。

※実カメラを接続している場合だと`scanner_id`は`number`になるらしく、設定不要かも。

## ROS phoxi_cameraの起動

```sh
cd path/to/docker-noetic-ursim
docker compose exec roskinetic bash
cd catkin_ws
catkin build
source devel/setup.bash
roslaunch phoxi_camera phoxi_camera.launch
```

rvizを同時に立ち上げたい場合は`roslaunch phoxi_camera phoxi_camera_test.launch`かもしれない。

## ROS phoxi_camera と PhoXiControlの疎通確認

```sh
cd path/to/docker-noetic-ursim
docker compose exec roskinetic bash
cd catkin_ws
rosservice call /phoxi_camera/get_frame "in_: -1"
```

## rostopicへの点群データPublish
1. PhoXiControlで、



# PhoXiメモ
## Noetic対応
ここにプルリクがOpenの状態で残っている
[https://github.com/photoneo/phoxi_camera/pull/52]

# rostopicへの継続Publish
ここにプルリクが残っている
[https://github.com/photoneo/phoxi_camera/pull/60]

`trigger_mode: 0`に設定する必要もあるかも。
[https://github.com/photoneo/phoxi_camera/issues/55]