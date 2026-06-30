# debugger-workstation

[English](README.md) · [简体中文](README.zh-CN.md) · **日本語** · [Русский](README.ru.md)

ポータブルなリバースエンジニアリング / セキュリティ分析 / デバッグ / アンパック / モバイル分析 / ネットワークキャプチャ / システム検査 / MCP 自動化のワークステーションのための**スケルトンリポジトリ**です。

任意の AI agent（Claude / Codex / Gemini / Cursor / Copilot）または人間がこのリポジトリをクローンし、ここにあるドキュメントと manifest に従うことで、**AI が操作するように最適化された**ツールステーションを自分のマシン上に再構築できます。

> ⚠️ **このリポジトリにはサードパーティ製ツールのバイナリは一切含まれていません。** ツールは `manifests/` + `scripts/bootstrap.ps1` を通じて各公式ソースから取得します。[DISCLAIMER.md](DISCLAIMER.md) を参照してください。

---

## このリポジトリの内容

| パス | 内容 |
| --- | --- |
| `AGENTS.md` | すべての AI agent のための**正式なエントリ** — 初期化ハンドシェイク（ask-then-act）、MCP 戦略、境界。 |
| `CLAUDE.md` / `GEMINI.md` / `.github/copilot-instructions.md` / `.cursor/rules/` | クライアントごとのエントリファイル。いずれも `AGENTS.md` を指します。 |
| `templates/INIT_QUESTIONNAIRE.md` | 動的な初期化を駆動する確認質問のチェックリスト。 |
| `docs/` | 人間および AI 向けのドキュメント（元のワークステーションルールから脱センシティブ化したもの）。 |
| `docs/extensions/INDEX.md` | 追加できる MCP サーバー / AI skill の厳選インデックス。 |
| `manifests/tools.json` | ツール manifest：名前、バージョン、公式ダウンロードソース、インストールパス。 |
| `manifests/mcp-backends.json` | サードパーティ MCP バックエンドのアップストリーム + 自社開発のコア。 |
| `mcp/debugger-router/server.py` | **自社開発**の軽量 MCP ルーター（バックエンドをオンデマンドで起動。デフォルトで有効な唯一の MCP）。 |
| `mcp/bin/*.cmd` | **自社開発**のバックエンド MCP ラッパースクリプト（相対パス、ポータブル）。 |
| `mcp/.mcp.json.template` | MCP 設定テンプレート。bootstrap が `{{DEBUGGER_ROOT}}` を置換します。 |
| `scripts/bootstrap.ps1` | manifest からワークステーションを再構築します（デフォルトは dry-run）。 |

**含まれないもの**（`.gitignore` により厳格に除外）：ツールバイナリ、`.env`/認証情報、`.venv`/`node_modules`/ランタイム、サンプル/pcap/ダンプ、スクラッチワークスペース、ローカル git 履歴。

## クイックスタート

```powershell
# 1. dry-run: show the plan only, no writes, no downloads
pwsh scripts\bootstrap.ps1 -InstallRoot "D:\Tool\debugger"

# 2. once the plan looks right: deploy the self-developed MCP, generate local config, clone third-party MCPs
pwsh scripts\bootstrap.ps1 -Apply -CloneMcp -InstallRoot "D:\Tool\debugger"

# 3. download tool binaries to their category folders from the official sources listed in the dry-run
#    (this repo does not download third-party tool binaries for you)

# 4. rebuild each third-party MCP's .venv / dotnet / node dependencies, then smoke-test
```

> Windows PowerShell 5.1 でも動作します（スクリプトは UTF-8 BOM）。PowerShell 7（`pwsh`）を推奨します。

## AI agent 向け：まずこれを読む

クローン後、**まず [AGENTS.md](AGENTS.md) を読んでください**（初期化ハンドシェイクプロトコルを含む正式なエントリ）。クライアントごとのエントリ — Claude→`CLAUDE.md`、Gemini→`GEMINI.md`、Cursor→`.cursor/rules/`、Copilot→`.github/copilot-instructions.md` — はいずれも `AGENTS.md` を指します。

核心的な考え方：ワークステーションのセットアップを求められたとき、AI は**すぐには行動しません**。探索し（読み取り専用）、確認質問を行い（インストールルート、スコープ、どの MCP を使うか、バイナリをダウンロードするか、AI クライアント、システムレベルのコンポーネント）、プランを提示し、その後ようやく — あなたの確認を得てから — `bootstrap.ps1` を実行します。

さらに読むべきもの：
1. [AGENTS.md](AGENTS.md) — **正式なエントリ**：ハンドシェイク、MCP 戦略、境界。
2. [templates/INIT_QUESTIONNAIRE.md](templates/INIT_QUESTIONNAIRE.md) — 確認質問のチェックリスト。
3. [docs/AI_USAGE_GUIDE.md](docs/AI_USAGE_GUIDE.md) — 読む順序、AI が独自に行ってよいこと。
4. [docs/WORKSTATION_RULES.md](docs/WORKSTATION_RULES.md) — ワークステーションの完全なルール、更新/クリーンアップのフロー。
5. [manifests/](manifests/) — ツールと MCP の manifest。
6. [docs/extensions/INDEX.md](docs/extensions/INDEX.md) — 追加できる拡張機能。

## MCP 戦略

デフォルトで有効なのは `debugger-router` という 1 つの軽量 MCP のみです。19 個のバックエンドのうち必要なものをオンデマンドで起動し、完了したら終了します。デフォルトですべてのバックエンドを一度にロードしないでください。直接接続する場合は profile（`mcp-mobile` / `mcp-re` / `mcp-net` / `mcp-ce` / `mcp-intel` / `mcp-all`）を使用してください。

## セキュリティ境界

このツールセットには、AV/EDR をトリガーする可能性のあるデバッガ、インジェクタ、フック、Frida、パケットキャプチャ、メモリ分析ツールが含まれます。このワークステーションはドライバ / サービス / Npcap / Defender 除外 / レジストリエントリ / スタートアップ項目を**サイレントにインストールしません**。高リスクのサンプルは VM/サンドボックスに置くべきであり、未知のサンプルをホスト上で直接実行してはいけません。**認可された**セキュリティテスト、CTF、研究、教育のみを目的としています。

## ライセンス

- 自社開発の部分（`mcp/debugger-router`、`mcp/bin`、`scripts`、ドキュメント）は [LICENSE](LICENSE)（MIT）の下でライセンスされています。
- サードパーティのツールおよびサードパーティの MCP は、それぞれのアップストリームの著作権とライセンスの下にあります。このリポジトリはそれらのコードやバイナリを一切再配布しません。[DISCLAIMER.md](DISCLAIMER.md) を参照してください。

## コントリビューションとセキュリティ

- コントリビューションを歓迎します — [CONTRIBUTING.md](CONTRIBUTING.md) を参照してください。
- セキュリティ問題を報告するには、[SECURITY.md](SECURITY.md) を参照してください。
- [行動規範](CODE_OF_CONDUCT.md) に従ってください。
