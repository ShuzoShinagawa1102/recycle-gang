# 開発・運用方針の入口

- 更新日：2026-10-03（日本時間）
- 根拠：同日の品川との設計合意。業務条件の正は [業務ルール](../business/business-rules.md)。
- 状態：合意済み方針と、レビュー用の具体案を区別して記載。文書が存在することは実装・環境構築・デプロイ完了を意味しない。

## 読む順序

| 文書 | 内容 |
|---|---|
| [システム・リポジトリ境界](system-overview.md) | 3リポジトリ、責務、通信方向、データ所有 |
| [技術スタック案](technology-stack.md) | 現行実装、採用方針、追加候補、バージョン選定条件 |
| [フォルダ・依存方向](repository-layout.md) | 業務モジュール内部のクリーンアーキテクチャ、各アプリの配置 |
| [ドメインモデル案](backend/domain-model.md) | 業務領域、集約候補、未決事項との対応 |
| [API契約・コード生成](backend/api-contract-policy.md) | consumer/backyard/internal、認可、用途別SDK |
| [最適化連携](backend/optimizer-contract.md) | スナップショット、結果採用、予約変更との競合 |
| [DB変更方針](backend/database-change-policy.md) | Flyway、jOOQ、初期データ、メンテナンス、旧新版共存 |
| [試験方針](../process/testing-policy.md) | 保証対象、部分実行、CIの試験範囲 |
| [リリース方針](../process/release-policy.md) | GitFlow、バージョン、互換性、公開状態 |
| [CI/CD方針](../process/ci-cd-policy.md) | イベント条件、日次実行、保存と公開の境界 |
| [デプロイ手順](../process/deployment-runbook.md) | DB、ECS、Web、モバイル、失敗時の対応 |
| [AWS構成案](infrastructure/aws-baseline.md) | 通信経路、Aurora容量、環境、未確定項目 |
| [モバイルビルド・配布案](infrastructure/mobile-delivery.md) | macOS環境、署名、テスト配布、ストア公開 |
| [意思決定・残課題](decisions.md) | 決定と提案の境界、次回レビュー対象 |
| [公式資料](../reference/engineering-sources.md) | 設計・実装時に確認する一次資料 |

## 合意済み

- DDDで業務を整理する。集約境界・状態の詳細は具体的な業務例で検証して育てる。
- Spring Bootを共通基幹サーバーとし、業務モジュールに分けたモジュラーモノリスを構成する。各モジュール内でクリーンアーキテクチャを適用する。
- jOOQで永続化する。DB構造はFlywayのSQLを正とし、DBからjOOQコードを生成する。Javaドメインモデル・DBモデル・API DTOを分ける。
- 更新・参照のモデルを分離する。初期は同じDBを使用する。
- 利用者・バックヤードのFlutterは同じ基幹サーバーを利用する。バックヤードはWebとモバイルを対象とする。
- Python最適化は入力スナップショットから候補を計算し、Spring Bootが検証・採用する。FastAPIを通信窓口にする。
- OpenAPIを用意し、BEのAPI境界とクライアントSDKを生成する。
- AWS ECS、S3、CloudFront、ALB、Aurora Serverless v2を基本とする。Auroraは小さな容量から開始し、上限内で自動スケールする。
- GitFlow、develop/v1、コンポーネント別バージョン、マージでの修正反映を採用する。
- CIは検証と成果物保存、CDは手動開始による公開。develop系・main系は毎日05:00 Asia/TokyoにCI、CDはしない。
- 試験は保証対象別に整理し、業務モジュール単位で部分実行可能にする。

## 今回の成果物の範囲

文書、索引、運用テンプレートと、空の関連リポジトリの入口を整備する。既存のSpring Boot 3.5.16 / Java 22 / Gradle、およびFlutterの依存定義は変更していない。新しいAPI、DB、業務ロジック、CI/CDやAWS資源は未実装。提案バージョンやフォルダは将来の実装先であり、現存することを保証しない。

技術案のレビューは [残課題](decisions.md) の TECH-01以降から行う。既存のQ-01〜Q-09を技術的な都合で確定しない。
