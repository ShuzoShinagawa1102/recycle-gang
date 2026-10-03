# API契約・生成・認可の方針

更新日：2026-10-03。用途別契約と生成方針は合意済み。具体的なエンドポイント・フィールドは別途設計する。

## 提供側が契約を所有する

| 契約の予定パス | 所有リポジトリ | 利用者・用途 |
|---|---|---|
| `contracts/openapi/consumer.yaml` | recycle-gang | 利用者Flutter、`/api/consumer/v1/...` |
| `contracts/openapi/backyard.yaml` | recycle-gang | 業者・運営Flutter、`/api/backyard/v1/...` |
| `contracts/openapi/internal.yaml` | recycle-gang | 必要な場合だけ追加するM2M、`/api/internal/v1/...` |
| `contracts/openapi/components/*.yaml` | recycle-gang | エラー・ページング等の共通定義。単独APIにしない |
| `contracts/openapi/optimizer.yaml` | recycle-gang-optimizer | Spring Bootから呼ぶ最適化サービスのAPI |

YAMLファイル分割は提供プロセスの分割を意味しない。タグはReservations/Offers/Collections等の業務分類。タグ、パス、YAMLの非公開化だけを認可の代わりにしない。

各契約をbundleし、版・コミット・ハッシュ付き成果物として提供する。利用側は特定版を取得し、mainの最新を毎回自動取得しない。`operationId`は安定させ、生成名の衝突を避ける。

## 生成境界

| 入力 | 出力 | 独自実装 |
|---|---|---|
| 基幹OpenAPI | Spring API interface、入出力DTO | Controller実装、ユースケース、ドメイン、認可 |
| consumer/backyard契約 | Dart SDK（dart-dio候補） | 表示モデル、Riverpod、画面 |
| optimizer契約 | Spring側HTTPクライアント、必要なPython入出力型 | 計算処理、ジョブ管理、HTTP実装 |

FastAPIも契約先行を初期案とする。生成器でPydantic型を作るか、手書き型を契約試験で検証するかは生成PoCで決める。FastAPIの自動OpenAPIは実装の出力であり、正のYAMLを自動的に上書きしない。Python FastAPIサーバー全体の生成は必須にしない。

生成物は直接編集しない。Spring API DTO→アプリケーションcommand/query→ドメインへ変換する。jOOQ RecordはAPIへ返さない。common DTOを共用するのは意味と公開範囲が一致する場合だけ。

## 認証・公開範囲

- 利用者は自分の予約、業者は所属業者が扱える募集・担当回収、運営は付与された運営権限の範囲を操作する。
- IDを受け取るすべての操作で、対象オブジェクトへの権限を確認する。一覧SQLにも所属・所有条件を付ける。
- クライアントのボタン非表示は補助。BEの認可を正とする。
- M2Mは専用のサービス識別と権限。ユーザーのログイントークンの使い回しを前提にしない。
- internal/optimizerは内部経路を基本とし、サービス認証も実装する。クライアントからoptimizerを直接呼ばせない。
- WebはOIDC Authorization Code＋PKCE等を候補とする。モバイル/ブラウザにclient secretを埋め込まない。IdP・cookie/token保持方式は未決。

## 契約の品質

エラー形式、入力制約、日付/時刻・タイムゾーン、金額の単位、ページング、冪等性キー、競合時の応答を明記する。料金等の確定数値を浮動小数の丸めに任せない。

CIで構文検証、bundle、破壊的差分、各言語生成、コンパイル、実装との契約試験を行う。enum値の追加も古いSDKのデシリアライズを壊し得るため、単なる追加として無条件に互換扱いしない。DB変更だけでAPI契約を自動変更しない。

アプリは環境別の安定したAPI URL＋契約系列`v1`に接続する。`backend-v1.0.1`という実装版専用のURLに固定する設計ではない。対応関係は [リリース方針](../../process/release-policy.md) を参照。

公式資料：[OpenAPI](https://spec.openapis.org/oas/v3.0.3)、[Spring生成器](https://openapi-generator.tech/docs/generators/spring/)、[Dart生成器](https://openapi-generator.tech/docs/generators/dart-dio/)。
