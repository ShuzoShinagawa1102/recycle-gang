# 画面と権限の境界

| アプリ・領域 | 利用者 | 対応先 | 主な操作 | API |
|---|---|---|---|---|
| consumer | 回収依頼者 | iOS / Android | 予約、変更・取消、回収状況、支払照会 | consumer |
| backyard / provider | 業者 | Web / iOS / Android | オファー、担当回収、採用済み経路、実績、SOS | backyard |
| backyard / admin | Recycle Gang管理者 | Web | 運行・予約・募集・割当の管理、経路計算/採用、SOS状況、監査 | admin |

管理者画面は`recycle-gang-backyard`の同じFlutterプロジェクトに置く。Webの入口を`/provider`と`/admin`に分け、feature・ルートガード・API SDKも分離する。管理者用に新しい業務サーバーは作らない。

## 管理者の操作

運行状況・予約・募集・割当・SOSを横断表示する。最適化は計算要求、候補確認、未割当確認、採用を別操作とする。採用時に入力が古ければ再計算へ誘導する。業務データの訂正は対象・変更内容・理由を確認してから基幹ユースケースへ要求する。

管理者権限は操作単位で付与し、基幹で検証する。画面非表示やURL分離だけで権限制御しない。変更操作には操作者と理由を含む監査記録を残す。

## 表示とリリース

業者モバイルは担当訪問・結果記録・SOSを中心に、PCは一覧・絞込み・比較・キーボード操作を中心に構成する。管理者機能はWebの配信対象とし、業者モバイルに管理者ナビゲーションを表示しない。

管理者Webはbackyardのリリースに含め、独立した5つ目のコンポーネント版を増やさない。Web/iOS/Androidの公開済み成果物は個別に記録する。

[API契約](../backend/api-contract-policy.md)、[フォルダ構成](../repository-layout.md)、[リリース方針](../../process/release-policy.md)
