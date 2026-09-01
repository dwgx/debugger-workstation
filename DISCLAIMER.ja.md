# 免責事項

<!-- I18N:START -->
[English](DISCLAIMER.md) · [简体中文](DISCLAIMER.zh-CN.md) · **日本語** · [한국어](DISCLAIMER.ko.md)
<!-- I18N:END -->

## サードパーティ製ツール

**debugger-workstation** は**雛形 / ブートストラップ**です。サードパーティのリバースエンジニアリング・デバッグ・セキュリティツールのソースやバイナリを**含みません、配布しません、再発行しません**。例：Ghidra、IDA Pro、radare2、x64dbg、ImHex、capa、Cheat Engine、JADX、Wireshark、7-Zip など（英語版の列挙と同じ）。

**IDA Pro は Hex-Rays の商用ソフトウェア**です。ライセンスは自分で買い、公式から入れます。本リポジトリは IDA 本体を配らず、ライセンス回避もしません。

著作権・商標・ライセンスは各公式に残ります。ここにあるのは `manifests/tools.json` の名前・版・**公式 URL** だけです。

## サードパーティ MCP

`manifests/mcp-backends.json` のコードは git にありません。bootstrap は上流 URL を `git clone` するだけです。**VirusTotal MCP** は IOC を VirusTotal の公開 API に送り、`VIRUSTOTAL_API_KEY` が必要です。認可された調査に限り、機微サンプルを上げないでください。

## 自作部分

`mcp/debugger-router/`、`mcp/bin/*.cmd`、テンプレート、`scripts/`、`docs/`、`manifests/`。[LICENSE](LICENSE) を参照。

## 利用責任

**認可された**セキュリティテスト、CTF、研究、防御分析、教育向けです。未認可の侵入、商用ソフトの保護回避、チート対策回避、他人のシステム攻撃に使わないでください。未知 / マルウェアはホストで走らせず、隔離 VM を使ってください。著者は結果について責任を負いません。
