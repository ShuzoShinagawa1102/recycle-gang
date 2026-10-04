# v0.1の実装範囲

| 対象 | 実装 |
|---|---|
| ユーザーFlutter | ホーム、依頼方法、回収品、施設・地図リンク、日時、住所・都道府県、確認・完了、一覧・詳細、QR、写真・持込完了、下書き、プロフィール、料金・テスト決済履歴 |
| 基幹 | Java 21 / Spring Boot 3.5.16。customer・catalog・reservationのモジュラーモノリス |
| DB | PostgreSQL 16.15用Compose、Flyway DDL、local専用fixture、jOOQ 3.19.33の生成型 |
| API | consumer / backyard / 共通型のOpenAPI、生成Spring interface/DTO、生成Dart Dio SDK |
| QR入場 | 乱数トークン・暗号化保存・有効期限・施設認可・重複防止。ローカル管理人のカメラ/コード受付画面 |
| モック | Dioの通信層で差替え。予約・プロフィール・写真を端末に保存。実APIと同じSDKを使用 |
| ローカル実行 | DBだけDocker、BEとFlutterはホストで実行。Windows/WSL、Android、macOS/iOSの起動手順 |

v0.1はローカル利用を対象とする。外部IdP・実決済・プッシュ通知・業者による訪問回収実績・backyardアプリ本体・最適化・AWS公開は実行対象に含めない。お知らせとやることは予約状態から表示する。

検証コマンドと環境差は[ローカル開発](local-development.md)および[検証記録](verification-v0.1.md)に記録する。定義を変更するときは、業務ルール・契約・SQL・コード・試験を同じ変更で更新する。
