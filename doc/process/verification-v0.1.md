# v0.1 検証記録

確認日：2026-10-04。実行環境はLinux、JDK 21、Flutter 3.47.6 / Dart 3.13.5。

| 確認 | 結果 |
|---|---|
| `flutter analyze` | 指摘なし |
| `flutter test` | 2件成功。画面から予約・QR・モック入場まで、SDKから写真・持込完了・再起動後の復元まで |
| `flutter build web` | 成功。実API接続設定を含むWeb成果物を生成 |
| `gradle test` | 6件成功。状態遷移、時刻境界、QR暗号、画像内容、domainの依存方向 |
| `gradle databaseTest` | 4件成功。所有者・施設・ロール、取消、冪等性、同時QR受付、写真・完了、生成型と物理列・型・NULL制約の一致 |
| `gradle bootJar` | 成功 |
| `dart run tool/api_smoke.dart` | 実HTTPで成功。生成SDK → Spring Boot → DB。予約再送・QR入場再送・JPEG/PNG送信・JPEG取得・持込完了・訪問回収取消 |
| OpenAPI再生成 | consumer/backyardを結合し、SpringとDart SDKを生成・コンパイル。multipart用テンプレートの修正を適用 |

## 実行環境の差

この検証環境にはDockerがない。DB結合とHTTP疎通はPGlite（PostgreSQL 18.3のWASM版）をTCPで起動して実施した。検証用にFlywayのtransactional lockを無効化し、PGliteの接続多重化を使用した。この設定とPGliteはリポジトリの実行構成には入れていない。

配布するComposeのPostgreSQL 16.15、Windows/WSLのlocalhost転送、Android/iOSのビルドと実機カメラはこの環境では実行していない。CodeBuild用buildspecを配置したが、AWS資源・トリガーは作成していない。

ブラウザー実画面のスクリーンショット確認は、検証用Chromiumの取得に失敗したため未実施。画面の遷移とレイアウト例外はFlutter widget testで確認した。撮影・QRカメラ読取は[ローカル開発手順](local-development.md)で実機確認する。

## 再実行

ローカルのDocker DBを起動し、`backend/gradlew databaseTest`でPostgreSQL 16.15に対する同じ結合試験を実行する。DB結合試験は専用スキーマを作り、試験後に削除する。`dart run tool/api_smoke.dart`は起動済みのBEにテスト予約を2件作る。
