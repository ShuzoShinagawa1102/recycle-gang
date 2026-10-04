# CI/CD方針

更新日：2026-10-03。基準ブランチは`develop/v1`。

## 起動条件

PR列は宛先ブランチを示す。作成・更新で起動し、再オープンも同じ検証を行う。

| ブランチ | Push CI | そのブランチ宛PR CI | 日次CI | 自動CD |
|---|---|---|---|---|
| feature/* | なし | なし | なし | なし |
| develop/* | あり | あり | 毎日05:00 Asia/Tokyo | なし |
| main | あり | なし | 毎日05:00 Asia/Tokyo | なし |
| release/* | あり | あり | なし | なし |
| hotfix/* | あり | なし | なし | なし |

feature/foo→develop/v1は、PR前のfeature PushではCIしない。PR作成後の追加PushはPR更新としてCIする。マージ後は宛先PushでCIする。PR closeイベントを別途起動して同じマージを二重検証しない。

提案HEADを検証し、可能なら宛先との仮マージも検証する。宛先が進んだ場合は古い結果を合格条件に使わない。マージ後CIは必須。main向けPRを省略する代わりに、最終mainコミットの成功を本番CD条件にする。

CodePipeline V2＋CodeConnectionsを起点に、CodeBuildで試験・生成・ビルドを実行する。PRの宛先フィルター、実行対象revision、GitHubチェックへの結果反映を結合検証する。プロバイダー依存のイベント差を確認する。[公式フィルター資料](https://docs.aws.amazon.com/codepipeline/latest/userguide/pipelines-filter.html)を参照。

## コンポーネントと実行範囲

recycle-gang内はbackend/Flutterを変更パスで選べるが、OpenAPI・共通資材変更は依存先も対象にする。日次は変更パスにかかわらず全体を回す。文書だけの変更はリンク/構文等の文書CIへ絞り、成功をアプリビルド成功と混同しない。関連repoの契約利用版を記録し、SDK更新は独立した変更として検証する。

PR実行には本番秘密情報、署名鍵、公開先更新権限を渡さない。PR成果物はデプロイ可能候補として採用しない。保護されたマージ後revisionを信頼できるビルド設定で検証する。

## 日次実行

EventBridge Schedulerで`cron(0 5 * * ? *)`、timezone `Asia/Tokyo`、flexible window無効をとする。05:00開始要求であり秒単位の開始保証ではない。UTC運用なら前日20:00に相当する。

対象は稼働中のdevelop系列とmain。開始時のコミットを固定し、ブランチ名だけを渡して後から別コミットへずれないようにする。手動/定期開始でCodePipelineの既定ブランチが使われる挙動に注意し、パイプライン分割またはsource revisionの明示で対象を保証する。

本番回帰は [リリース記録](release-policy.md) の公開中タグ/成果物も使う。main最新＝本番稼働版とみなさない。日次はCD、ストア提出、公開成果物上書きを行わない。試験レポートは保管する。

## CIとCDの境界

| フェーズ | 許可する処理 | 更新しないもの |
|---|---|---|
| PR CI | 検証・レポート | 公開環境、署名済み正式成果物 |
| マージ後CI | 検証、ECRへの版付き保存、非公開S3へのWeb保存、信頼された配布ビルド | ECSサービス、公開S3、ストア公開 |
| 手動CD | 選択成果物を開発/本番/テスト配布先へ反映 | 別revisionの暗黙取得・再ビルド |

CI保管S3とCloudFront公開S3を分ける。ECRはGit SHA等の不変タグ＋digest、Webは不変の版別保管先＋チェックサムを使う。成果物を作るCIと、その成果物を公開するCDのロールを分ける。

CDは人が環境・コンポーネント・成果物IDを指定して開始し、その後の処理は自動化する。開発はdevelop/releaseの成功成果物、本番は正式タグと成功記録のある成果物に制限する。同一環境/同一DBのCDを直列化する。CIは古いPR実行をキャンセル可能だが、途中のDB移行/CDを無条件にキャンセルしない。

## 追加の実装条件

- main Pushとタグによる同一ビルドの二重起動を防ぐ。原則Pushでビルド、タグで該当成果物を選択・登録する。必要時のみ明示再ビルド。
- 日次はテスト専用の識別子を使い、正式候補のdigest/配布番号を置き換えない。
- ビルドの重複排除キーはSHAだけでなく、コンポーネント・環境/設定・ツール版を含める。
- GitHub/AWS連携認証は短期資格情報等を使う。機密値はログや公開リポジトリに出さない。
- 依存ツールを固定し、日次で勝手に更新しない。
- iOSのmacOS実行は [モバイル配布](../architecture/infrastructure/mobile-delivery.md) に従う。

公式資料：[CodePipeline trigger](https://docs.aws.amazon.com/codepipeline/latest/userguide/pipelines-triggers.html)、[Scheduler](https://docs.aws.amazon.com/scheduler/latest/UserGuide/schedule-types.html)。
