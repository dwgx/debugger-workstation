# 초기화 설문（debugger-workstation）

AI: `bootstrap.ps1 -Apply` 또는 `download-tools.ps1 -Apply` 전에 묻는다. 선택지 + 권장 기본값. 영어 정본: [templates/INIT_QUESTIONNAIRE.md](../../INIT_QUESTIONNAIRE.md). 언어: [docs/i18n/ko/I18N.md](../../../docs/i18n/ko/I18N.md).

## Q0. UI 언어

에이전트는 어떤 언어로 대화하는가?
- [ ] English（`en`）
- [ ] 简体中文（`zh-CN`）
- [ ] 日本語（`ja`）
- [ ] 한국어（`ko`）
- 권장: 지금 채팅 언어에 맞춘다. gitignore된 `local.json`의 `ui_language`에 저장. git 커밋 메시지는 영어.

## Q1. 설치 루트

워크스테이션을 어디에 둘 것인가?
- 권장: `D:\Tool\debugger`（또는 이 clone）.
- 래퍼 경로와 생성 MCP JSON의 `{{DEBUGGER_ROOT}}`에 영향을 준다.

## Q2. 도구 범위（복수 선택）

- [ ] static-reversing（Ghidra / PE-bear / ImHex / DIE / capa / FLOSS / YARA-X / ILSpy / dnSpyEx / ReClass.NET / radare2）
- [ ] debuggers（x64dbg / ScyllaHide / GH Injector / Cheat Engine）
- [ ] mobile-android（JADX / Apktool / MobSF / objection）
- [ ] network-http（Reqable / Wireshark）
- [ ] unpackers-game（7-Zip / UniExtract / AssetRipper / Il2CppDumper / GoReSym / pyinstxtractor-ng / UPX）
- [ ] system-forensics（Sysinternals / System Informer / Volatility 3）
- 권장: 전부.

## Q3. MCP 백엔드

- [ ] 저장소 안의 `debugger-router` + `mcp/bin`만（기본）
- [ ] 서드파티 MCP 전부 clone（`-CloneMcp`）
- [ ] 지정한 부분집합만 clone
- 묻기 전에는 YaraFlux / MobSF / VirusTotal `.env`를 만들지 않는다.

## Q4. 도구 바이너리

- [ ] 사용자가 `manifests/tools.json` 공식 URL에서 직접 받음
- [ ] 허가된 `scripts/download-tools.ps1 -Apply`（`gh` 우선）
- 권장: 서드파티 다운로드 전에 확인.

## Q5. 버전

- [ ] `manifests/tools.json` 핀
- [ ] 공식 최신 릴리스
- 권장: 핀을 쓰고 드리프트를 보고.

## Q6. AI 클라이언트

- [ ] Claude Code（`CLAUDE.md`）
- [ ] Codex（`AGENTS.md`）
- [ ] Gemini CLI（`GEMINI.md`）
- [ ] Cursor（`.cursor/rules`）
- [ ] GitHub Copilot（`.github/copilot-instructions.md`）
- [ ] Grok

## Q7. 시스템 수준（기본: 없음）

- [ ] Npcap（실시간 캡처. 없으면 오프라인 pcap만）
- [ ] 기타 드라이버 / PATH / 셸 연동
- 권장: 포터블만. Npcap은 GUI（무료판 `/S`는 OEM）.

## Q8. 런타임

Java（Ghidra / Apktool）, Python ≥3.10, .NET, Node — 감지한 뒤 묻는다. 조용히 설치하지 않는다.

답을 받은 뒤 짧은 계획을 쓰고 실행한다.
