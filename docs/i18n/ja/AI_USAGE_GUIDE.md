# AI 利用ガイド

<!-- I18N:START -->
[English](../../AI_USAGE_GUIDE.md) · [简体中文](../zh-CN/AI_USAGE_GUIDE.md) · **日本語** · [한국어](../ko/AI_USAGE_GUIDE.md)
<!-- I18N:END -->

clone 後、エージェントは **まず** [AGENTS.ja.md](../../../AGENTS.ja.md) を読む（ヒアリング + MCP）。

本ファイルはブートストラップ後の読み順です。`Reports\`、`OriginalBase\`、バックエンド `tests\` はインストール先で作られ、雛形 git にはありません。

## この順で読む

1. `AGENTS.ja.md` — ヒアリング、遅延 MCP、高リスク操作。
2. `templates/i18n/ja/INIT_QUESTIONNAIRE.md` — ユーザーがインストールを求めたとき。
3. `docs/WORKSTATION_RULES.md` — 更新 / 掃除 / 配布（中文の運用ルール。インストールルート相対）。
4. `docs/TOOLS_INDEX.md` — バイナリがあるあとのツール別コマンド。
5. `docs/EXPERT_PLAYBOOK.md` — サンプル振り分け（中文）。
6. `docs/SMARTCLI.md` — SmartCLI の CLI。GUI はルータ経由。
7. `docs/AGENT_EVOLUTION.md` — 事後ノート。

MCP テンプレート：`mcp/.mcp.json.template`。生成したローカル JSON は gitignore。

## 既定 MCP

`debugger-router` のみ。カタログ JSON はルータ用。`mcp-all` をユーザーグローバル設定に入れない。

## コマンド

```powershell
pwsh scripts\bootstrap.ps1 -InstallRoot "D:\Tool\debugger"
powershell -File scripts\download-tools.ps1 -Apply
```

Npcap インストーラは取ってよい。ドライバは黙って入れない。Cheat Engine は cheatengine.org の clickwrap。

## AI が独断でよいこと

- ドキュメント、マニフェスト、ノートを読む。
- bootstrap のドライラン。
- 仕事のあと双軸レビュー（`skills/debugger-review`）。

## 確認が要ること

- `-Apply`、`-CloneMcp`、`download-tools.ps1 -Apply`。
- ドライバ、Defender 除外、ホスト上のサンプル実行。

## 残りリスク

capa zip は PUA として弾かれることがある。IDA Pro はユーザー用意。`.env` もサンプルもコミットしない。
