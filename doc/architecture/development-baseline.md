# アーキテクチャと開発方針

Recycle Gangは、Spring Bootの共通基幹、利用者Flutter、業者・管理者向けFlutter、Python経路最適化で構成する。開発の基準ブランチは3リポジトリとも`develop/v1`とする。

## 設計の軸

- **業務の正は基幹に置く。** 予約・募集・割当・回収・支払・採用済み経路を一元管理する。
- **業務モジュールで分け、内側をクリーンアーキテクチャにする。** ドメインをHTTP・SQL・画面から独立させる。
- **DB構造の正はFlyway SQL。** DBからjOOQを生成し、ドメインモデルと明示的に変換する。
- **用途別のOpenAPIを契約にする。** 利用者、業者、管理者、最適化で公開範囲と生成SDKを分ける。
- **最適化は候補計算。** 基幹が入力を固定して渡し、変更検知と候補採用を担う。
- **CIは検証・保存、CDは手動開始による公開。** 検証した不変成果物を指定して配布する。

## 設計資料

| 読む順序 | 内容 |
|---|---|
| [システム構成](system-overview.md) | リポジトリ、データ所有、依存方向 |
| [技術スタック](technology-stack.md) | 言語、フレームワーク、生成・試験基盤 |
| [フォルダ構成](repository-layout.md) | 3リポジトリのツリーとモジュール境界 |
| [ドメインモデル](backend/domain-model.md) | 業務領域、集約、ER形式の関係図 |
| [API契約](backend/api-contract-policy.md) | consumer / backyard / admin / optimizer |
| [最適化API](backend/optimizer-contract.md) | 内部REST、ジョブ、予約変更との競合 |
| [DB変更](backend/database-change-policy.md) | Flyway、初期データ、メンテナンス、旧新版共存 |
| [画面と権限](ui/application-boundaries.md) | 利用者・業者・管理者の役割 |
| [AWS構成](infrastructure/aws-baseline.md) | 配信、2AZネットワーク、ECS、Aurora |
| [提出図のレビュー](infrastructure/diagram-review-2026-10-03.md) | drawioの修正箇所と理由 |
| [モバイル配布](infrastructure/mobile-delivery.md) | ビルド、署名、テスト配布、審査、公開 |
| [試験](../process/testing-policy.md) | 保証対象と業務モジュール別の部分実行 |
| [リリース](../process/release-policy.md) | GitFlow、版、互換性、公開状態 |
| [CI/CD](../process/ci-cd-policy.md) | Push / PR / 日次の条件と権限 |
| [デプロイ手順](../process/deployment-runbook.md) | DB・ECS・Web・モバイルの公開と復旧 |

設計上の決定と選定事項は[意思決定記録](decisions.md)、コードへの反映状況は[実装状況](../process/implementation-status.md)で管理する。業務条件の正は[業務ルール](../business/business-rules.md)。
