# アーキテクチャの意思決定

業務上の成立条件・料金・期限は[業務の意思決定](../business/decisions.md)で管理する。ここではシステム構造と運用の判断を定義する。

## 決定

| ID | 決定 | 理由 |
|---|---|---|
| ARC-01 | DDD、モジュラーモノリス、モジュール内クリーンアーキテクチャ | 業務ルールを実装技術から分離 |
| ARC-02 | 利用者・業者・管理者は共通基幹BEを利用 | 予約・割当・実績の正を一元化 |
| ARC-03 | Flyway SQL → DB → jOOQ。ドメイン/API/DBモデルを分離 | DBとクラスの1対1対応を強制しない |
| ARC-04 | 同じDBでcommandとqueryを分離 | 更新整合性とクライアント別表示を両立 |
| ARC-05 | consumer / backyard / admin / optimizerのOpenAPI | 用途別の公開範囲・SDK・認可を明確化 |
| ARC-06 | 基幹が入力を固定しPythonが候補計算 | 予約変更を検知し、採用を基幹で確定 |
| ARC-07 | Service Connect内部REST。基幹の永続ジョブとステートレスoptimizer | 画面待ち・再起動復旧・計算負荷を分離 |
| ARC-08 | 管理者Webをbackyardの独立featureに配置 | 同じ業務基盤で管理操作を提供 |
| INF-01 | 東京、2AZ subnet、private ECS/Aurora、NAT経由の外向き通信 | 公開入口と内部通信を分離 |
| INF-02 | 全クライアントのAPIをCloudFront → ALBへ統一 | WAF適用とorigin保護を統一 |
| INF-03 | native ECS rolling、CodeDeployを使わない | Service Connectと整合する単純な更新方式 |
| OPS-01 | 全repoの基準はdevelop/v1。GitFlow、mergeで修正反映 | 系列と公開履歴を管理 |
| OPS-02 | コンポーネント独立版、互換性と公開状態を別記録 | 全アプリ同時更新を要求しない |
| OPS-03 | CIは検証/保存、CDは手動開始/自動実行 | 検証した不変成果物を公開 |
| OPS-04 | 指定Push/PR条件、05:00 JSTにdevelop/mainの日次CI | マージ後と定期の回帰確認 |
| OPS-05 | expand/contract、専用単一migration job | 旧新ECSタスク共存とDB変更を両立 |
| QA-01 | 保証対象別試験と業務モジュール別の部分実行 | 必要な範囲を独立して検証 |
| TECH-01 | JDK 21 LTS / Gradle 8.14.3 / Boot 3.5.16 / jOOQ 3.19.33 | v0.1でコンパイル、業務試験、SQL・API疎通を検証 |

## 選定・数値確定が必要な事項

| ID | 項目 | 決める条件 |
|---|---|---|
| TECH-02 | Aurora PostgreSQLのエンジン版 | 東京の対応、JDBC/Flyway/jOOQ、dev auto-pause条件 |
| TECH-03 | iOSのmacOSランナー | hosted macOSとCodeBuild Macの費用、頻度、署名、CodePipeline連携 |
| TECH-04 | IdPとWebセッション管理 | PKCE、管理者MFA、ログアウト、token/cookie保持 |
| TECH-05 | ソルバーと移動行列提供元 | OR-Toolsを起点に制約・時間上限・ライセンス・費用を検証 |
| TECH-06 | 決済・通知の提供元 | 業務フロー、sandbox、再送、費用 |
| TECH-07 | モバイル旧版の対応期間 | 更新率、API維持費、最低版引上げ手順 |
| TECH-08 | RTO/RPOと冗長化拡張 | writer/reader、ECSタスク、NATの停止影響・復元実測・予算 |
| TECH-09 | AWSアカウント・ドメイン・リソース識別子 | dev/prodの配置と運用権限 |

## 開発単位

1. 画面から利用者の目的を定義し、関係する業務条件を確定する。v0.1の持込・予約は[ユースケース](../business/use-cases-v0.1.md)を適用する。
2. 依存の版、Wrapper、モジュール境界、OpenAPI生成を設定する。
3. 予約をドメイン → Flyway → jOOQ → API → Flutterまで接続し、試験する。
4. CIのトリガー、対象SHA、日次、成果物保管を構築する。
5. AWSのdevを構築し、DB変更・ECS/Web公開・復旧を通す。
6. 管理者画面、最適化ジョブ、モバイル署名・配布を接続する。
7. 本番識別子、復元結果、公開記録を揃えて本番運用を開始する。

実装の進捗は[実装状況](../process/implementation-status.md)を更新する。
