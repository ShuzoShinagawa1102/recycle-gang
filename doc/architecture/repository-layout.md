# フォルダ構成と依存方向の案

更新日：2026-10-03。以下は目標構成。今回、アプリケーション資材の移動や生成は行っていない。

## recycle-gang

| パス | 責務 |
|---|---|
| `flutter/` | 利用者アプリ。既存配置を維持 |
| `backend/` | Spring Boot、Gradle、DB変更資材 |
| `contracts/openapi/` | consumer.yaml、backyard.yaml、必要時internal.yaml、共通components |
| `contracts/generator/` | 生成器の版・設定・契約の取得／bundle手順 |
| `infra/` | AWS IaC。実装時に追加 |
| `ci/` | buildspec、ビルド・検証・公開スクリプト。実装時に追加 |
| `doc/architecture/` | 技術・構造・依存方向 |
| `doc/business/` | 業務ルールの正 |
| `doc/process/` | 試験・開発・リリース・手順 |

## BEのパッケージ

ルートは既存の`com.recyclegang.backend`を維持する。直下に`reservation`、`schedule`、`dispatch`、`collection`、`planning`、`payment`、`partner`等を置く案とする。

`reservation`の例：

| パッケージ | 内容・依存 |
|---|---|
| `reservation` | 他モジュールに公開する少数のfacade・ID・イベント。内部実装を公開しない |
| `reservation.domain` | 集約、値オブジェクト、業務ルール。Spring/jOOQ/API生成物に依存しない |
| `reservation.application` | command/query、ユースケース、トランザクション、port。domainに依存 |
| `reservation.adapter.in.web` | 用途別controller、API DTOからの変換。applicationを呼ぶ |
| `reservation.adapter.out.persistence` | jOOQによるrepository/query実装、domainとの変換 |
| `reservation.adapter.out.integration` | 外部サービス接続。必要なモジュールにだけ配置 |

Spring Modulithの既定検出ではルート直下がモジュール、サブパッケージが内部となる。公開APIを別サブパッケージにする場合はNamedInterface等を明示する。生成コード・起動設定を業務モジュールとして誤検出させないよう、検出設定と境界試験を設ける。

- モジュールAからBのdomain/repositoryへ直接依存しない。Bの公開facade/イベント経由とする。
- 更新側のSQLは所有モジュールが管理する。他モジュールのテーブルを直接更新しない。
- 参照の横断JOINは明示したqueryアダプターで許容できる。読み取り専用とし、依存するテーブルと試験範囲を記録する。必要なら公開projectionへ移行する。
- 同一DB内の必須整合性は同期呼出しとトランザクションを使う。外部HTTPをDBトランザクション中に待たない。
- 外部通知等に再試行・配信保証が必要になればoutbox等を設計する。プロセス内イベントだけで配信保証済みとは扱わない。
- 共通化はID、時刻、エラー等の小さな技術要素に留め、sharedへ業務ロジックを集めない。

## Flutter

| パス例 | 内容 |
|---|---|
| `flutter/lib/app/` | 起動、ルーティング、テーマ、認証状態、環境設定 |
| `flutter/lib/features/<業務>/presentation/` | 画面、widget、Riverpodによる画面状態 |
| `flutter/lib/features/<業務>/application/` | クライアントの操作フロー |
| `flutter/lib/features/<業務>/data/` | SDK呼出しと表示モデルへの変換 |
| `flutter/packages/consumer_api/` | consumer契約から生成するSDK |
| `flutter/test/`、`flutter/integration_test/` | widget・機能・端末試験 |

クライアントに必要な入力検証・表示計算は実装するが、サーバーの業務判定を最終決定として扱う。業者向けと運営向けの画面は権限別に構成する。Webの横幅に合わせた一覧・キーボード操作を別途設計する。

## 関連リポジトリ

- backyard：`flutter/`、`doc/`、`ci/`。生成SDKは`flutter/packages/backyard_api/`。別の業務BEやFlywayは置かない。
- optimizer：`src/recycle_gang_optimizer/`配下に`api/`、`application/`、`domain/`、`adapters/`。`contracts/openapi/optimizer.yaml`、`tests/`、`doc/`、`ci/`。ソルバーとHTTPの依存を計算モデルから切り離す。
- 生成Java/jOOQは`backend/build/generated/`を基本とし直接編集しない。SDKをコミットするかは再生成検証と併せて統一する。初期案は版付き契約と生成設定からCIで生成する。
