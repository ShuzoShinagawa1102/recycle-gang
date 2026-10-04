# API契約 v0.1

- `openapi/consumer.yaml`：ユーザーアプリ用。`/api/consumer/v1`。
- `openapi/backyard.yaml`：施設の入場受付用。`/api/backyard/v1`。
- `openapi/shared.yaml`：共通データ型。YAMLのサブセットであるJSON構文で記述する。
- `openapi/bundled.yaml`：上記を結合したSpring生成用ファイル。直接編集しない。

```sh
python scripts/generate-contracts.py
```

OpenAPI Generator 7.15.0をSHA-256で固定する。Springインターフェース・DTOとDart Dio SDKを生成し、生成物もコミットする。通常の起動に再生成は不要。

`templates/dart/` はGeneratorのDart `json_serializable` 出力に対する2点の修正を保持する。multipartのFormDataを構築することと、Dart SDKの下限を3.13.4に合わせること。生成されたAPIクラスを手修正しない。写真の送受信をSDK経由の試験で保証する。

認証・所有者・施設の検証はサーバーの責務。タグや仕様ファイルの分離は認可の代替にしない。localプロファイルのデモトークンは本番認証に使わない。
