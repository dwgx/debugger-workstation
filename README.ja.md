# debugger-workstation

<!-- I18N:START -->
[English](README.md) · [简体中文](README.zh-CN.md) · **日本語** · [한국어](README.ko.md)
<!-- I18N:END -->

ポータブルなリバースエンジニアリング / セキュリティ分析 / デバッグ / 展開 / モバイル分析 / パケットキャプチャ / システム検査 / MCP 自動化のための**雛形リポジトリ**です。

任意の AI エージェント（Claude / Codex / Gemini / Cursor / Copilot / Grok）または人が clone し、[docs/I18N.md](docs/I18N.md) で UI 言語を決め、対応する [AGENTS.md](AGENTS.md)（[日本語](AGENTS.ja.md)）のヒアリングに従えば、自分のマシン上に **AI が操作しやすい** ツールステーションを復元できます。会話はその言語で。git のコミットメッセージは英語のままです。

仕事のあと、エージェントは `skills/debugger-review` で採点し、同じ失敗を繰り返さないよう `notes/` に残します。[docs/AGENT_EVOLUTION.md](docs/AGENT_EVOLUTION.md) を参照。

> ⚠️ **サードパーティ製ツールのバイナリは同梱しません。** `manifests/` と `scripts/bootstrap.ps1` から各公式ソースを辿ります。[DISCLAIMER.ja.md](DISCLAIMER.ja.md) を見てください。

---

## このリポジトリの内容

英語の [README.md](README.md) と同じ表です。エージェント契約の日本語は [AGENTS.ja.md](AGENTS.ja.md)。言語の説明は [docs/i18n/ja/I18N.md](docs/i18n/ja/I18N.md)。

## クイックスタート

```powershell
pwsh scripts\bootstrap.ps1 -InstallRoot "D:\Tool\debugger"
pwsh scripts\bootstrap.ps1 -Apply -CloneMcp -InstallRoot "D:\Tool\debugger"
powershell -File scripts\download-tools.ps1 -Apply
```

ドライランが既定です。Windows PowerShell 5.1 でも動きます（UTF-8 BOM）。PowerShell 7（`pwsh`）を推奨します。

## AI エージェントへ

clone 後、ロケールを解決し、**対応する AGENTS を先に読む**。質問してから `bootstrap.ps1` を実行する。クライアント MCP は `debugger-router` のみ。19 バックエンドをユーザーグローバル MCP に入れない。

## MCP

既定は軽量な `debugger-router` だけです。必要な 19 バックエンドのうち 1 つを起動して終了します。

## セキュリティ

デバッガ、インジェクタ、フック、Frida、キャプチャ、メモリ分析を含み、AV/EDR に掛かることがあります。ドライバ / Npcap / ホスト上の不審サンプルは、影響を短く説明してから意図どおり実行します。**認可された**セキュリティテスト、CTF、研究、教育向けです。

## ライセンス

自作部分は [LICENSE](LICENSE)（MIT）。上流ツールの権利は上流に残ります。
