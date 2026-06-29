# 免责声明 / DISCLAIMER

## 关于第三方工具

本仓库(debugger-workstation)是一个**骨架 / bootstrap 仓库**。它**不包含、不分发、不再发布**任何第三方逆向、调试、安全分析工具的源码或二进制,包括但不限于:

Ghidra、x64dbg、ImHex、Detect It Easy、capa、FLOSS、YARA-X、ILSpy、dnSpy/dnSpyEx、ReClass.NET、ScyllaHide、Cheat Engine、JADX、Apktool、MobSF、objection、Reqable、Wireshark、7-Zip、Universal Extractor、AssetRipper、Il2CppDumper、GoReSym、pyinstxtractor-ng、Sysinternals、System Informer 等。

这些工具的**版权、商标和许可均归各自官方 / 作者所有**。本仓库仅在 `manifests/tools.json` 中记录其名称、版本和**官方下载源链接**,由使用者通过 `scripts/bootstrap.ps1` 或手工从官方渠道获取。

## 关于第三方 MCP server

`manifests/mcp-backends.json` 中列出的第三方 MCP backend(ILSpy-Mcp、ReClass.NET-MCP、YaraFlux、apktool-mcp-server、cheatengine-mcp-bridge、dnspy-mcp、dnspy-mcp-extension、frida-mcp、imhexMCP、mcp-wireshark、mcp7zop、mobsf-mcp-server、reqable-mcp 等)的代码**不包含在本仓库中**,其版权和许可归各上游仓库所有。bootstrap 仅按上游 URL 执行 `git clone`。

## 自研部分

仅以下内容为本仓库自研、随仓库分发:
- `mcp/debugger-router/` — 轻量 MCP 路由。
- `mcp/bin/*.cmd` — 后端 MCP 包装脚本。
- `mcp/.mcp.json.template`、`mcp/codex-mcp-config.example.toml` — 配置模板。
- `scripts/`、`docs/`、`manifests/` — 脚本、文档、清单。

其许可见 [LICENSE](LICENSE)。

## 使用责任

- 本工作站面向**授权的安全测试、CTF、安全研究、防御性分析和教育用途**。
- 工具集含调试器、注入器、Hook、抓包、内存分析能力,可能被安全软件拦截,可能违反某些软件的 EULA(如对受保护软件进行逆向)。**使用者须自行确保其行为合法且已获授权。**
- 不要用于未授权的入侵、破解商业软件版权保护、规避反作弊、攻击他人系统等用途。
- 不要在宿主机直接运行未知 / 恶意样本;高风险样本应放隔离 VM/沙箱。

作者不对使用本仓库或据此获取的工具所造成的任何后果负责。
