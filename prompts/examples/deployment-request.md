# デプロイリクエスト例

このドキュメントでは、デプロイリクエストの入力例と最適化された出力例を示します。

---

## 例1: ステージング環境デプロイ

### 入力 (自然言語)

```
最新のdevelopブランチをステージング環境にデプロイしてください
```

### 出力 (構造化タスク)

```yaml
task:
  title: "developブランチをステージング環境にデプロイ"
  description: |
    最新のdevelopブランチをステージング環境にデプロイします。

    デプロイ情報:
    - ソースブランチ: develop (最新)
    - 対象環境: staging
    - デプロイタイプ: 通常デプロイ

    事前確認:
    - CIパイプラインの成功確認
    - テスト全件パス確認
    - セキュリティスキャン完了確認

    デプロイ後確認:
    - ヘルスチェック
    - スモークテスト
    - ログ監視

  type: deploy
  priority: medium

  agents:
    primary: DeployAgent
    supporting:
      - SecurityAgent

  acceptance_criteria:
    - "ステージング環境でアプリケーションが起動すること"
    - "ヘルスチェックエンドポイントが200を返すこと"
    - "主要APIが正常に動作すること"
    - "エラーログが出力されていないこと"
    - "ロールバック手順が確認されていること"

  technical_context:
    files_to_modify: []
    dependencies:
      - "Firebase Hosting"
      - "Cloud Run"
      - "GitHub Actions"
    testing_requirements:
      - "ヘルスチェックテスト"
      - "APIスモークテスト"
      - "E2Eテスト (critical path)"

  estimated_effort: S

  tags:
    - deploy
    - staging
    - develop
```

---

## 例2: 本番環境リリース

### 入力 (自然言語)

```
v3.0.0を本番環境にリリースしてください。リリースノートも作成してほしい。
```

### 出力 (構造化タスク)

```yaml
task:
  title: "v3.0.0を本番環境にリリース"
  description: |
    バージョン3.0.0を本番環境にリリースします。

    リリース情報:
    - バージョン: v3.0.0
    - 対象環境: production
    - リリースタイプ: メジャーバージョンアップ

    リリース手順:
    1. リリースブランチの最終確認
    2. ステージング環境での動作確認完了
    3. リリースノート作成
    4. 本番デプロイ実行
    5. 本番環境動作確認
    6. リリースタグ作成

    リスク対策:
    - ロールバック手順の確認
    - オンコール体制の確認
    - 監視アラートの設定確認

  type: deploy
  priority: high

  agents:
    primary: DeployAgent
    supporting:
      - SecurityAgent
      - ReviewAgent

  acceptance_criteria:
    - "本番環境でアプリケーションが正常起動すること"
    - "全てのヘルスチェックがパスすること"
    - "主要機能のE2Eテストがパスすること"
    - "エラー率が閾値以下であること"
    - "リリースノートが作成されていること"
    - "GitHubリリースが作成されていること"
    - "ロールバック手順が文書化されていること"

  technical_context:
    files_to_modify:
      - "CHANGELOG.md"
      - "package.json (バージョン更新済み想定)"
    dependencies:
      - "Firebase Hosting"
      - "Cloud Run"
      - "GitHub Releases"
    testing_requirements:
      - "本番同等環境でのE2Eテスト"
      - "負荷テスト"
      - "セキュリティスキャン"

  estimated_effort: M

  tags:
    - deploy
    - production
    - release
    - v3.0.0
    - major-version
```

---

## 例3: ホットフィックスデプロイ

### 入力 (自然言語)

```
本番で決済エラーが発生しているので、至急修正版をデプロイしてほしい
```

### 出力 (構造化タスク)

```yaml
task:
  title: "決済エラー修正のホットフィックスを本番環境に緊急デプロイ"
  description: |
    本番環境で発生している決済エラーの修正版を緊急デプロイします。

    障害状況:
    - 発生環境: 本番 (production)
    - 影響: 決済処理が失敗
    - 影響範囲: 全ユーザー
    - 発生時刻: 要確認

    緊急対応手順:
    1. 修正コードのレビュー (簡略化)
    2. ステージングでの動作確認 (最小限)
    3. 本番デプロイ
    4. 決済機能の動作確認
    5. 監視強化

    注意事項:
    - 最小限の変更に留める
    - ロールバック手順を事前確認
    - デプロイ後の監視を強化

  type: deploy
  priority: critical

  agents:
    primary: DeployAgent
    supporting:
      - SecurityAgent
      - ReviewAgent

  acceptance_criteria:
    - "決済処理が正常に完了すること"
    - "決済エラー率が正常値に回復すること"
    - "他の機能に影響がないこと"
    - "デプロイ完了後30分間エラーが発生しないこと"
    - "ロールバック可能な状態であること"

  technical_context:
    files_to_modify: []
    dependencies:
      - "Firebase Hosting"
      - "Cloud Run"
      - "監視システム"
    testing_requirements:
      - "決済フローの動作確認"
      - "主要APIの疎通確認"
      - "エラーログ監視"

  estimated_effort: S

  tags:
    - deploy
    - production
    - hotfix
    - critical
    - payment
```

---

## 例4: 環境構築

### 入力 (自然言語)

```
新しい開発メンバー用にdev環境を追加で作成してほしい
```

### 出力 (構造化タスク)

```yaml
task:
  title: "新規開発メンバー用のdev環境を構築"
  description: |
    新しい開発メンバー用に専用のdev環境を構築します。

    環境情報:
    - 環境名: dev-[メンバー名]
    - 目的: 開発・検証用
    - ベース: 既存dev環境のクローン

    構築内容:
    - Firebase Hostingのプレビューチャンネル作成
    - Cloud Run サービスのデプロイ
    - データベースの接続設定
    - 環境変数の設定
    - アクセス権限の付与

    セキュリティ考慮:
    - 本番データへのアクセス制限
    - シークレットの適切な管理
    - アクセスログの記録

  type: deploy
  priority: low

  agents:
    primary: DeployAgent
    supporting:
      - SecurityAgent

  acceptance_criteria:
    - "dev環境が正常に起動すること"
    - "アプリケーションにアクセスできること"
    - "データベースに接続できること"
    - "本番データにアクセスできないこと"
    - "必要な権限が付与されていること"
    - "環境情報がドキュメント化されていること"

  technical_context:
    files_to_modify:
      - ".firebaserc (エイリアス追加)"
      - "環境設定ファイル"
    dependencies:
      - "Firebase CLI"
      - "gcloud CLI"
      - "Terraform (IaC使用時)"
    testing_requirements:
      - "環境アクセステスト"
      - "データベース接続テスト"
      - "権限テスト"

  estimated_effort: M

  tags:
    - deploy
    - environment
    - development
    - setup
```

---

## 例5: ロールバック

### 入力 (自然言語)

```
v2.5.1にロールバックしてください。v2.5.2で問題が発生しています。
```

### 出力 (構造化タスク)

```yaml
task:
  title: "本番環境をv2.5.1にロールバック"
  description: |
    本番環境をv2.5.2からv2.5.1にロールバックします。

    ロールバック情報:
    - 現在のバージョン: v2.5.2
    - ロールバック先: v2.5.1
    - 対象環境: production

    ロールバック理由:
    - v2.5.2で問題が発生
    - 詳細な原因調査より先に安定版に戻す

    ロールバック手順:
    1. v2.5.1のイメージ/アーティファクトの確認
    2. ロールバック実行
    3. 動作確認
    4. 監視強化

    注意事項:
    - データベースマイグレーションの確認
    - 下位互換性の確認
    - ロールバック後の原因調査

  type: deploy
  priority: critical

  agents:
    primary: DeployAgent
    supporting:
      - SecurityAgent

  acceptance_criteria:
    - "本番環境がv2.5.1で動作していること"
    - "問題が発生していた機能が正常に動作すること"
    - "他の機能に影響がないこと"
    - "エラー率が正常値に回復すること"
    - "ロールバック完了の記録が残ること"

  technical_context:
    files_to_modify: []
    dependencies:
      - "Firebase Hosting"
      - "Cloud Run"
      - "コンテナレジストリ"
    testing_requirements:
      - "主要機能の動作確認"
      - "問題が発生していた機能のテスト"
      - "データ整合性確認"

  estimated_effort: S

  tags:
    - deploy
    - production
    - rollback
    - critical
    - v2.5.1
```

---

## ポイント

デプロイリクエストを最適化する際のポイント:

1. **環境を明確に**: staging / production / dev を必ず明記
2. **バージョンを明確に**: タグ、ブランチ、コミットを特定
3. **SecurityAgentを必ず含める**: デプロイには常にセキュリティ確認
4. **ロールバック手順**: 特に本番デプロイでは必須
5. **優先度の適切な設定**:
   - 通常デプロイ: medium
   - 本番リリース: high
   - ホットフィックス: critical
6. **監視・確認項目**: デプロイ後の確認事項を明記
