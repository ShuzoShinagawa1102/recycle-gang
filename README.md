# Recycle Gang

Recycle Gang のアプリケーション・バックエンド・設計資料を管理するリポジトリです。

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
