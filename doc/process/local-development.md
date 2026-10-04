# ローカル開発 v0.1

## 構成

| 実行場所 | プロセス | 接続先 |
|---|---|---|
| Windows | Flutter Web / Androidエミュレーター | API `localhost:8080` / `10.0.2.2:8080` |
| Windows | Spring Boot・JDK 21 | PostgreSQL `localhost:5432` |
| WSL2 Ubuntu | Docker Engine・PostgreSQL 16.15 | DBだけコンテナ、永続ボリューム |

Flutter 3.47.6（Dart 3.13.5）、JDK 21、GitをWindowsにインストールし、`flutter doctor` と `java -version` を確認する。Gradleは同梱Wrapper 8.14.3を使う。iOSのビルド・実行にはmacOSとXcodeが必要。

## 初回：WSLとDocker

管理者PowerShell：

```powershell
wsl --install -d Ubuntu-24.04
```

再起動とUbuntuの利用者作成後、Ubuntu内で[Docker公式のapt導入手順](https://docs.docker.com/engine/install/ubuntu/#install-using-the-apt-repository)に従い、`docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin`をインストールする。

```sh
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"
exit
```

Ubuntuに入り直し、`docker version` と `docker compose version` を確認する。Windows側にcloneした同じリポジトリを、WSLから `/mnt/c/.../recycle-gang` として開く。以下のパスは自分の配置に置き換える。

```sh
cd /mnt/c/dev/recycle-gang
docker compose up -d --wait
docker compose ps
```

Windowsから `Test-NetConnection localhost -Port 5432` が成功することを確認する。WSLのlocalhost転送を使う。失敗した場合は[MicrosoftのWSLネットワーク手順](https://learn.microsoft.com/ja-jp/windows/wsl/networking)を確認する。

## 画面だけ起動する

リポジトリルートからWindows PowerShell：

```powershell
cd flutter
flutter pub get
flutter run -d chrome --web-port=7357 --dart-define=USE_MOCKS=true
```

DB・バックエンドは不要。画面右上に `MOCK` と表示する。モックデータと写真はこのブラウザー・アプリの保存領域に保持する。QR画面の「モック入場受付を実行」で管理人の操作を再現する。このボタンは実APIモードには表示しない。

## 実APIを起動する

DBを起動した上で、Windows PowerShellを2つ開く。

バックエンド：

```powershell
cd C:\dev\recycle-gang\backend
.\gradlew.bat bootRun --args="--spring.profiles.active=local"
```

起動時にFlywayがDDLとローカルfixtureを適用する。ユーザーアプリ：

```powershell
cd C:\dev\recycle-gang\flutter
flutter pub get
flutter run -d chrome --web-port=7357 --dart-define=USE_MOCKS=false --dart-define=API_BASE_URL=http://localhost:8080
```

画面右上は `LOCAL API`。`USE_MOCKS`はコンパイル時の環境値であり、切替時は`flutter run`を終了して起動し直す。未指定時はモックを使う。

| 設定 | 初期値 | 指定方法 |
|---|---|---|
| DB接続 | `jdbc:postgresql://localhost:5432/recycle_gang` | BE環境変数 `DB_URL` |
| DB利用者・パスワード | `recycle_gang` / `local-recycle-only` | `DB_USER` / `DB_PASSWORD` |
| API | `127.0.0.1:8080` | `SERVER_ADDRESS` / `SERVER_PORT` |
| 許可Web origin | `http://localhost:7357,http://127.0.0.1:7357` | `CORS_ORIGINS` |
| デモ利用者トークン | `local-user-demo` | BE `LOCAL_CONSUMER_TOKEN`、Flutter `--dart-define=LOCAL_API_TOKEN=...` |
| デモ管理人トークン | `local-manager-demo` | BE `LOCAL_MANAGER_TOKEN`、受付画面の入力欄 |
| QR暗号鍵 | local専用の固定値 | BE `TICKET_KEY`：32バイトをBase64化 |

Composeの`.env`はBEに自動読込されない。DB設定を変える場合はPowerShellにも`$env:DB_PASSWORD="..."`等を指定する。既存DBボリュームのパスワードはCompose環境値だけでは変更されない。QR暗号鍵を変えると保存済みQRを復号できなくなる。

## 持込を通して確認する

1. 「指定場所に持ち込む」→回収品を1種類以上→東エリア→今日→確認→予約。
2. 予約詳細で「入場QRコードを表示」。
3. 別ブラウザーで <http://localhost:8080/local/manager.html> を開く。QRをカメラで読み取るか、ユーザー画面のコピーボタンから貼り付け、「入場を記録する」。受付テスト画面の管理人は東エリアに所属する。
4. ユーザー画面の予約詳細へ戻る。手動更新または8秒ごとの再取得で「入場済み」になる。
5. 「写真を選ぶ」または「写真を撮る」でJPEG/PNGを登録し、「捨てました！」→確認。
6. 「完了」を確認する。退場の読み取りはない。

受付画面はローカル確認用であり、backyardアプリ本体とは別。カメラ利用時はブラウザーで許可する。Chromeのファイル選択から写真を登録すれば、同じPC内で全工程を確認できる。

## Android / iOS

Android StudioでSDKとエミュレーターを用意し、`flutter doctor --android-licenses`、`flutter devices`で確認する。

```powershell
flutter run -d <Android端末ID> --dart-define=USE_MOCKS=false --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

`10.0.2.2`はAndroidエミュレーターからWindowsホストへの接続先。USB実機では `adb reverse tcp:8080 tcp:8080` 後、`API_BASE_URL=http://127.0.0.1:8080`を指定できる。AndroidのローカルHTTP許可はdebugマニフェストに限定する。

macOSではPostgreSQLを同じComposeで起動できる。BEは`./gradlew bootRun --args='--spring.profiles.active=local'`、iOSシミュレーターは`flutter run -d <iOS端末ID> --dart-define=USE_MOCKS=false --dart-define=API_BASE_URL=http://localhost:8080`。カメラ撮影は実機で確認する。

## 試験・再生成

```powershell
# DB不要：業務状態、QR暗号、画像検証、アーキテクチャ
cd backend
.\gradlew.bat test
# 業務モジュールだけ検査
.\gradlew.bat test --tests "com.recyclegang.backend.reservation.*"
# Docker DB起動後：API・SQL・Flyway・jOOQ整合
.\gradlew.bat databaseTest
```

DB結合試験は`rg_test_<UUID>`スキーマを作成し、終了時に削除する。利用中のpublicスキーマのデータに触れない。

```powershell
cd flutter
flutter analyze
flutter test
flutter build web --dart-define=USE_MOCKS=false --dart-define=API_BASE_URL=http://localhost:8080
```

実HTTPで生成SDKから全工程を確認する場合は、BE起動後にFlutterディレクトリで `dart run tool/api_smoke.dart` を実行する。テスト予約を2件作成する。

OpenAPIを変更したら、リポジトリルートで`python scripts/generate-contracts.py`。Python 3、JDK、Flutter/Dartが必要。APIの生成物もコミットする。

DBを変更したら`db/migration/V2__....sql`のように追加し、BEの起動で適用後に`./gradlew generateJooq`（Windowsでは`.\gradlew.bat generateJooq`）を実行する。`src/generated/java`の差分を確認し、`databaseTest`を通す。適用済みSQLは変更しない。`db/local/R__local_fixtures.sql`は開発専用で、既存利用者データを上書きしない。

## 停止

Flutter・BEは各ターミナルで`Ctrl+C`。WSLで `docker compose stop`。DBデータはボリュームに残る。デモデータを完全に消してやり直すときだけ `docker compose down -v` を実行する。

公式資料：[Flutter導入](https://docs.flutter.dev/install)、[WSL導入](https://learn.microsoft.com/ja-jp/windows/wsl/install)、[Docker Engine](https://docs.docker.com/engine/install/ubuntu/)、[Flutter Web](https://docs.flutter.dev/platform-integration/web/building)。
