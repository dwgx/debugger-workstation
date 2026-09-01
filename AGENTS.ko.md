# AGENTS.md — debugger-workstation

모든 AI 에이전트(Claude Code, Codex, Cursor, Gemini CLI, Copilot, Grok)의 공식 진입점입니다. 초기화하거나 워크스테이션을 다루기 전에 이 파일을 읽으세요.

이 저장소는 **뼈대(skeleton)** 입니다. 서드파티 도구 바이너리는 포함하지 않습니다.

<!-- I18N:START -->
[English](AGENTS.md) · [简体中文](AGENTS.zh-CN.md) · [日本語](AGENTS.ja.md) · **한국어**
<!-- I18N:END -->

언어 규칙은 [docs/i18n/ko/I18N.md](docs/i18n/ko/I18N.md)를 보세요. **사용자가 쓰는 언어로 대화**하고, git 커밋 메시지는 영어로 남깁니다.

---

## 0. 무엇인가

휴대용 리버스 엔지니어링 / 보안 분석 / 디버깅 / 언팩 / 모바일 / 캡처 / 포렌식 / MCP 워크스테이션입니다.

- 도구는 공식 소스에서 가져옵니다: `manifests/` + `scripts/bootstrap.ps1` / `scripts/download-tools.ps1`.
- 이 저장소가 제공하는 것: MCP 라우터(`mcp/debugger-router`), 래퍼(`mcp/bin`), 템플릿, 매니페스트, 문서.
- `README.ko.md`, `DISCLAIMER.ko.md`를 참고하세요.

---

## 1. 초기화 핸드셰이크(물어본 뒤 실행)

사용자가 초기화 / 설치 / 세팅을 요청하면:

### 1단계 — 탐색(읽기 전용)

`README.ko.md`, 이 파일, `manifests/tools.json`, `manifests/mcp-backends.json`, `docs/i18n/ko/AI_USAGE_GUIDE.md`(없으면 영어)를 읽습니다. OS, `git`, `python`(≥3.10), `pwsh`/`powershell`, `dotnet`, `node`, `java`를 탐지합니다. UI 언어: 대화 → `local.json` `ui_language` → OS UI → `en`.

### 2단계 — 질문(필수)

`templates/i18n/ko/INIT_QUESTIONNAIRE.md`를 사용합니다. 최소한:

0. **UI 언어**(en / zh-CN / ja / ko). 대화가 이미 한국어면 생략 가능. 그래도 `local.json`의 `ui_language`에는 쓴다.
1. **설치 루트**(기본 `D:\Tool\debugger`).
2. **범위**: 전체 또는 일부 분류.
3. **MCP 백엔드**: 라우터만, 또는 `-CloneMcp` (`.env` 서비스는 묻기 전까지 생략).
4. **바이너리**: 사용자가 받거나, 허가 후 `download-tools.ps1 -Apply`.
5. **버전**: 매니페스트 핀 vs 공식 최신.
6. **AI 클라이언트**.
7. **시스템 수준**: Npcap / 드라이버(기본 아니오).

### 3단계 — 계획

디렉터리, clone, 다운로드, 생성할 설정을 나열하고 확인을 기다립니다.

### 4단계 — 실행(확인 후)

1. `pwsh scripts/bootstrap.ps1 -InstallRoot "<root>"` (드라이런).
2. `-Apply` (라우터 + 로컬 MCP JSON).
3. 선택적 `-CloneMcp`.
4. 허가 후 `powershell -File scripts/download-tools.ps1 -Apply`.
5. 첫 bootstrap에서 백엔드 19개의 환경을 모두 만들지 마세요. 라우터가 필요할 때만 띄웁니다.
6. 스모크: `capa.exe --version` 등. Defender가 capa를 막으면 `notes/`에 적고 설치된 척하지 마세요.
7. `skills/debugger-review`로 마무리.

Windows에서 `InstallRoot`가 이 clone이면 `mcp\`와 `MCP\`는 같은 폴더입니다. 자기 자신으로 복사하지 마세요.

### 5단계 — 보고

설치된 것, 건너뛴 것, 남은 위험. 한국어 사용자에게는 한국어로.

---

## 2. MCP 정책

- 클라이언트 기본은 **`debugger-router`만**. 19개 중 필요한 하나를 켜고 종료합니다.
- 전부를 기본으로 올리지 마세요. 직접 프로필: `mcp-mobile` / `mcp-re` / `mcp-net` / `mcp-ce` / `mcp-intel` / `mcp-all`.
- 템플릿: `mcp/.mcp.json.template`, `mcp/codex-mcp-config.example.toml` (`{{DEBUGGER_ROOT}}`).
- Claude / Codex / Cursor / Grok **사용자 전역** MCP에 19개를 넣지 마세요.
- 업스트림 목록: `manifests/mcp-backends.json`.
- 호스트에 이미 IDA MCP(idalib)가 있으면 두 번째 IDA 서버를 추가하지 마세요.

---

## 3. 명령

영어 [AGENTS.md](AGENTS.md)의 PowerShell 블록과 같습니다.

선택적 비공개 zip 캐시(공개 clone에는 불필요): `scripts/restore-from-cache.ps1`.

---

## 4. 고위험 작업

영향과 롤백을 짧게 설명한 뒤 의도대로 실행합니다. 거부하지도, 드라이버를 조용히 설치하지도 마세요.

- 드라이버, 서비스, Npcap, Defender 제외, 레지스트리, 시작 프로그램, 작업 스케줄러.
- 호스트에서 의심 샘플 실행(VM 제안, 결정은 사용자).
- 서드파티 바이너리 다운로드, 대량 clone, 설치 루트 밖 쓰기.

저장소 규칙: git에 서드파티 바이너리 없음. `.env` / pcap / dump 커밋 금지. 허가된 보안 테스트·CTF·연구·교육만.

---

## 5–6. 배치와 회고

영어 [AGENTS.md](AGENTS.md)와 같습니다. 노트는 `notes/`. 점수는 gitignore된 `Reports/`에도 둘 수 있습니다.

---

## 7. 언어

- **대화**: 사용자와 같은 언어(이 파일은 한국어). gitignore된 `local.json`에 `ui_language`를 남긴다.
- **공개 git**: 영어가 정본. 이것은 한국어 번역.
- **경로**: 절대 경로 또는 설치 루트 상대.
