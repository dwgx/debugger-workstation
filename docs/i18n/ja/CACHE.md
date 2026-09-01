# 任意の私有バイナリキャッシュ

<!-- I18N:START -->
[English](../../CACHE.md) · [简体中文](../zh-CN/CACHE.md) · **日本語** · [한국어](../ko/CACHE.md)
<!-- I18N:END -->

この公開テンプレートはサードパーティバイナリを **同梱しません**（[DISCLAIMER.ja.md](../../../DISCLAIMER.ja.md)）。

自分用の **私有** GitHub Release（またはディスクアーカイブ）に公式 zip を置くなら：

1. `_download-stage` と、保持してよい clickwrap ツリーを固める（ライセンスと私有保管が無ければ IDA Pro は入れない）。
2. 新しいマシンでこの雛形を clone し、そのアーカイブを取って：

```powershell
powershell -File scripts\restore-from-cache.ps1 -ArchivePath .\debugger-tools-YYYY-MM-DD.7z -Apply
powershell -File scripts\download-tools.ps1 -Apply
```

無料 Npcap はサイレントインストールできない（`/S` は OEM のみ）。restore はインストーラをコピーするだけ。GUI を一度押す。

このテンプレートの **公開** GitHub Releases にサードパーティバイナリを付けない。
