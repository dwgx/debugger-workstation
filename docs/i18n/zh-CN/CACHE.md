# 可选的私有二进制缓存

<!-- I18N:START -->
[English](../../CACHE.md) · **简体中文** · [日本語](../ja/CACHE.md) · [한국어](../ko/CACHE.md)
<!-- I18N:END -->

这个公开模板 **不分发** 第三方二进制（见 [DISCLAIMER.zh-CN.md](../../../DISCLAIMER.zh-CN.md)）。

若你自己维护 **私有** GitHub Release（或磁盘归档）存放官方 zip：

1. 打包 `_download-stage`，以及你有权保留的 clickwrap 目录（没有许可证和私有仓库就不要放 IDA Pro）。
2. 新机器上 clone 本骨架，下载该归档，然后：

```powershell
powershell -File scripts\restore-from-cache.ps1 -ArchivePath .\debugger-tools-YYYY-MM-DD.7z -Apply
powershell -File scripts\download-tools.ps1 -Apply
```

免费 Npcap 不能静默安装（`/S` 仅 OEM）。restore 脚本只复制安装包；GUI 点一次。

不要把第三方二进制挂到本模板的 **公开** GitHub Releases。
