# デプロイ手順のたたき台

更新日：2026-10-03。手動開始→自動実行の運用設計。AWS/ストア環境は未構築であり、この文書だけで現在実行可能ではない。公式リンクは手順の根拠で、プロジェクト固有の設定の代わりにはしない。

## 実行可能にするための登録事項

環境ごとにAWSアカウント/リージョン、CDパイプライン、ECS cluster/service/task definition、移行task、DB接続先と権限、S3/CloudFront、ヘルス確認先、復旧先、通知先を登録する。モバイルはアプリID/flavor、署名方式、配布トラック、storeの手動公開設定を登録する。秘密値は記載せず参照先を使う。

未記入のまま本番CDを開始しない。初回はdevで公開・失敗・復旧を通し、実際の画面/コマンドと確認結果をこの手順へ追記する。通常リリース、DB変更、Web、iOS、Androidの所要時間も記録する。

## 共通フロー

1. releaseブランチの対象コンポーネント、変更内容、互換性、DB移行、既存データへの影響を確定する。
2. mainへマージし、最終SHAのCIを成功させる。対応するコンポーネントタグを付ける。Push/タグの重複ビルドは排除する。
3. [リリース記録](templates/release-record.yaml)へ成果物digest/checksum、設定、契約、試験結果を記録する。
4. 公開候補を検証環境/本番用テスト配布で確認する。mainの新ビルドとreleaseの旧ビルドを取り違えない。
5. 人がCDを開始し、環境・コンポーネント・成果物IDを選択する。パイプラインが正式タグ、CI結果、ハッシュ、環境設定、互換性を検証する。
6. 同じ環境のCDを排他し、現在稼働版と復旧先を記録する。
7. 下記の対象別手順を実行する。失敗時は後続公開を止め、変更済み範囲を確認する。
8. 成功後のヘルス/主要業務/メトリクスを確認し、実行者・時刻・版・結果を記録する。
9. release/hotfix修正をdevelop/v1へマージする。タグを動かさない。

devはdevelop/releaseの特定成功成果物を選べる。本番は正式タグ由来のみ。ユーザーの手動CD方針は、個々のコマンドを人が入力することを意味しない。

## DB変更を含む場合

1. 移行前版・適用予定SQL・バックアップ/PITR・復旧手順を照合する。
2. 必要なexpand migrationを専用単一ジョブで実行し、終了コードとFlyway履歴を確認する。
3. backfillが必要なら対象件数・再開位置・変換結果を確認する。完了条件を満たすまで依存するアプリ切替を進めない。
4. 旧タスクが新DBで動くことを確認してアプリ更新へ進む。
5. contract（列削除等）は互換期間終了後の別リリースにする。

移行失敗時は後続アプリ更新を停止する。非トランザクションDDL等の部分適用を調べ、無条件に再実行/repairしない。DBを戻す必要がある場合は、更新データの損失と停止時間を含めて復旧計画を実行する。

## ECS：Spring Boot / optimizer

1. 選択したECR digest、設定、秘密参照、契約互換性を検証する。
2. digestを指定した新task definition revisionを登録し、対象serviceを更新する。
3. rolling更新を監視し、旧新共存中のエラー・ALB health・タスク再起動・DB接続を確認する。
4. service stableだけでなく、主要API/業務smokeを確認する。
5. 失敗時は互換DB上で直前のtask definitionへ戻す。起動失敗検知・ロールバック機構はIaC実装時に設定して試験する。

optimizerとBEは互換な契約で段階更新する。非互換な場合は新旧API並行提供等を計画する。進行中ジョブを失わない停止/再開条件も確認する。

## Flutter Web

出力は`flutter build web`の`build/web`。CIでは非公開保管S3の版別領域へzip等で保存する。

初期案はCloudFront distribution/公開S3を固定し、指定成果物を公開先へ反映する。通常リリースでdistributionの向き先を手で変更することを必須にしない。

1. 保存成果物のchecksum、API接続設定、base path、配信ヘッダーを検証する。
2. 現行版を版付き成果物として保持し、新しい資産を先に配置、入口HTML/起動ファイルを最後に反映する。
3. 入口や同名更新ファイルのcache policy/Cache-Controlを設定し、必要なCloudFront invalidationを実行して完了を待つ。
4. 初回表示・直接URL・再読込・旧タブからの遷移・ログイン/API接続を確認する。
5. 失敗時は保存した前版を再反映し、必要な無効化と確認を行う。

複数ファイルの上書きやCloudFront設定変更は、全閲覧者に対して原子的な切替を保証しない。Flutterの同名JSや遅延読込資産、service worker使用時の更新を含め、新旧混在試験を初回公開条件にする。互換性を確保できない場合は版付き資産URL/ディレクトリと入口切替へ変更し、その配信方式を確定してから本番公開する。旧資産を直ちに削除しない。S3 Versioningだけで全サイトを一括復元できる前提にしない。

## iOS / Android

1. 本番向けflavor、接続先、署名、契約版、アプリ版/ビルド番号の対応を確認する。
2. CIが作成した署名済み成果物を手動開始CDでTestFlight/Playテストへ送る。
3. 実機でログイン・予約等の主要業務、旧BE/新BEとの必要な互換性を確認する。
4. 同じ本番用ビルドを本番提出対象として選択し、ストア情報を整えて審査へ提出する。
5. 審査通過後、人が公開を選択する。段階配布を使う場合は配布率/停止条件を記録する。
6. アップロード済み/審査中/承認済み/公開済み/配布停止を別状態として記録する。

公開後の端末を即座に旧版へ戻すことはできない。配布停止、BE側の互換対応/機能制御、修正版の提出で対応する。旧モバイルが残る間は必要なAPIを維持する。

## 公式手順

- [ECS rolling更新](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/deployment-type-ecs.html)
- [CloudFrontファイル更新](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/UpdatingExistingObjects.html)
- [CloudFront invalidation](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Invalidation.html)
- [Flutter Web](https://docs.flutter.dev/deployment/web)
- [Flutter iOS](https://docs.flutter.dev/deployment/ios)
- [Flutter Android](https://docs.flutter.dev/deployment/android)
- [Flutter配布自動化](https://docs.flutter.dev/deployment/cd)

アカウント固有手順とリンクの確認日は初回構築・公開時に更新する。
