# DockerからHostのXサーバに出力する
1. ホスト側Xサーバの設定
- /etc/lightdm/lightdm.confの変更 
  デフォルトでは外部からの接続(TCP)を受け付けないので変更が必要。
  ~~~
    xserver-allow-tcp=true
  ~~~
- 確認
  Xをリブートして、ポート6000に接続
  ~~~
    telnet localhost 6000
  ~~~
  接続されれば外部接続が可能となっている(特に何も表示されない)。
- 表示テスト(xeyesをlocalhost経由で表示)
  ~~~
    export DISPLAY=localhost:0
    xeyes
  ~~~
  上は自分自身のDisplayにTCP経由で表示する例だが、localhostを他の端末のアドレスに変えれば、その端末に表示される。
- 外部からの接続を許可
  外部端末(Dockerのコンテナ含め)からXサーバへの接続は、初期状態では禁止されている。これを許可するのがxhostコマンド。全て許可していいなら
  ~~~
    xhost +
  ~~~
  一台ずつ許可するときは、"+"の後にホスト名を示す。

2. テスト
- 確認
  Dockerを立ち上げて、bashで入ってみる。以下を確認。
  - /etc/hosts
  - DISPLAY変数
- アプリ
  - xeyes
  ホストに目玉が表示されればOK
  - rviz
  ROSが入っていれば、これもOK。



# Dockerfile, docker-compose設定メモ
1. docker-compose.yml
- extra_hosts
  コンテナーからホストに接続するために、"host-gateway"というキーワードでホストを定義する。
  ~~~
    extra_hosts:
      - "display:host-gateway"
  ~~~
  この例ではdocker up時に、displayというホストが/etc/hostsに登録される(確認してみる)。
- DISPLAY環境変数
  大昔からXのアプリは、単純にこの変数のホストに出力するという仕組みになっている。環境変数に以下を追加しておくと、コンテナ側で起動されたXのアプリは、displayというホストにあるXサーバに出力しようとする(結果としてホストのディスプレイに表示される)。
  ~~~
    environment:
      DISPLAY=display:0
  ~~~

2. DockerFile
- apt install
  テスト用に、"ping","telnet","xeyes"くらいがあると便利
  ~~~
    RUN apt install -y iputils-ping telnet x11-apps
  ~~~
