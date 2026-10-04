# Recycle Gang

Recycle Gang のアプリケーション・バックエンド・設計資料を管理するリポジトリです。

## 設計・運用ドキュメント

- [開発・運用方針の入口](doc/architecture/development-baseline.md)：システム構成、設計の軸、読む順序。
- [業務要件](doc/business/index.md)：業務ルールの正と未決事項。
- [アーキテクチャ](doc/architecture/index.md)：DDD、API、DB、AWS構成。
- [開発プロセス](doc/process/index.md)：試験、GitFlow、CI/CD、リリース手順。
- [バックヤード](https://github.com/ShuzoShinagawa1102/recycle-gang-backyard)：業者Web/モバイル・管理者Web。
- [最適化](https://github.com/ShuzoShinagawa1102/recycle-gang-optimizer)：Python/FastAPIの計算サービス。

開発の基準ブランチは`develop/v1`です。[設計と実装の対応](doc/process/implementation-status.md)を分けて管理します。以下の実行手順は既存コードに対応します。

## Repository structure

```text
.
├── flutter/   # Flutter application
├── backend/   # Spring Boot backend
├── doc/       # Architecture, business requirements, process, references, notes
└── README.md
```

## Flutter

```bash
cd flutter
flutter pub get
flutter run
```

## Backend

Requirements:

- Java 22
- Gradle

Run:

```bash
cd backend
gradle bootRun
```
