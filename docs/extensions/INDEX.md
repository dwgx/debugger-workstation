# 扩展资源索引 (Extensions Index)

本文件汇总可纳入本工作站的 **MCP server**、**AI skill** 和相关扩展资源,供任何接手的 AI 评估与按需引入。

> 原则:这里只是 **curated 候选清单 + 上游链接**,本仓库不打包第三方代码/二进制。
> 引入任一项前,先联网核验上游当前状态(是否维护、license、安全性),再决定 clone/集成。
> 所有链接均为公开官方/社区仓库,可正常联网核验。

最近核验:2026-06-29

---

## 1. 本工作站已集成的第三方 MCP backend

详见 `manifests/mcp-backends.json`:13 个 `third_party`(ILSpy/ReClass/YaraFlux/Apktool/CheatEngine/dnSpy×2/Frida/ImHex/Wireshark/7-Zip/MobSF/Reqable)+ 4 个 `resolved_upstream`(GhidraMCP/jadx-mcp-server/x64dbg-automate/x64dbg-automate-pyclient)+ 自研 router/bin。

## 2. 候选 MCP server (逆向 / 安全方向,可评估替换或补充)

### Ghidra 系 (任选其一作为 ghidra backend,功能差异较大)
| 项目 | 上游 | 说明 |
| --- | --- | --- |
| LaurieWired/GhidraMCP | https://github.com/LaurieWired/GhidraMCP | 社区热门,GUI 插件型,工具数中等。 |
| 0xflux/ghidra-mcp | https://github.com/0xflux/ghidra-mcp | production-grade,179 工具,GUI+headless,支持 Ghidra Server、批量、Docker。 |
| bethington/ghidra-mcp | https://github.com/bethington/ghidra-mcp | 200+ 工具,lazy loading,批量操作。 |
| cyberkaida/reverse-engineering-assistant | https://github.com/cyberkaida/reverse-engineering-assistant | Ghidra RE 任务向。 |
| 13bm/GhidraMCP | https://github.com/13bm/GhidraMCP | 70 工具,轻量。 |

> 本工作站 `MCP/GhidraMCP` 上游已确认为 **LaurieWired/GhidraMCP (Apache-2.0)**,记录于 manifest `resolved_upstream`(见第 5 节)。如需更多工具数,可评估上面的 0xflux / bethington fork 替换。

### 其他方向 (按需评估)
| 方向 | 项目 | 上游 |
| --- | --- | --- |
| 多后端 RE 聚合 | president-xd/revula | https://mcpservers.org/servers/president-xd/revula |
| headless 全项目分析 | pyghidra-mcp | https://github.com/clearbluejar/pyghidra-mcp (核验) |

## 3. AI Skill 资源 (Claude Code / agent skills)

| 项目 | 上游 | 与本工作站的关系 |
| --- | --- | --- |
| travisvn/awesome-claude-skills | https://github.com/travisvn/awesome-claude-skills | Claude skill 总索引,从这里发现新 skill。 |
| Masriyan/Claude-Code-CyberSecurity-Skill | https://github.com/Masriyan/Claude-Code-CyberSecurity-Skill | 15 个安全 skill(攻防/RE/威胁狩猎/CSOC),可对照本工作站工具映射。 |
| incogbyte/android-reverse-engineering-claude-skill | https://github.com/incogbyte/android-reverse-engineering-claude-skill | Android RE 自动化 skill,可与本站 JADX/Apktool/Frida/MobSF 链路配合。 |
| ljagiello/ctf-skills | https://github.com/ljagiello/ctf-skills | CTF 向 (pwn/crypto/RE/forensics/OSINT)。 |

> 引入 skill 前注意:第三方 skill 可能包含可执行指令,使用前审阅其 SKILL.md / 脚本,避免引入会执行高危动作的 skill。

## 4. 引入新扩展的流程

1. 联网核验上游:是否活跃维护、star/issue、license、有无安全告警。
2. 评估与现有 backend 是否重复或更优。
3. 若引入 MCP backend:在 `manifests/mcp-backends.json` 增加条目(name/git/path/category/build/license),并在 `mcp/.mcp.json.template` 与 `codex-mcp-config.example.toml` 增加 enabled=false 的入口,再加对应 `mcp/bin/<name>.cmd` 包装脚本。
4. 若引入 skill:记录到本文件,并在工作站文档说明触发场景。
5. 第三方代码/二进制不入本仓库,只记录上游,由 bootstrap 按需拉取。

## 5. 待办 / 观察

- [x] 确认 `MCP/GhidraMCP` 实际上游 → **LaurieWired/GhidraMCP (Apache-2.0)**,已写入 manifest `resolved_upstream`。
- [x] 确认 `jadx-mcp-server` → **zinja-coder/jadx-mcp-server (Apache-2.0)**,需配 jadx-ai-mcp 插件。
- [x] 确认 `x64dbg-automate` / `x64dbg-automate-pyclient` → **dariushoule/* (MIT)**。
- [ ] 评估是否用 bethington/ghidra-mcp(LaurieWired fork,工具数更多)升级 Ghidra backend。

---

## 6. 候选新 MCP server(2026-06-29 联网核验,补充现有工具链缺口)

> 以下为本工作站当前**没有**的方向,star/活跃度为核验时读数。纳入前回到上游核验当前状态。

### 逆向 / 二进制分析(补 IDA / radare2 / Binary Ninja)
| 项目 | 上游 | 说明 |
| --- | --- | --- |
| mrexodia/ida-pro-mcp | https://github.com/mrexodia/ida-pro-mcp | 事实标准 IDA Pro MCP(~9.7k star),反编译/xref/重命名/调试。补齐 IDA 侧。 |
| blacktop/ida-mcp-rs | https://github.com/blacktop/ida-mcp-rs | Rust headless IDA MCP,适合批量/CI 逆向。 |
| radareorg/radare2-mcp | https://github.com/radareorg/radare2-mcp | radare2 官方维护 stdio MCP,免费开源补充。 |
| fosdickio/binary_ninja_mcp | https://github.com/fosdickio/binary_ninja_mcp | 主流 Binary Ninja MCP(插件+HTTP bridge)。 |
| mrphrazer/binary-ninja-headless-mcp | https://github.com/mrphrazer/binary-ninja-headless-mcp | headless Binary Ninja,180 工具,粒度最细。 |
| sjkim1127/Reversecore_MCP | https://github.com/sjkim1127/Reversecore_MCP | 单 server 聚合 Radare2+YARA+LIEF+Capstone,security-first。 |

### 网络 / 取证 / 情报(补内存取证 / 威胁情报 / 解码)
| 项目 | 上游 | 说明 |
| --- | --- | --- |
| 0xKoda/WireMCP | https://github.com/0xKoda/WireMCP | tshark 实时流量 MCP(star 高,但更新偏慢)。 |
| slouchd/cyberchef-api-mcp-server | https://github.com/slouchd/cyberchef-api-mcp-server | 接 CyberChef-server,300+ 编解码/加解密。 |
| bornpresident/Volatility-MCP-Server | https://github.com/bornpresident/Volatility-MCP-Server | Volatility3 内存取证 MCP(补当前缺口;更新偏静态)。 |
| w0h1v/mcp-virustotal | https://github.com/w0h1v/mcp-virustotal | VirusTotal API MCP,样本/URL/IP/域名情报关联。 |

> 注:未找到有维护、有 star 的独立 Cuckoo/CAPE 沙箱 MCP,故不列。

## 7. 候选新 Skill(2026-06-29 核验)

| 项目 | 上游 | 说明 |
| --- | --- | --- |
| elementalsouls/Claude-BugHunter | https://github.com/elementalsouls/Claude-BugHunter | star 最高的安全 skill 集(~2.7k),71 skills + 15 命令 + 漏洞披露模式库。 |
| Eyadkelleh/awesome-skills-security | https://github.com/Eyadkelleh/awesome-skills-security | 实战 pentest/CTF/赏金:SecLists 词表 + 注入 payload + agent。 |
| gl0bal01/malware-analysis-claude-skills | https://github.com/gl0bal01/malware-analysis-claude-skills | 5 个恶意分析 skill,适配 REMnux/FlareVM,直接对口本站。 |
| mahmutka/cybersecurity-claude-skills | https://github.com/mahmutka/cybersecurity-claude-skills | web hacking / 审计 / CTF solver(star 少,先审 SKILL.md)。 |

## 8. 持续发现入口(awesome 聚合)

| 项目 | 上游 | 说明 |
| --- | --- | --- |
| punkpeye/awesome-mcp-servers | https://github.com/punkpeye/awesome-mcp-servers | 最大 MCP 聚合榜,发现新 MCP 首选。 |
| modelcontextprotocol/servers | https://github.com/modelcontextprotocol/servers | MCP 官方参考 server 仓库,判断协议规范。 |
| appcypher/awesome-mcp-servers | https://github.com/appcypher/awesome-mcp-servers | 大型分类列表,交叉核对。 |
| MorDavid/awesome-cyber-security-mcp | https://github.com/MorDavid/awesome-cyber-security-mcp | 安全垂直 MCP 聚合(当线索源)。 |
| R00T-Kim/awesome-offensive-mcp | https://github.com/R00T-Kim/awesome-offensive-mcp | 攻击/红队方向 MCP(当线索源)。 |
| tylerha97/awesome-reversing | https://github.com/tylerha97/awesome-reversing | 经典逆向资源大全(偏经典工具,非 MCP)。 |
