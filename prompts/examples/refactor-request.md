# リファクタリングリクエスト例

このドキュメントでは、リファクタリングリクエストの入力例と最適化された出力例を示します。

---

## 例1: コード重複の解消

### 入力 (自然言語)

```
UserServiceとAdminServiceで同じようなバリデーションロジックが重複しているので、共通化してほしい
```

### 出力 (構造化タスク)

```yaml
task:
  title: "UserServiceとAdminServiceのバリデーションロジックを共通化"
  description: |
    UserServiceとAdminServiceに重複しているバリデーションロジックを共通モジュールに抽出し、コードの重複を解消します。

    背景:
    - 同じバリデーションロジックが複数箇所に存在
    - 修正時に複数ファイルを変更する必要がある
    - バグ修正の漏れリスクがある

    リファクタリング方針:
    - 共通バリデーションモジュールを作成
    - 既存のServiceから共通モジュールを呼び出すように変更
    - 機能の変更は行わない (動作は同一)

    対象ロジック:
    - メールアドレスバリデーション
    - パスワード強度チェック
    - ユーザー名バリデーション

  type: refactor
  priority: low

  agents:
    primary: CodeGenAgent
    supporting:
      - ReviewAgent

  acceptance_criteria:
    - "共通バリデーションモジュールが作成されていること"
    - "UserServiceが共通モジュールを使用していること"
    - "AdminServiceが共通モジュールを使用していること"
    - "既存の全テストがパスすること"
    - "重複コードが解消されていること"
    - "外部からの動作が変わらないこと"

  technical_context:
    files_to_modify:
      - "src/users/user.service.ts"
      - "src/admin/admin.service.ts"
      - "src/common/validators/user-validators.ts (新規)"
      - "src/common/validators/user-validators.test.ts (新規)"
    dependencies:
      - "class-validator"
    testing_requirements:
      - "共通バリデーションのユニットテスト"
      - "既存テストの回帰確認"
      - "統合テストの実行"

  estimated_effort: S

  tags:
    - refactor
    - code-quality
    - dry-principle
```

---

## 例2: アーキテクチャ改善

### 入力 (自然言語)

```
データアクセス層がControllerに直接書かれているのでRepository層に分離したい
```

### 出力 (構造化タスク)

```yaml
task:
  title: "ControllerからデータアクセスロジックをRepository層に分離"
  description: |
    Controller内に直接記述されているデータアクセスロジックをRepository層に分離し、レイヤードアーキテクチャを適用します。

    背景:
    - ControllerにSQLクエリやORMの直接操作が存在
    - テストが困難な構造
    - 責務の分離ができていない

    リファクタリング方針:
    - Repository層を新規作成
    - データアクセスロジックをRepositoryに移動
    - ControllerはServiceを経由してRepositoryを使用
    - 依存性注入パターンを適用

    アーキテクチャ:
    Controller -> Service -> Repository -> Database

  type: refactor
  priority: medium

  agents:
    primary: CodeGenAgent
    supporting:
      - ReviewAgent

  acceptance_criteria:
    - "Repository層が作成されていること"
    - "Controllerにデータアクセスコードがないこと"
    - "依存性注入が適用されていること"
    - "Repositoryのモックを使用したテストが可能なこと"
    - "既存の全機能が正常に動作すること"
    - "既存テストがパスすること"

  technical_context:
    files_to_modify:
      - "src/products/product.controller.ts"
      - "src/products/product.service.ts"
      - "src/products/product.repository.ts (新規)"
      - "src/products/product.repository.test.ts (新規)"
      - "src/products/product.module.ts"
    dependencies:
      - "TypeORM / Prisma"
      - "依存性注入コンテナ"
    testing_requirements:
      - "Repository層のユニットテスト"
      - "Service層のモックテスト"
      - "E2Eテストの実行"

  estimated_effort: L

  tags:
    - refactor
    - architecture
    - repository-pattern
    - layered-architecture
```

---

## 例3: 命名改善

### 入力 (自然言語)

```
変数名や関数名がわかりにくいので、わかりやすい名前に変更したい
特にutil.tsの関数名がひどい
```

### 出力 (構造化タスク)

```yaml
task:
  title: "util.tsの関数名・変数名をわかりやすい名前にリネーム"
  description: |
    util.ts内の関数名・変数名を、より意図が明確な名前にリネームします。

    背景:
    - 関数名から処理内容が推測できない
    - コードの可読性が低い
    - 新規メンバーの理解コストが高い

    リネーム方針:
    - 動詞 + 目的語の形式
    - 略語を避け、フルスペルを使用
    - 処理内容を明確に表現

    注意点:
    - 全ての呼び出し元も同時に更新
    - エクスポート名の変更に注意
    - 破壊的変更となるため、利用箇所の洗い出しが必要

  type: refactor
  priority: low

  agents:
    primary: CodeGenAgent
    supporting:
      - ReviewAgent

  acceptance_criteria:
    - "全ての関数名が処理内容を表していること"
    - "全ての呼び出し元が更新されていること"
    - "TypeScriptのコンパイルが通ること"
    - "既存テストがパスすること"
    - "JSDocコメントが更新されていること"

  technical_context:
    files_to_modify:
      - "src/common/util.ts"
      - "呼び出し元ファイル (grep で特定)"
      - "テストファイル"
    dependencies: []
    testing_requirements:
      - "リネーム後の動作確認テスト"
      - "既存テストの実行"
      - "TypeScriptコンパイルチェック"

  estimated_effort: S

  tags:
    - refactor
    - naming
    - code-quality
    - readability
```

---

## 例4: パフォーマンス最適化

### 入力 (自然言語)

```
商品一覧のAPIが遅いので、N+1クエリを解消してほしい
```

### 出力 (構造化タスク)

```yaml
task:
  title: "商品一覧APIのN+1クエリを解消してパフォーマンス改善"
  description: |
    商品一覧APIで発生しているN+1クエリ問題を解消し、パフォーマンスを改善します。

    背景:
    - 商品一覧取得時に関連データを個別にクエリしている
    - 商品数に比例してクエリ数が増加
    - レスポンス時間が商品数に依存

    最適化方針:
    - Eager Loading (事前読み込み) の適用
    - JOINクエリへの変更
    - 必要な関連データのみを取得

    期待効果:
    - クエリ数: N+1 -> 1〜2
    - レスポンス時間: 大幅改善

  type: refactor
  priority: medium

  agents:
    primary: CodeGenAgent
    supporting:
      - ReviewAgent

  acceptance_criteria:
    - "商品一覧取得のクエリ数が定数になること"
    - "レスポンス時間が50%以上改善すること"
    - "取得データの内容が変わらないこと"
    - "既存テストがパスすること"
    - "パフォーマンステストがパスすること"

  technical_context:
    files_to_modify:
      - "src/products/product.repository.ts"
      - "src/products/product.service.ts"
      - "src/products/product.service.test.ts"
    dependencies:
      - "ORM (TypeORM / Prisma)"
    testing_requirements:
      - "クエリ数計測テスト"
      - "レスポンス時間計測テスト"
      - "大量データでの負荷テスト"

  estimated_effort: M

  tags:
    - refactor
    - performance
    - n-plus-one
    - database
    - optimization
```

---

## 例5: テスト追加

### 入力 (自然言語)

```
PaymentServiceのテストがないので追加してほしい
```

### 出力 (構造化タスク)

```yaml
task:
  title: "PaymentServiceのユニットテストを追加"
  description: |
    PaymentServiceにユニットテストを追加し、テストカバレッジを向上させます。

    背景:
    - PaymentServiceにテストが存在しない
    - 決済という重要機能のテストがない
    - リファクタリング時の安全性が担保されていない

    テスト方針:
    - 外部APIはモック化
    - 正常系・異常系を網羅
    - 境界値テストを含める
    - 決済金額のバリデーションテスト

  type: refactor
  priority: medium

  agents:
    primary: CodeGenAgent
    supporting:
      - ReviewAgent
      - SecurityAgent

  acceptance_criteria:
    - "PaymentServiceのカバレッジが80%以上であること"
    - "正常系テストが存在すること"
    - "異常系テスト (API失敗、バリデーションエラー) が存在すること"
    - "モックを使用した外部API呼び出しテストがあること"
    - "金額の境界値テストがあること"
    - "全テストがパスすること"

  technical_context:
    files_to_modify:
      - "src/payments/payment.service.test.ts (新規)"
      - "src/payments/__mocks__/payment-gateway.mock.ts (新規)"
    dependencies:
      - "vitest"
      - "モックライブラリ"
    testing_requirements:
      - "決済成功テスト"
      - "決済失敗テスト"
      - "無効な金額テスト"
      - "外部APIタイムアウトテスト"

  estimated_effort: M

  tags:
    - refactor
    - testing
    - payment
    - coverage
```

---

## ポイント

リファクタリングリクエストを最適化する際のポイント:

1. **機能変更がないことを明記**: リファクタリングは動作を変えずに構造を改善
2. **回帰テストを必須条件に**: 既存機能への影響がないことを確認
3. **優先度は低めに設定**: 機能追加・バグ修正より優先度は低い
4. **段階的な実施を検討**: 大規模リファクタは複数タスクに分割
5. **Before/Afterを明確に**: 何がどう改善されるかを具体的に記述
