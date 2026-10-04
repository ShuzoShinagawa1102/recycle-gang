# 技術スタック

## 採用する技術

| 対象 | 技術 | 役割 |
|---|---|---|
| 基幹 | Java / Spring Boot / Gradle | 業務ユースケースとREST API |
| モジュール | Spring Modulith | 境界検証と業務モジュール単位の結合試験 |
| DB | Aurora PostgreSQL互換 Serverless v2 | 業務データ・ジョブ・履歴の永続化 |
| SQL | jOOQ / JDBC / Springトランザクション | 型付きSQLとドメインへの変換 |
| DB変更 | Flyway | 版付きDDL・必須データ変更 |
| API | REST / JSON / OpenAPI 3.0.3 | 提供者と利用者の契約 |
| コード生成 | OpenAPI Generator | Spring interface/DTO、Dart Dio SDK、Java最適化クライアント |
| 認証 | OIDC / Spring Security | ログインとAPI認可。IdP製品は選定事項 |
| クライアント | Flutter / Riverpod / go_router / Dio | 利用者・業者・管理者画面 |
| 最適化 | Python / FastAPI / Pydantic | 内部計算APIと入出力検証 |
| Python開発 | uv / pytest | 依存固定と試験 |
| 実行基盤 | ECS Fargate / ECR | 基幹・最適化のコンテナ実行 |
| 内部通信 | ECS Service Connect | 基幹から最適化へのサービス名による接続 |
| Web配信 | CloudFront / WAF / S3 OAC / ALB | 静的資産とAPIの配信 |
| IaC | Terraform | 環境別のAWS構成管理 |
| CI/CD | CodePipeline / CodeBuild | 検証、成果物保管、手動開始の公開 |
| 監視・秘密 | CloudWatch / Secrets Manager | ログ・メトリクス・秘密管理 |

基幹は同一DBでcommandとqueryのモデルを分ける。JPAによるDDL生成、イベントソーシング、参照専用DBは採用しない。

## バージョンの管理

JDK・Gradle・Spring Boot・jOOQ・PostgreSQLは一組として互換性を検証する。生成時と実行時のjOOQ版を揃え、利用エディションのJDK/DB対応条件を満たす。Gradle Wrapper、toolchain、依存ロックをリポジトリで管理する。

Flutter SDK・Dart・生成器、Python・ソルバー・コンテナベースイメージも固定する。日次CIで依存を自動的に最新版へ置き換えない。更新は専用の変更として生成・ビルド・DB結合・契約試験を通す。

JDKのLTS移行、ソルバー、地図・決済・通知・IdP、macOSランナーの選定条件は[意思決定記録](decisions.md)に集約する。依存ファイルの実値は[実装状況](../process/implementation-status.md)を参照。

[公式互換表・一次資料](../reference/engineering-sources.md)
