# Docker インストール

[https://docs.docker.com/engine/install/debian/]

## 0. コンフリクトの可能性のあるパッケージを削除

```sh
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
```

## 1. Docker の apt レポジトリを追加

```sh
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
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

- メニューで「`boot`」で検索 -> 「`MX 起動設定ツール`」を選択
- `Kernel parameters`を`quiet splash init=lib/systemd/systemd`に変更
- 再起動

再起動後、`sudo docker run hello-world`でテストが通ります。

参考: [https://e-penguiner.com/mx-linux-troubleshooting-system-has-not-been-booted-with-systemd-as-init-system/]

### 5. 権限を付与

スーパーユーザー権限でなくても`docker`コマンドを実行できるように`docker`ユーザーグループに追加します。

```sh
sudo usermod -aG docker ros
```

権限付与ののち、再ログイン。
