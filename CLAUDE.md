# CLAUDE.md

Claude Code 入口。完整规则见 AGENTS.md(权威入口),此处导入:

@AGENTS.md

## Claude 专属补充

- clone 本仓库后,若用户要求初始化/搭建工作站,**先进入 plan mode**(只读探索)执行 AGENTS.md 第 1 节的初始化握手:探索 → 提问 → 计划 → 经用户确认后再 ExitPlanMode 执行。
- 默认中文回答。
- bootstrap、下载二进制、clone 第三方 MCP 前,按 AGENTS.md 第 4 节边界处理;系统级动作必须先确认。
- 可用 `templates/INIT_QUESTIONNAIRE.md` 作为提问清单的蓝本。
