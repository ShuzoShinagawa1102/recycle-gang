# モバイルのビルド・配布基盤案

更新日：2026-10-03。FlutterモバイルもCI/CD対象。CI実行サービスの選定は提案で、未構築。

## ECSをCI用に用意するか

通常は不要。Android/Web/Java/PythonはCodeBuild等のビルド環境を使う。iOS配布ビルドにはmacOS＋Xcodeが必要で、一般的なLinux ECS/Fargateでは代替できない。

| 選択肢 | 長所 | 条件・負担 | 初期判断 |
|---|---|---|---|
| CodeBuild macOS reserved fleet | AWSのビルド運用へ揃えやすい | 対応リージョン/実行環境、最低24時間の利用課金等を確認 | AWS統一を優先する場合 |
| GitHub Actions hosted macOS | 自前Macの保守が不要、低頻度の初期開発に合わせやすい | CodePipelineとの連携・資格情報・結果照合が必要 | コストを抑える第一提案 |
| 自前Mac/EC2 Mac runner | 環境を細かく制御できる | 保守・更新・隔離・費用管理が必要 | 初期では優先しない |

CodePipelineを全体の起点とする方針は維持する。Actionsを選ぶ場合は、CodePipeline側の連携アダプターからworkflow_dispatchで固定SHA/ビルドID/環境を渡し、同じSHAの結果・成果物ハッシュ・実行IDを照合して完了させる案。単純に別のPushトリガーを足して二重ビルドしない。これは組込み済みの標準機能としてではなく、実装・検証が必要な連携案として扱う。

macOS/Xcode/Flutter/CocoaPods等の版を固定し、更新PRで確認する。iOSのランナーが決まるまで、iOS試験・署名ビルド済みと表示しない。

## 配布までの境界

| 処理 | 自動化の範囲 | 人が指定する境界 |
|---|---|---|
| CI | analyze、test、SDK生成、署名可能な信頼済みrevisionのビルド、成果物保管 | 署名鍵を扱うジョブ/権限を分離 |
| 開発配布CD | 選択済み版をTestFlight/Play内部テスト等へアップロード | 環境・版・対象トラックを選んで開始 |
| 本番提出CD | 選択済み本番成果物を提出、審査状態を記録 | 本番提出を手動開始 |
| 公開 | 審査通過版を公開/段階配布、公開状態を記録 | ストアの手動公開設定で公開を選択 |

配布操作はスクリプト化するが、毎Pushで公開する設計ではない。fastlaneを配布自動化の候補とする。ストアの初回登録、契約同意、商品情報、スクリーンショット、プライバシー申告等は別途準備する。機械的なビルド成功だけでは審査通過を保証しない。

## 環境・署名・版

- consumer/backyardを別アプリIDとして管理し、さらにdev/prodのflavorと接続先を分ける案。識別子の実値は未決。
- dev用バイナリをそのままprodへ昇格しない。本番用flavor/署名/設定で作った成果物をテスト配布し、同じビルドを本番へ昇格させる。
- iOSのversion/build number、AndroidのversionName/versionCode、Git SHA、設定ハッシュ、契約版を対応づける。
- 署名証明書、provisioning profile、keystore、ストアAPI資格情報は安全な保管先から取得し、PR実行へ渡さない。
- 依存や署名で再ビルドが必要なら別ビルド番号・別成果物として再検証する。
- 利用者端末の更新は強制的に同時完了できない。公開直後も旧版BE互換性を維持する。

## 公式資料

- [Flutter iOS build/release](https://docs.flutter.dev/deployment/ios)
- [Flutter Android build/release](https://docs.flutter.dev/deployment/android)
- [Flutter continuous delivery](https://docs.flutter.dev/deployment/cd)
- [CodeBuild実行環境](https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html)
- [CodeBuild料金・Mac最低利用期間](https://aws.amazon.com/codebuild/pricing/)
- [GitHub hosted runners](https://docs.github.com/en/actions/reference/runners/github-hosted-runners)

料金・対応リージョン・Xcode要件・ストア要件は採用/提出時に再確認する。
