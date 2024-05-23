# ROS1 Noetic + URSim コンテナ環境構築

- ROS1 Noetic VNC: [https://github.com/Tiryoh/docker-ros-desktop-vnc]
- URSim VNC: [https://hub.docker.com/r/universalrobots/ursim_e-series]

この 2 つの Docker イメージを起動し、相互通信できるようにセットアップする。

# 当レポジトリの目的

ROS1 の開発は終了しており、ROS1 の最終バージョン Noetic は Ubuntu 20.04 環境まででしか動作しません。(サポート終了 2025 年 5 月)
そのため、これまでは Ubuntu 20.04 環境を用意して、そこで ROS1 を動かすのが通例でした。

しかし、CPU のバージョンアップに伴い Linux Kernel 6 以上への対応が求められます。
Intel 第 13 世代以降の CPU は Linux Kernel 6 で対応されており、これは Ubuntu 23 や Linux Mint 21.3 Edge Edition 等になります。

試しに Intel i7 13700K (Z790) を採用した PC に Linux Mint 20.3(Ubuntu 20.04)を導入すると、以下の不具合が発生しました。

- オンボード LAN ポートの使用不可 (I219-V, I220-V)
- マルチディスプレイの利用不可

また、P コア / E コアの利用が運任せになり、思ったより計算速度が出ない現象もあるようです。[https://qiita.com/KazuhisaFujita/items/d6fb61c7d67e07039bc5]

CPU の調達や計算能力の向上を検討すると Intel 第 13 世代以降を採用したくなる場合は多いと思いますが、これらの理由により採用が難しいです。

そこで解決方法としては、

- VMWare 等の仮想マシンを利用する
- Docker コンテナを利用する
- ROS Noetic を Ubuntu22.04 環境(Jammy) でビルドする [https://tech.groove-x.com/entry/noetic-on-jammy], [https://medium.com/@jean.guillaume.durand/installing-ros-noetic-on-ubuntu-22-04-1678e9dab1f5]
- そのまま Ubuntu 20.04 を使う(PCI-E に LAN ポート増設、DisplayLink によるマルチディスプレイ対応、E コアの利用停止)

が挙げられます。
下２つは茨の道なので、上２つを検討する事になりますが、今回は計算速度の向上が目的なので VMWare より Docker を利用することにしました。

# 当レポジトリの注意点

x
当レポジトリの Docker 環境は、スタンドアローンな環境で利用する前提で作られています。
そのため、ネットワークに常時接続して利用する事を想定しておらず、セキュリティ面は考慮しておりません。
利用の際には、適宜改修をお願いいたします。

# 動作環境

- docker 24.0.2
- docker-compose 2.19.1
- MX Linux 23.2 Libretto (Linux Kernel 6.6.12)

# インストール手順

## Docker インストール

# 利用方法

- ブラウザから`localhost:6080`に接続
- VNC 接続後、F11 キーで全画面表示
- ターミナルから`roscore`等
- 別画面にて、`localhost:8080/vnc.html`に接続し、URSim の GUI を表示

# 設定

## 画面解像度の変更

`docker-compose.yml`の`rosnoetic`サービスの環境変数`RESOLUTION=1920x1080`を変更

1440x900, 1280x760

## URSim programs の変更

`docker-compose.yml`の`ursim`サービスの環境変数`ROBOT_MODEL=UR10`を変更

# MEMO

## Java JDK 8

```
sudo apt-get update
sudo apt-get install openjdk-8-jdk -y
sudo update-alternatives --config java # Select JDK 8
```

# URSim environment

```
docker run --rm -it -p 5900:5900 -p 6080:6080 --name ursim -v ~/src:/opt/src universalrobots/ursim_e-series
```

```
docker exec -it ursim bash
```
