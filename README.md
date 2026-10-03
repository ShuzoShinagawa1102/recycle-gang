# Recycle Gang

Recycle Gang のアプリケーション・バックエンド・設計資料を管理するリポジトリです。

## 設計・運用ドキュメント

- [開発・運用方針の入口](doc/architecture/development-baseline.md)：2026-10-03の合意内容、技術案、読む順序。
- [業務要件](doc/business/index.md)：業務ルールの正と未決事項。
- [アーキテクチャ](doc/architecture/index.md)：DDD、API、DB、構成案。
- [開発プロセス](doc/process/index.md)：試験、GitFlow、CI/CD、リリース手順。
- [バックヤード](https://github.com/ShuzoShinagawa1102/recycle-gang-backyard)：業者・運営Flutter。
- [最適化](https://github.com/ShuzoShinagawa1102/recycle-gang-optimizer)：Python/FastAPIの計算サービス。

文書は合意済み方針とレビュー用提案を区別しています。新しい業務BE・API・DB・CI/CD・AWS構成は未実装です。以下の実行要件は現在の資材に対応します。LTS化等の提案は[技術スタック案](doc/architecture/technology-stack.md)を参照してください。

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
