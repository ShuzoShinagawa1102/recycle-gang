# Recycle Gang v0.1

ユーザー向けFlutterアプリとSpring Boot API。開発ブランチは `develop/v1`。

## まず画面を動かす

Flutter 3.47.6を使用する。モックは端末内に保存され、サーバーなしで予約・QR・写真・持込完了を操作できる。

```sh
cd flutter
flutter pub get
flutter run -d chrome --web-port=7357 --dart-define=USE_MOCKS=true
```

## 実APIで動かす

DBだけをWSL2のDockerで起動し、バックエンドとFlutterはWindows側で動かす。

WSLのリポジトリルート：

```sh
docker compose up -d --wait
```

Windows PowerShell（JDK 21）：

```powershell
cd backend
.\gradlew.bat bootRun --args="--spring.profiles.active=local"
```

別のPowerShell：

```powershell
cd flutter
flutter pub get
flutter run -d chrome --web-port=7357 --dart-define=USE_MOCKS=false --dart-define=API_BASE_URL=http://localhost:8080
```

施設受付：<http://localhost:8080/local/manager.html>。今日・東エリアの持込予約を作成し、ユーザー画面のQRを読み取るか、コードを貼り付けて入場を記録する。その後、ユーザー画面で写真を登録して「捨てました！」を押す。

[初回セットアップ・Android/iOS・試験・停止コマンド](doc/process/local-development.md)

## 実装の入口

| 定義 | 正となるファイル |
|---|---|
| 画面遷移 | [drawio](doc/architecture/ui/recycle-gang-ui-prototype.drawio)、`flutter/lib/app/router.dart` |
| 業務と状態遷移 | [ユースケース v0.1](doc/business/use-cases-v0.1.md)、`backend/.../reservation/domain/` |
| 統合モデル | [ドメインモデル](doc/architecture/backend/domain-model.md) |
| API契約・再生成 | [contracts](contracts/README.md) |
| DB | `backend/src/main/resources/db/migration/` |
| 構成・技術 | [フォルダ構成](doc/architecture/repository-layout.md)、[技術スタック](doc/architecture/technology-stack.md) |
| 実装と検証 | [v0.1の実装範囲](doc/process/implementation-status.md) |

施設・日時枠・金額はテストデータ。決済はテスト決済、認証はlocalプロファイル専用のデモ認証である。

AWS、バックヤード本体、経路最適化の設計は[開発方針](doc/architecture/development-baseline.md)を参照。
