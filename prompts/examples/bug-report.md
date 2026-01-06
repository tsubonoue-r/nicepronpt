# バグ報告例

このドキュメントでは、バグ報告リクエストの入力例と最適化された出力例を示します。

---

## 例1: データ不整合バグ

### 入力 (自然言語)

```
カートに商品を追加した後、ページをリロードすると商品が消えてしまいます。
ログインしているユーザーでも同じ現象が起きます。
```

### 出力 (構造化タスク)

```yaml
task:
  title: "カート商品がページリロード時に消失するバグを修正"
  description: |
    カートに商品を追加後、ページをリロードすると追加した商品が消えてしまう問題を修正します。

    現象:
    - カートに商品を追加
    - ページをリロード (F5 / ブラウザ更新)
    - カートが空になっている
    - ログイン済みユーザーでも再現

    想定される原因:
    1. カート情報がサーバーサイドに永続化されていない
    2. セッションストレージのみで管理されている
    3. カート同期APIのタイミング問題
    4. データベースへの書き込み失敗 (サイレント)

    調査ポイント:
    - カート追加APIのレスポンス確認
    - データベースへの書き込み確認
    - セッション管理の実装確認

  type: bugfix
  priority: high

  agents:
    primary: CodeGenAgent
    supporting:
      - ReviewAgent
      - PRAgent

  acceptance_criteria:
    - "カート追加後、リロードしても商品が保持されること"
    - "ログインユーザーのカートがサーバーに永続化されること"
    - "ゲストユーザーのカートがセッションで管理されること"
    - "複数タブでもカートが同期されること"
    - "回帰テストがパスすること"

  technical_context:
    files_to_modify:
      - "src/cart/cart.service.ts"
      - "src/cart/cart.repository.ts"
      - "src/cart/cart.controller.ts"
      - "src/cart/cart.service.test.ts"
    dependencies:
      - "セッション管理"
      - "データベース接続"
    testing_requirements:
      - "カート永続化テスト"
      - "リロード後のカート状態テスト"
      - "ログイン/ゲスト別動作テスト"

  estimated_effort: M

  tags:
    - bugfix
    - cart
    - data-persistence
    - high-priority
```

---

## 例2: パフォーマンス問題

### 入力 (自然言語)

```
ダッシュボードの読み込みがすごく遅い。10秒以上かかることがある。
```

### 出力 (構造化タスク)

```yaml
task:
  title: "ダッシュボードの読み込み速度低下を修正"
  description: |
    ダッシュボードページの読み込みに10秒以上かかる問題を調査・修正します。

    現象:
    - ダッシュボードへのアクセス時に10秒以上待機が発生
    - 体感的に非常に遅い

    想定される原因:
    1. N+1クエリ問題
    2. 不要なデータの取得
    3. インデックスの欠落
    4. 外部API呼び出しの遅延
    5. フロントエンドのレンダリング問題

    調査手順:
    1. APIレスポンス時間の計測
    2. データベースクエリのプロファイリング
    3. 外部API呼び出しの確認
    4. フロントエンドのパフォーマンス計測

  type: bugfix
  priority: high

  agents:
    primary: CodeGenAgent
    supporting:
      - ReviewAgent
      - PRAgent

  acceptance_criteria:
    - "ダッシュボードの読み込みが3秒以内に完了すること"
    - "データベースクエリが最適化されていること"
    - "不要なデータ取得が削減されていること"
    - "パフォーマンステストがパスすること"

  technical_context:
    files_to_modify:
      - "src/dashboard/dashboard.service.ts"
      - "src/dashboard/dashboard.repository.ts"
      - "src/dashboard/dashboard.controller.ts"
    dependencies:
      - "データベースORM"
      - "キャッシュ機構"
    testing_requirements:
      - "レスポンス時間計測テスト"
      - "負荷テスト"
      - "クエリ実行計画の確認"

  estimated_effort: M

  tags:
    - bugfix
    - performance
    - dashboard
    - optimization
```

---

## 例3: 認証エラー

### 入力 (自然言語)

```
パスワードリセットのメールが届かない
```

### 出力 (構造化タスク)

```yaml
task:
  title: "パスワードリセットメールが送信されない問題を修正"
  description: |
    パスワードリセット機能でメールが送信されない、または届かない問題を修正します。

    現象:
    - パスワードリセットを要求
    - 「メールを送信しました」と表示される
    - 実際にはメールが届かない

    想定される原因:
    1. メール送信処理のエラー (サイレント失敗)
    2. メールサービスの設定問題
    3. SPF/DKIM設定の問題 (スパム判定)
    4. メールアドレスのバリデーション問題
    5. 非同期処理のキュー問題

    調査ポイント:
    - メール送信ログの確認
    - メールサービスのダッシュボード確認
    - エラーハンドリングの実装確認

  type: bugfix
  priority: critical

  agents:
    primary: CodeGenAgent
    supporting:
      - ReviewAgent
      - SecurityAgent
      - PRAgent

  acceptance_criteria:
    - "パスワードリセットメールが正常に送信されること"
    - "メール送信失敗時に適切なエラーログが出力されること"
    - "ユーザーに送信失敗を通知できること"
    - "スパムフィルターに引っかからないこと"
    - "送信レート制限が適用されていること"

  technical_context:
    files_to_modify:
      - "src/auth/password-reset.service.ts"
      - "src/notifications/email.service.ts"
      - "src/auth/password-reset.controller.ts"
      - "src/auth/password-reset.service.test.ts"
    dependencies:
      - "メール送信サービス"
      - "キューシステム"
    testing_requirements:
      - "メール送信成功テスト"
      - "メール送信失敗時のエラーハンドリングテスト"
      - "レート制限テスト"

  estimated_effort: M

  tags:
    - bugfix
    - auth
    - email
    - critical
```

---

## 例4: UI表示バグ

### 入力 (自然言語)

```
iPhoneでメニューが画面からはみ出して表示される
```

### 出力 (構造化タスク)

```yaml
task:
  title: "iPhone端末でのメニュー表示はみ出しを修正"
  description: |
    iPhone端末でナビゲーションメニューが画面からはみ出して表示される問題を修正します。

    現象:
    - iPhoneでアクセス時にメニューが画面右端からはみ出す
    - 横スクロールが発生
    - タップ操作に支障

    想定される原因:
    1. レスポンシブ対応の不備
    2. Safe Area未考慮
    3. flexbox/gridの設定問題
    4. 固定幅指定の問題

    対象デバイス:
    - iPhone SE (375px)
    - iPhone 12/13/14 (390px)
    - iPhone Plus/Max (428px)

  type: bugfix
  priority: medium

  agents:
    primary: CodeGenAgent
    supporting:
      - ReviewAgent
      - PRAgent

  acceptance_criteria:
    - "iPhone SE (375px) でメニューが正常に表示されること"
    - "iPhone 12/13/14 (390px) でメニューが正常に表示されること"
    - "横スクロールが発生しないこと"
    - "メニュー項目が全てタップ可能であること"
    - "Safe Areaが考慮されていること"

  technical_context:
    files_to_modify:
      - "src/components/Navigation/Navigation.module.css"
      - "src/components/Navigation/Navigation.tsx"
      - "src/styles/breakpoints.css"
    dependencies:
      - "CSSモジュール"
      - "レスポンシブデザイン"
    testing_requirements:
      - "各iPhone幅でのビジュアルテスト"
      - "Safe Area対応テスト"
      - "タップ領域テスト"

  estimated_effort: S

  tags:
    - bugfix
    - ui
    - responsive
    - mobile
    - ios
```

---

## ポイント

バグ報告を最適化する際のポイント:

1. **再現手順の整理**: 曖昧な報告でも、想定される再現手順を整理
2. **原因の仮説立て**: 想定される原因を複数挙げて調査効率を向上
3. **優先度の適切な設定**: ユーザー影響度に基づいて優先度を判断
4. **セキュリティ考慮**: 認証・認可関連のバグは SecurityAgent を含める
5. **回帰テスト**: 修正後の回帰を防ぐテストを必須条件に含める
