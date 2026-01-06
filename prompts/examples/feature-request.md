# 機能追加リクエスト例

このドキュメントでは、機能追加リクエストの入力例と最適化された出力例を示します。

---

## 例1: API機能追加

### 入力 (自然言語)

```
ユーザープロフィールAPIに、プロフィール画像のアップロード機能を追加してください。
画像はS3に保存して、URLをデータベースに記録したいです。
サイズは最大5MBまで、形式はJPEGとPNGのみ対応してください。
```

### 出力 (構造化タスク)

```yaml
task:
  title: "ユーザープロフィールAPIに画像アップロード機能を追加"
  description: |
    ユーザープロフィールAPIにプロフィール画像のアップロード機能を実装します。

    背景:
    - ユーザー体験向上のため、プロフィール画像設定機能が必要
    - 既存のプロフィールAPIを拡張して対応

    要件:
    - 画像をAWS S3にアップロード
    - アップロード後のURLをユーザーテーブルに保存
    - ファイルサイズ: 最大5MB
    - 対応形式: JPEG, PNG
    - 適切なエラーハンドリング

    技術仕様:
    - マルチパートフォームデータでの受信
    - S3署名付きURLの生成
    - 画像リサイズ処理 (オプション)

  type: feature
  priority: medium

  agents:
    primary: CodeGenAgent
    supporting:
      - ReviewAgent
      - SecurityAgent
      - PRAgent

  acceptance_criteria:
    - "JPEG/PNG形式の画像がアップロードできること"
    - "5MB以下の画像のみ受け付けること"
    - "5MB超過時に適切なエラーメッセージが返ること"
    - "非対応形式の場合に適切なエラーメッセージが返ること"
    - "アップロード成功時にS3 URLが返却されること"
    - "ユーザーテーブルにURLが保存されること"
    - "ユニットテストがパスすること"

  technical_context:
    files_to_modify:
      - "src/users/user.controller.ts"
      - "src/users/user.service.ts"
      - "src/users/dto/upload-image.dto.ts"
      - "src/common/services/s3.service.ts"
      - "src/users/user.controller.test.ts"
    dependencies:
      - "@aws-sdk/client-s3"
      - "multer"
      - "sharp (画像処理用)"
    testing_requirements:
      - "正常アップロードテスト"
      - "ファイルサイズ超過テスト"
      - "非対応形式テスト"
      - "S3モックを使用した統合テスト"

  estimated_effort: M

  tags:
    - feature
    - api
    - user-profile
    - s3
    - file-upload
```

---

## 例2: 通知機能追加

### 入力 (自然言語)

```
注文完了時にユーザーにメール通知を送る機能がほしい
```

### 出力 (構造化タスク)

```yaml
task:
  title: "注文完了時のメール通知機能を追加"
  description: |
    注文が完了した際に、ユーザーへメール通知を送信する機能を実装します。

    背景:
    - ユーザーへの注文確認連絡の自動化
    - カスタマーサポートの負荷軽減

    要件:
    - 注文完了イベント発生時にメール送信
    - メールテンプレートを使用
    - 注文詳細 (商品名、数量、金額) を含める
    - 送信失敗時のリトライ処理

  type: feature
  priority: medium

  agents:
    primary: CodeGenAgent
    supporting:
      - ReviewAgent
      - PRAgent

  acceptance_criteria:
    - "注文完了時にメールが送信されること"
    - "メールに注文詳細が含まれること"
    - "メール送信失敗時にリトライされること"
    - "送信ログが記録されること"
    - "テンプレートが正しくレンダリングされること"

  technical_context:
    files_to_modify:
      - "src/orders/order.service.ts"
      - "src/notifications/email.service.ts"
      - "src/notifications/templates/order-complete.template.ts"
      - "src/orders/order.service.test.ts"
    dependencies:
      - "nodemailer"
      - "メールテンプレートエンジン"
    testing_requirements:
      - "メール送信モックテスト"
      - "テンプレートレンダリングテスト"
      - "リトライ処理テスト"

  estimated_effort: M

  tags:
    - feature
    - notification
    - email
    - orders
```

---

## 例3: 検索機能追加

### 入力 (自然言語)

```
商品検索にフィルター機能を追加してほしいです。
カテゴリ、価格帯、在庫ありなしでフィルタリングできるようにしたい。
```

### 出力 (構造化タスク)

```yaml
task:
  title: "商品検索にカテゴリ・価格帯・在庫フィルター機能を追加"
  description: |
    商品検索APIにフィルター機能を追加し、ユーザーが条件を絞り込んで検索できるようにします。

    背景:
    - 商品数増加に伴い、検索結果の絞り込みが必要
    - ユーザーの購買体験向上

    要件:
    - カテゴリフィルター (複数選択可)
    - 価格帯フィルター (最小・最大)
    - 在庫フィルター (在庫あり/全て)
    - フィルターの組み合わせ対応
    - パフォーマンスを考慮したクエリ設計

  type: feature
  priority: medium

  agents:
    primary: CodeGenAgent
    supporting:
      - ReviewAgent
      - PRAgent

  acceptance_criteria:
    - "カテゴリでフィルタリングできること"
    - "価格帯 (min-max) でフィルタリングできること"
    - "在庫ありのみに絞り込めること"
    - "複数フィルターを組み合わせて検索できること"
    - "フィルターなしの場合は全件が返ること"
    - "レスポンス時間が500ms以内であること"

  technical_context:
    files_to_modify:
      - "src/products/product.controller.ts"
      - "src/products/product.service.ts"
      - "src/products/product.repository.ts"
      - "src/products/dto/search-products.dto.ts"
      - "src/products/product.service.test.ts"
    dependencies:
      - "クエリビルダー"
      - "バリデーションパイプ"
    testing_requirements:
      - "各フィルター単独テスト"
      - "フィルター組み合わせテスト"
      - "パフォーマンステスト"
      - "境界値テスト"

  estimated_effort: M

  tags:
    - feature
    - search
    - products
    - filter
```

---

## ポイント

機能追加リクエストを最適化する際のポイント:

1. **具体的な技術仕様を補完**: 入力が曖昧な場合でも、一般的なベストプラクティスに基づいて仕様を補完
2. **セキュリティ考慮**: ファイルアップロードなどセキュリティに関わる機能は SecurityAgent を supporting に追加
3. **テスト要件の明確化**: 正常系・異常系のテストケースを具体的に記載
4. **見積もりの根拠**: 対象ファイル数と変更の複雑さから effort を算出
