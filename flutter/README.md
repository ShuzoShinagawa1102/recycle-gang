# ユーザーアプリ v0.1

[起動手順](../doc/process/local-development.md)を参照。Flutter 3.47.6 / Dart 3.13.5。

- `lib/app/router.dart`：画面遷移。
- `lib/features/`：完成画面と操作。
- `lib/core/providers.dart`：API接続と永続化する下書き。
- `lib/core/mock_api.dart`：Dioの通信層を置き換えるモック。
- `packages/recycle_gang_api/`：OpenAPIから生成したSDK。

`USE_MOCKS` / `API_BASE_URL` は `--dart-define` で切り替える。切替時はアプリを再起動する。通常のFlutter起動にSDK再生成は不要。
