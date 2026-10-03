# 技術スタック案

更新日：2026-10-03。採用方針と追加提案を区別する。ここに書いた候補は依存ファイルへの適用済みを意味しない。

## 現行確認

main `22cb860b9dc7937bdf0ec95485840cca05ef84f1`を確認した。

- backend：Spring Boot 3.5.16、Java toolchain 22、Gradle。Webと起動テストの骨組み。Gradle Wrapperは未配置。
- Flutter：pubspecでDart `^3.13.4`、Riverpod `^3.4.3`、go_router `^18.0.2`。既存の選択を起点にする。
- backyard、optimizer：今回の文書整備前は空リポジトリ。

## 推奨構成

| 対象 | 方針／候補 | 状態・理由 |
|---|---|---|
| Java | Java 25 LTSへの移行を提案 | 現在の22を維持したまま記録。長期運用用のJDK選択としてレビューする |
| BE | Spring Boot 3.5系を当面継続 | 既存構成を起点にし、JDK・依存ライブラリ・サポート期間を実装着手時に再確認 |
| ビルド | Gradle Wrapper、Java toolchain、依存ロック | Gradle採用済み。Wrapperの版はBoot pluginとJDKの両方に適合させる |
| モジュール | Spring Modulithの境界検証・モジュール試験 | 提案。Gradleを多数のサブプロジェクトに分けることは初期必須にしない |
| DBアクセス | jOOQ、JDBC、Springのトランザクション | 合意済み。生成器と実行時のjOOQ版を一致させる |
| マイグレーション | Flyway SQL | 合意済み。JPA/HibernateはDDL生成目的では追加しない |
| DB | Aurora PostgreSQL互換 Serverless v2 | Auroraは合意済み、PostgreSQL互換を具体案とする |
| API | REST/JSON、OpenAPI Generator | 合意済み。Spring API interface/DTO、dart-dio SDKを生成 |
| API仕様版 | OpenAPI 3.0.3から開始する案 | Spring・Dart・Pythonの生成互換性を実契約で確認後に固定。最新版への追随を目的にしない |
| 認証・認可 | Spring Security、OIDC、M2M専用認証 | 提案。IdPは未決、Cognito等を別途比較。所属業者・予約所有権はアプリで確認 |
| Flutter | 既存Riverpod、go_router、生成SDK＋Dio | 既存資産を継続。Flutter SDK自体も固定し、pubspec.lockを管理 |
| Python | FastAPI、Pydantic、uv、pytest | FastAPIは合意済み。他は提案。Pythonは3.12系を初期互換性検証の起点にする |
| 経路ソルバー | OR-Toolsを第一候補 | 未採用。容量・時間窓・計算時間・未割当の扱いを小さなケースで検証 |
| AWS実行 | ECS Fargate、ECR、ALB、S3、CloudFront | ECS等は合意済み。Fargateを具体案とする |
| IaC | Terraform | 提案。全体infraを基幹リポジトリで管理し、環境別state。アカウント/リージョン確定後に実装 |
| CI | CodePipeline V2＋CodeBuild | 合意済み。iOSのmacOS実行のみ別途選定 |
| 監視 | CloudWatch、Actuatorの制限公開 | 提案。業務エラー・計算失敗・配布失敗も監視対象 |

上記候補のうちJava/Gradle/jOOQの具体的な組合せは [公式互換表](../reference/engineering-sources.md) で検証する。jOOQ OSSと商用版では必要JDKやサポートDBが異なるため、Spring Boot BOM、jOOQコード生成器、利用DBの整合を確認する。未検証の具体的バージョンを一括で書き換えない。

## バージョン固定と更新

ツール・依存・コンテナベースイメージは固定して再現性を確保する。更新は独立した変更としてCIで検証する。日次CI内で依存を勝手に最新化しない。契約生成器の版と設定もGit管理する。

移行PRでは現行/移行後JDKでのビルド、生成コード、DB結合試験を確認する。現在のJava 22指定を変更するかはTECH-01のレビュー対象。

## 今回選ばないもの

業務モジュールごとのマイクロサービス、参照専用DB、イベントソーシング、大規模なメッセージ基盤は初期必須にしない。ソルバー、地図・移動時間提供元、決済、通知、IdPは業務要件と費用を確認して選ぶ。
