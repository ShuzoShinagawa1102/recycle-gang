# API契約・生成・認可

提供側がOpenAPIを所有し、クライアントの利用目的ごとに契約を分ける。基幹の契約は同じSpring Bootアプリケーションから提供する。

## 契約の分割

| 契約 | 所有リポジトリ | 利用者 | パス |
|---|---|---|---|
| consumer.yaml | recycle-gang | 利用者Flutter | `/api/consumer/v1/...` |
| backyard.yaml | recycle-gang | 業者Flutter Web/モバイル | `/api/backyard/v1/...` |
| admin.yaml | recycle-gang | 管理者Flutter Web | `/api/admin/v1/...` |
| optimizer.yaml | recycle-gang-optimizer | 基幹の計算ワーカー | `/v1/route-optimizations`、内部限定 |

基幹の契約は`contracts/openapi/`に配置する。エラー・ページング等は`components/`へ共通化する。共通定義は独立した「共通API」にしない。tagsはReservations、Offers、RoutePlans等の業務分類に使う。

optimizerは入力を受け取るため、基幹から業務データを取りに来るinternal APIを設けない。別のM2Mユースケースを追加するときは、その目的と公開項目を定義して`internal.yaml`を追加する。

用途別YAML・タグ・URLは契約の整理方法であり、認可はサーバーで実施する。

## コード生成

| 契約 | 生成物 | 手書き実装 |
|---|---|---|
| consumer / backyard / admin | Spring API interfaceとDTO、各Dart Dio SDK | Controller、ユースケース、ドメイン、認可、画面 |
| optimizer | 基幹のJava HTTPクライアント | FastAPIハンドラー、Pydantic DTO、計算処理 |

FastAPIのPydantic DTOは正のYAMLに照合する契約試験を必須とする。FastAPIが出力するOpenAPIで設計契約を上書きしない。生成DTO・jOOQ Record・Javaドメインは別モデルとして変換する。

契約はbundleし、版・コミット・ハッシュ付き成果物にする。利用側は取得版と生成器設定を固定し、提供側YAMLのコピーを独立編集しない。`operationId`は安定させ、共通schemasと生成名の衝突を防ぐ。

## 認証と認可

| 主体 | 許可範囲 |
|---|---|
| 利用者 | 自分の予約・回収状況・支払情報 |
| 業者 | 所属業者に提示された募集、担当作業、許可された実績・SOS |
| 管理者 | 付与された操作権限に対応する運行・募集・割当・経路採用・照会 |
| 基幹サービス | 内部の最適化計算要求 |

IDを受け取る操作には対象オブジェクトの所有・所属・操作権限を適用する。一覧SQLにも同じ絞込みを適用する。管理者ロールを持つだけで無条件に全操作を許可しない。監査ログはactor、action、対象ID、時刻、requestId、操作理由を持つ。

人のログインはOIDC Authorization Code＋PKCEを使い、公開クライアントへclient secretを置かない。IdP、Webのセッション保持方式は[選定事項](../decisions.md)。サービス間の認証は[最適化API](optimizer-contract.md)に定義する。

## 契約の品質

エラー形式、入力制約、時刻とタイムゾーン、金額・数量の単位、ページング、冪等性、競合時の応答を明記する。金額の確定処理を浮動小数の丸めに任せない。

CIで構文、bundle、破壊的差分、生成・コンパイル、実装との契約を検証する。enum値追加も旧SDKへの影響を調べる。DB変更はAPI契約の自動変更を意味しない。

接続先は環境別の安定URLとAPI系列`v1`。サーバー実装版専用のURLにはしない。互換性と公開状態は[リリース記録](../../process/release-policy.md)で追跡する。

公式資料：[OpenAPI 3.0.3](https://spec.openapis.org/oas/v3.0.3)、[Spring生成器](https://openapi-generator.tech/docs/generators/spring/)、[Dart生成器](https://openapi-generator.tech/docs/generators/dart-dio/)。
