# debugger-workstation

[English](README.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · **Русский**

**Каркасный репозиторий** (skeleton repository) для портативной рабочей станции для реверс-инжиниринга / анализа безопасности / отладки / распаковки / анализа мобильных приложений / захвата сетевого трафика / инспекции системы / автоматизации MCP.

Любой AI agent (Claude / Codex / Gemini / Cursor / Copilot) или человек может склонировать этот репозиторий и воссоздать на своей машине станцию инструментов, **оптимизированную для управления через AI** — следуя приведённым здесь документам и манифестам.

> ⚠️ **Этот репозиторий не поставляет никаких бинарных файлов сторонних инструментов.** Инструменты загружаются из официальных источников через `manifests/` + `scripts/bootstrap.ps1`. См. [DISCLAIMER.md](DISCLAIMER.md).

---

## Что находится в этом репозитории

| Путь | Содержимое |
| --- | --- |
| `AGENTS.md` | **Авторитетная точка входа** для всех AI agent — рукопожатие инициализации (ask-then-act), стратегия MCP, границы. |
| `CLAUDE.md` / `GEMINI.md` / `.github/copilot-instructions.md` / `.cursor/rules/` | Файлы входа для каждого клиента, все указывают на `AGENTS.md`. |
| `templates/INIT_QUESTIONNAIRE.md` | Чек-лист уточняющих вопросов, управляющий динамической инициализацией. |
| `docs/` | Документы для людей и AI (обезличенные на основе исходных правил рабочей станции). |
| `docs/extensions/INDEX.md` | Кураторский индекс MCP-серверов / AI skill, которые можно добавить. |
| `manifests/tools.json` | Манифест инструментов: имя, версия, официальный источник загрузки, путь установки. |
| `manifests/mcp-backends.json` | Апстримы сторонних MCP-бэкендов + собственное ядро. |
| `mcp/debugger-router/server.py` | **Собственный** лёгкий MCP-роутер (запускает бэкенды по требованию; единственный MCP, включённый по умолчанию). |
| `mcp/bin/*.cmd` | **Собственные** скрипты-обёртки бэкенд-MCP (относительные пути, портативные). |
| `mcp/.mcp.json.template` | Шаблон конфигурации MCP; bootstrap подставляет `{{DEBUGGER_ROOT}}`. |
| `scripts/bootstrap.ps1` | Воссоздаёт рабочую станцию из манифестов (по умолчанию dry-run). |

**Не включено** (жёстко исключено через `.gitignore`): бинарные файлы инструментов, `.env`/учётные данные, `.venv`/`node_modules`/среды выполнения, образцы/pcap/дампы, временные рабочие пространства, локальная история git.

## Быстрый старт

```powershell
# 1. dry-run: show the plan only, no writes, no downloads
pwsh scripts\bootstrap.ps1 -InstallRoot "D:\Tool\debugger"

# 2. once the plan looks right: deploy the self-developed MCP, generate local config, clone third-party MCPs
pwsh scripts\bootstrap.ps1 -Apply -CloneMcp -InstallRoot "D:\Tool\debugger"

# 3. download tool binaries to their category folders from the official sources listed in the dry-run
#    (this repo does not download third-party tool binaries for you)

# 4. rebuild each third-party MCP's .venv / dotnet / node dependencies, then smoke-test
```

> Windows PowerShell 5.1 также работает (скрипт в кодировке UTF-8 BOM). Предпочтительнее PowerShell 7 (`pwsh`).

## Для AI agent: прочитайте это в первую очередь

После клонирования **сначала прочитайте [AGENTS.md](AGENTS.md)** (авторитетная точка входа, включая протокол рукопожатия инициализации). Точки входа для каждого клиента — Claude→`CLAUDE.md`, Gemini→`GEMINI.md`, Cursor→`.cursor/rules/`, Copilot→`.github/copilot-instructions.md` — все указывают на `AGENTS.md`.

Ключевая идея: когда AI просят настроить рабочую станцию, он **не действует немедленно**. Он исследует (только чтение), задаёт уточняющие вопросы (корень установки, область действия, какие MCP, нужно ли загружать бинарники, AI-клиент, компоненты системного уровня), представляет план и только затем — после вашего подтверждения — запускает `bootstrap.ps1`.

Дополнительное чтение:
1. [AGENTS.md](AGENTS.md) — **авторитетная точка входа**: рукопожатие, стратегия MCP, границы.
2. [templates/INIT_QUESTIONNAIRE.md](templates/INIT_QUESTIONNAIRE.md) — чек-лист уточняющих вопросов.
3. [docs/AI_USAGE_GUIDE.md](docs/AI_USAGE_GUIDE.md) — порядок чтения, что AI может делать самостоятельно.
4. [docs/WORKSTATION_RULES.md](docs/WORKSTATION_RULES.md) — полные правила рабочей станции, процесс обновления/очистки.
5. [manifests/](manifests/) — манифесты инструментов и MCP.
6. [docs/extensions/INDEX.md](docs/extensions/INDEX.md) — расширения, которые можно добавить.

## Стратегия MCP

По умолчанию включён только `debugger-router` — один лёгкий MCP. Он по требованию поднимает тот из 19 бэкендов, который нужен, и завершается по окончании работы. Не загружайте все бэкенды сразу по умолчанию. Для прямых подключений используйте профиль (`mcp-mobile` / `mcp-re` / `mcp-net` / `mcp-ce` / `mcp-intel` / `mcp-all`).

## Границы безопасности

Набор инструментов включает отладчики, инжекторы, хуки, Frida, захват пакетов и инструменты анализа памяти, которые могут срабатывать на AV/EDR. Эта рабочая станция **не** устанавливает молча драйверы / службы / Npcap / исключения Defender / записи реестра / элементы автозагрузки. Высокорисковые образцы должны находиться в VM/песочнице — никогда не запускайте неизвестные образцы напрямую на хосте. Предназначено только для **авторизованного** тестирования безопасности, CTF, исследований и обучения.

## Лицензия

- Собственные части (`mcp/debugger-router`, `mcp/bin`, `scripts`, документация) лицензированы под [LICENSE](LICENSE) (MIT).
- Сторонние инструменты и сторонние MCP остаются под авторским правом и лицензией соответствующих апстримов; этот репозиторий не распространяет их код или бинарные файлы. См. [DISCLAIMER.md](DISCLAIMER.md).

## Вклад и безопасность

- Вклад приветствуется — см. [CONTRIBUTING.md](CONTRIBUTING.md).
- Чтобы сообщить о проблеме безопасности, см. [SECURITY.md](SECURITY.md).
- Пожалуйста, соблюдайте наш [Кодекс поведения](CODE_OF_CONDUCT.md).
