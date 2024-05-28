# ROS1 Noetic コンテナ環境構築

- [当レポジトリの作成経緯](docs/purpose.md)

# 動作環境

- docker 24.0.2
- docker-compose 2.19.1
- MX Linux 23.2 Libretto (Linux Kernel 6.6.12)

# インストール手順

## Docker インストール

https://docs.docker.com/engine/install/ubuntu/

### 0. コンフリクトの可能性のあるパッケージを削除

```sh
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
```

### 1. Docker の apt レポジトリを追加

```sh
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

### 2. Docker インストール

```sh
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### 3. Docker 起動テスト

```sh
sudo docker run hello-world
```

MX Linux では、ここで

```sh
Cannot connect to the Docker daemon at unix:///var/run/docker.sock
```

のエラーが発生します。

### 4. systemd を設定

`sudo service docker start`を実行するとエラーなく開始されますが、
`sudo service docker status`でステータスを確認すると、daemon の起動に失敗しているようです。

この原因は分かりませんが、MX Linux では SysVinit を init プロセスとして利用しており、Ubuntu のように systemd を利用していません。
とりあえず、ここを Ubuntu に合わせることで対応します。

https://e-penguiner.com/mx-linux-troubleshooting-system-has-not-been-booted-with-systemd-as-init-system/
こちらの URL を参考に、MX Linux で systemd を利用するように設定します。

- メニューで「`boot`」で検索 -> 「`MX 起動設定ツール`」を選択
- 起動先を, `MX 23.2 Libretto, with Linux 6.6.12-1-liquorix-amd64 (systemd)`に変更
- 再起動

再起動後、`sudo docker run hello-world`でテストが通ります。

## ROS 環境構築

```sh
git clone https://github.com/CA-Giken/docker-noetic-ursim.git
```

### catkin_ws ディレクトリの作成

```sh
mkdir -p ~/catkin_ws/src
```

### 初回ビルド

```sh
cd /path/to/docker-noetic-ursim
docker compose up --build
```

### catkin workspace の初期化

```sh
cd path/to/docker-noetic-ursim
docker compose exec rosnoetic bash -c "cd /app/catkin_ws && catkin build"
```

# 利用方法

1. ホスト側で、Xserver のアクセスを許可

```sh
xhost +
```

2. コンテナに入り、roscore, rviz 等を立ち上げ

```sh
cd path/to/docker-noetic-ursim
docker compose exec rosnoetic bash
```

ここで roscore, rviz など実行
`source /app/catkin_ws/devel/setup.bash`が必要かもしれない

# 設定

## 画面解像度の変更

`docker-compose.yml`の`rosnoetic`サービスの環境変数`RESOLUTION=1920x1080`を変更

1440x900, 1280x760

## USB ポートを共有

`docker-compose.yml`の`rosnoetic`サービス、`devices`以下にホストと共有するシリアルポート追加
