# 技術・運用の公式参考資料

確認日：2026-10-03。仕様・価格・対応版は実装/公開時にも再確認する。個々の採用判断は [開発方針](../architecture/development-baseline.md) に記載する。

| 対象 | 一次資料 | この設計で確認する点 |
|---|---|---|
| Spring Boot | [3.5 system requirements](https://docs.spring.io/spring-boot/3.5/system-requirements.html) | JDK/Gradleの対応 |
| Gradle | [Compatibility matrix](https://docs.gradle.org/current/userguide/compatibility.html) | 実行JDKとtoolchainの対応 |
| jOOQ | [JDK matrix](https://www.jooq.org/download/support-matrix-jdk)、[DB matrix](https://www.jooq.org/download/support-matrix) | OSS/商用と対応版 |
| jOOQ/Flyway | [公式チュートリアル](https://www.jooq.org/doc/latest/manual/getting-started/tutorials/jooq-with-flyway/) | migration→生成→開発 |
| Flyway | [Migrations](https://documentation.red-gate.com/fd/migrations-271585107.html)、[Validate](https://documentation.red-gate.com/fd/validate-277578898.html) | DDL/DML管理、履歴検証の範囲 |
| Spring Modulith | [Overview](https://spring.io/projects/spring-modulith/)、[Testing](https://docs.spring.io/spring-modulith/reference/testing.html) | モジュール構造・部分試験 |
| OpenAPI | [3.0.3仕様](https://spec.openapis.org/oas/v3.0.3) | tags、security、参照 |
| OpenAPI Generator | [Spring](https://openapi-generator.tech/docs/generators/spring/)、[Dart Dio](https://openapi-generator.tech/docs/generators/dart-dio/)、[Python](https://openapi-generator.tech/docs/generators/python/) | 生成範囲と設定 |
| Spring Security | [HTTP authorization](https://docs.spring.io/spring-security/reference/servlet/authorization/authorize-http-requests.html) | URL認可、アプリ認可との役割 |
| CQRS | [Microsoft architecture pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/cqrs) | 同一DBでの更新/参照分離 |
| FastAPI | [Features](https://fastapi.tiangolo.com/features/)、[Background tasks](https://fastapi.tiangolo.com/tutorial/background-tasks/) | OpenAPI、重い計算の分離 |
| GitFlow | [提唱者の原案](https://nvie.com/posts/a-successful-git-branching-model/) | release/hotfixのmerge先 |
| CodePipeline | [Filters](https://docs.aws.amazon.com/codepipeline/latest/userguide/pipelines-filter.html)、[Triggers](https://docs.aws.amazon.com/codepipeline/latest/userguide/pipelines-triggers.html) | Push/PR/タグ、対象revision |
| EventBridge Scheduler | [Schedule types](https://docs.aws.amazon.com/scheduler/latest/UserGuide/schedule-types.html) | cron、タイムゾーン |
| Aurora | [Serverless v2](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2.html)、[Auto-pause](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2-auto-pause.html) | min/max容量、停止/再開条件 |
| ECS | [Rolling updates](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/deployment-type-ecs.html) | 旧新タスク共存 |
| CloudFront | [Versioning](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/UpdatingExistingObjects.html)、[Invalidation](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Invalidation.html) | 静的資産更新・キャッシュ |
| Flutter | [Web](https://docs.flutter.dev/deployment/web)、[iOS](https://docs.flutter.dev/deployment/ios)、[Android](https://docs.flutter.dev/deployment/android)、[CD](https://docs.flutter.dev/deployment/cd) | 成果物、署名、配布 |
| CodeBuild Mac | [Compute types](https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html)、[Pricing](https://aws.amazon.com/codebuild/pricing/) | macOS fleet・最低利用期間 |
| GitHub runner | [Hosted runners](https://docs.github.com/en/actions/reference/runners/github-hosted-runners) | iOS用macOS候補 |


## AWS構成図レビューで確認した資料

| 対象 | 一次資料 | 確認点 |
|---|---|---|
| Service Connect | [Components](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-connect-concepts-deploy.html) | alias、SG、timeout、endpoint追加時の再配置、CodeDeploy制約 |
| ALB | [SetSubnets](https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_SetSubnets.html) | 2AZ subnet要件 |
| Aurora | [Create cluster](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.CreateInstance.html) | DB subnet groupとストレージ/instanceの違い |
| WAF | [Resource association](https://docs.aws.amazon.com/waf/latest/developerguide/web-acl-associating-aws-resource.html) | CloudFrontへのWeb ACL関連付け |
| CloudFront origin保護 | [Restrict ALB access](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/restrict-access-to-load-balancer.html) | prefix list、秘密header、HTTPS |
| ECR | [VPC endpoints](https://docs.aws.amazon.com/AmazonECR/latest/userguide/vpc-endpoints.html) | image取得とS3経路 |
