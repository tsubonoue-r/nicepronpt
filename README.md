# nicepronpt
Autonomous development powered by Agentic OS

---

## Miyabi Optimizer

ユーザーの自然言語リクエストを解析し、Miyabi 6 Agent システムに最適化された構造化タスクに変換するメタプロンプトです。

### Miyabi 6 Agent システム

| Agent | 役割 |
|-------|------|
| **CoordinatorAgent** | タスク分解・調整 |
| **CodeGenAgent** | コード生成 |
| **ReviewAgent** | 品質検証 |
| **PRAgent** | PR管理 |
| **DeployAgent** | デプロイ |
| **SecurityAgent** | セキュリティ |

### 使い方

#### 1. メタプロンプトの読み込み

`prompts/miyabi-optimizer.md` をシステムプロンプトとしてLLMに設定します。

```python
with open("prompts/miyabi-optimizer.md", "r") as f:
    system_prompt = f.read()

response = client.messages.create(
    model="claude-sonnet-4-20250514",
    system=system_prompt,
    messages=[
        {"role": "user", "content": "ユーザーログイン時に最終ログイン日時を記録する機能を追加してほしい"}
    ]
)
```

#### 2. 自然言語リクエストの入力

ユーザーからのリクエストをそのまま入力します：

```
商品検索にカテゴリフィルターを追加してほしい
```

#### 3. 構造化タスクの出力

最適化されたYAML形式のタスク定義が出力されます：

```yaml
task:
  title: "商品検索にカテゴリフィルター機能を追加"
  type: feature
  priority: medium
  agents:
    primary: CodeGenAgent
    supporting:
      - ReviewAgent
      - PRAgent
  acceptance_criteria:
    - "カテゴリでフィルタリングできること"
    - "複数カテゴリを選択できること"
  # ...
```

### サンプル

`prompts/examples/` ディレクトリに各種リクエストの例があります：

| ファイル | 内容 |
|----------|------|
| [feature-request.md](prompts/examples/feature-request.md) | 機能追加リクエスト例 |
| [bug-report.md](prompts/examples/bug-report.md) | バグ報告例 |
| [refactor-request.md](prompts/examples/refactor-request.md) | リファクタリング例 |
| [deployment-request.md](prompts/examples/deployment-request.md) | デプロイリクエスト例 |

### ディレクトリ構成

```
nicepronpt/
├── README.md
├── prompts/
│   ├── miyabi-optimizer.md      # メインのメタプロンプト
│   └── examples/
│       ├── feature-request.md   # 機能追加例
│       ├── bug-report.md        # バグ報告例
│       ├── refactor-request.md  # リファクタリング例
│       └── deployment-request.md # デプロイ例
└── ...
```

### タスク種別

| 種別 | キーワード例 | Primary Agent |
|------|-------------|---------------|
| feature | 追加, 新規, 実装 | CodeGenAgent |
| bugfix | バグ, 修正, エラー | CodeGenAgent |
| refactor | リファクタ, 整理, 最適化 | CodeGenAgent |
| deploy | デプロイ, リリース, 本番 | DeployAgent |
| security | セキュリティ, 脆弱性, 監査 | SecurityAgent |
| documentation | ドキュメント, README | CodeGenAgent |

### 優先度

| 優先度 | 条件 | SLA |
|--------|------|-----|
| Critical | 本番障害, セキュリティ緊急 | 1時間以内 |
| High | 機能停止, 重要バグ | 4時間以内 |
| Medium | 通常機能追加, 一般バグ | 1営業日 |
| Low | リファクタ, ドキュメント | 1週間 |

---

## ライセンス

[LICENSE](LICENSE) を参照してください。
