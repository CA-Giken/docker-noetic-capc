# ROS1 Noetic コンテナ環境構築

- [当レポジトリの作成経緯](docs/purpose.md)

## 動作環境

- docker 24.0.2
- docker-compose 2.19.1
- MX Linux 23.2 Libretto (Linux Kernel 6.6.12)

## 利用例
### 簡易版
[examples/simple](examples/simple)

### デバイス利用
[examples/with_devices](examples/with_devices)

対応デバイス
- Ensenso
- PhoXi (対応中)


## その他

### WSL2環境セットアップ

[docs/wsl2.md](docs/wsl2.md)

### CAPC 対応

- ホスト側で`sudo pip install git+https://github.com/CA-Giken/capc-host.git`
- 起動サービスに`capc-host`追加

## 設定

### ファイルマウント

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

### USB ポートを共有

`docker-compose.yml`の、`devices`以下にホストと共有するシリアルポート追加

## 発生した不具合と対応方法一覧

### Docker daemon が落ちる

`docker compose up rosnoetic --build`でビルド完了後、`exporting to image`の最中に
`failed to receive status: rpc error: code = Unavailable desc = error reading from server: EOF`エラー。

そのあと、`docker compose up`を行うと

`Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?`

のエラーが発生した。

対応:

- `sudo service docker restart`でサービスを立ち上げる

### ビルド中のエラー

`docker compose up --build`中にエラーが発生

対応:

- ネットワークの確認（通信速度が 1Mbs しか出ていなかった）
- とりあえず再度ビルドしてみると通る
