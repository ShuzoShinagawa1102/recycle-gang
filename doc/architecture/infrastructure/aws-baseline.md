# AWS構成のたたき台

更新日：2026-10-03。ECS/S3/CloudFront/ALB/Aurora Serverless v2の採用は合意済み。drawio、アカウント、リージョン、構築資材は未確定。

## 通信経路

| 対象 | 経路・責務 |
|---|---|
| Web静的配信 | ブラウザ → CloudFront → OACで制限した非公開S3 |
| 基幹API | モバイル/Web → API用ALB → private subnetのSpring Boot ECS |
| 同一オリジン案 | CloudFrontの`/api/*`をALBへ、静的コンテンツをS3へ振り分け |
| 最適化 | Spring Boot → privateなサービス検出/内部LB → optimizer ECS |
| DB | Spring Boot → private Aurora。optimizer/Flutterから直接接続しない |
| 外部通信 | 決済、通知、地図等。NAT/VPC endpointの必要範囲と費用はdrawioで決定 |

CloudFrontのbehaviorがS3/ALBを選び、ALBがECS targetへ流す。認証済みAPIレスポンスは原則キャッシュしない。Cookie/Authorization/クエリの転送、CORS、TLS、APIエラーがSPAのindexへ書き換わらないことを確認する。

初期案はFargate。基幹とoptimizerのCPU負荷を分離する。長時間の最適化計算はワーカー/タスクとして隔離し、HTTPサービスのヘルスチェックを阻害させない。

## 環境

devとprodはDB、S3公開先、ECS、秘密情報、IAM、ログを分ける。可能ならAWSアカウントも分離する。リリース候補検証は一時環境または明示した検証枠を用意し、devの任意更新で結果が変わらないよう版を固定する。

CI保管S3は公開S3と別。ECR/S3の成果物保存とECS/CloudFrontの公開切替は別権限。インフラもIaCでレビューし、コンソール変更は例外として後から資材に反映する。

## Auroraの初期容量案

PostgreSQL互換を第一案とする。正確なエンジン版はリージョンの対応、Flyway/jOOQ/JDBC、auto-pause対応を確認して固定する。

| 環境 | MinCapacity案 | MaxCapacity案 | 方針 |
|---|---|---|---|
| dev | 対応構成なら0 ACU、そうでなければ対応する最小値 | 2 ACU | 低負荷優先。auto-pause時の再開待ちを許容 |
| prod | 0.5 ACUを起点に負荷検証 | 4 ACU | 初期はauto-pauseを使わず、応答待ちを避ける |

数値はレビュー用の初期案で、性能保証・費用上限保証ではない。接続数、作業メモリ、起動/移行処理、実測レイテンシにより最小値を上げる。上限値までしかスケールしないため、最大付近の継続・接続枯渇・遅延を監視する。ECS側の同時接続数とDBプールも合わせて制限する。

auto-pauseは対応バージョン・機能・接続状態に依存する。常時接続が残れば停止しない場合がある。ストレージ等の料金がなくなるわけではない。AWS Budgetsは監視用で、即時の利用制限や課金上限として扱わない。

## 可用性とバックアップの案

最小コスト案ではwriter 1台から評価する。これはreader追加構成と同じフェイルオーバー時間を保証しない。本番のRTO/RPO・許容停止時間を定め、reader/ECS複数タスクの必要性を決める。Auroraのストレージ冗長化とDBインスタンスの冗長化を混同しない。

自動バックアップ保持はdev 1日/prod 7日を初期案とし、削除保護、最終snapshot、PITR復元の手順を設ける。重要データを持つ本番開始前に復元試験を行う。容量、バックアップ、可用性はユーザーの最小構成の希望と停止許容を両立させて確定する。

## drawioで確定する項目

リージョン/AZ、VPC/subnet、ALB/CloudFrontの関係、ドメイン/TLS、SG、NAT/endpoint、外部接続、IdP、ECS数/容量、Auroraエンジン/容量/reader、ログ/バックアップ、CI/CDアクセス経路。現段階ではAWSリソース名/ARN/IDを仮に実在するものとして記載しない。

公式資料：[Aurora Serverless v2](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2.html)、[auto-pause](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2-auto-pause.html)、[ECS rolling](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/deployment-type-ecs.html)。
