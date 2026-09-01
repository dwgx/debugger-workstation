# 初期化ヒアリング（debugger-workstation）

AI：`bootstrap.ps1 -Apply` または `download-tools.ps1 -Apply` の前に聞く。選択肢 + 推奨デフォルト。英語正文：[templates/INIT_QUESTIONNAIRE.md](../../INIT_QUESTIONNAIRE.md)。言語：[docs/i18n/ja/I18N.md](../../../docs/i18n/ja/I18N.md)。

## Q0. UI 言語

エージェントはどの言語で話すか。
- [ ] English（`en`）
- [ ] 简体中文（`zh-CN`）
- [ ] 日本語（`ja`）
- [ ] 한국어（`ko`）
- 推奨：いまのチャットに合わせる。gitignore の `local.json` に `ui_language` を書く。git のコミットメッセージは英語のまま。

## Q1. インストールルート

ステーションはどこに置くか。
- 推奨：`D:\Tool\debugger`（またはこの clone）。
- ラッパー経路と、生成 MCP JSON の `{{DEBUGGER_ROOT}}` に効く。

## Q2. ツール範囲（複数可）

- [ ] static-reversing（Ghidra / PE-bear / ImHex / DIE / capa / FLOSS / YARA-X / ILSpy / dnSpyEx / ReClass.NET / radare2）
- [ ] debuggers（x64dbg / ScyllaHide / GH Injector / Cheat Engine）
- [ ] mobile-android（JADX / Apktool / MobSF / objection）
- [ ] network-http（Reqable / Wireshark）
- [ ] unpackers-game（7-Zip / UniExtract / AssetRipper / Il2CppDumper / GoReSym / pyinstxtractor-ng / UPX）
- [ ] system-forensics（Sysinternals / System Informer / Volatility 3）
- 推奨：全部。

## Q3. MCP バックエンド

- [ ] リポジトリ内の `debugger-router` + `mcp/bin` のみ（既定）
- [ ] サードパーティ MCP を全部 clone（`-CloneMcp`）
- [ ] 指定した部分集合だけ clone
- 聞かれるまで YaraFlux / MobSF / VirusTotal の `.env` は置かない。

## Q4. ツールバイナリ

- [ ] ユーザーが `manifests/tools.json` の公式 URL から取る
- [ ] 許可した `scripts/download-tools.ps1 -Apply`（`gh` 優先）
- 推奨：サードパーティのダウンロード前に確認。

## Q5. バージョン

- [ ] `manifests/tools.json` のピン
- [ ] 公式の最新リリース
- 推奨：ピンを使い、ずれは報告。

## Q6. AI クライアント

- [ ] Claude Code（`CLAUDE.md`）
- [ ] Codex（`AGENTS.md`）
- [ ] Gemini CLI（`GEMINI.md`）
- [ ] Cursor（`.cursor/rules`）
- [ ] GitHub Copilot（`.github/copilot-instructions.md`）
- [ ] Grok

## Q7. システムレベル（既定：なし）

- [ ] Npcap（ライブキャプチャ。無ければオフライン pcap のみ）
- [ ] その他のドライバ / PATH / シェル連携
- 推奨：ポータブルのみ。Npcap は GUI（無料版の `/S` は OEM）。

## Q8. ランタイム

Java（Ghidra / Apktool）、Python ≥3.10、.NET、Node — 検出してから聞く。黙って入れない。

回答のあと短い計画を出し、それから実行する。
