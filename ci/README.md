# CI

`buildspec.yml`はJava業務試験・DB結合・Flutter解析/試験・Webビルドを実行し、成果物を保管する。公開先S3、ECR、ECSを更新しない。Web成果物はモック確認用のビルドである。

CodeBuildはLinux標準イメージ、JDK 21、Docker privileged modeを指定する。ネットワークはMaven・pub.dev・Flutter配布先・Docker Hub・GitHubから依存を取得できること。

GitHubのPush/PR/日次実行条件、PR用権限分離、手動CDは[CI/CD方針](../doc/process/ci-cd-policy.md)に従う。この変更ではCodePipelineやAWS資源を作成しない。
