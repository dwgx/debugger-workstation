# debugger-workstation

<!-- I18N:START -->
[English](README.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · **한국어**
<!-- I18N:END -->

휴대용 리버스 엔지니어링 / 보안 분석 / 디버깅 / 언팩 / 모바일 분석 / 패킷 캡처 / 시스템 점검 / MCP 자동화를 위한 **뼈대 저장소**입니다.

아무 AI 에이전트(Claude / Codex / Gemini / Cursor / Copilot / Grok)나 사람이 clone한 뒤 [docs/I18N.md](docs/I18N.md)로 UI 언어를 정하고, 맞는 [AGENTS.md](AGENTS.md)([한국어](AGENTS.ko.md)) 핸드셰이크를 따르면 자기 머신에 **AI가 다루기 쉬운** 도구 스테이션을 복원할 수 있습니다. 대화는 그 언어로, git 커밋 메시지는 영어입니다.

작업 후 에이전트는 `skills/debugger-review`로 점수를 매기고 `notes/`에 남깁니다. [docs/AGENT_EVOLUTION.md](docs/AGENT_EVOLUTION.md).

> ⚠️ **서드파티 도구 바이너리는 포함하지 않습니다.** `manifests/`와 `scripts/bootstrap.ps1`로 각 공식 소스를 따릅니다. [DISCLAIMER.ko.md](DISCLAIMER.ko.md).

---

## 이 저장소에 있는 것

표는 영어 [README.md](README.md)와 같습니다. 한국어 에이전트 계약은 [AGENTS.ko.md](AGENTS.ko.md). 언어 설명은 [docs/i18n/ko/I18N.md](docs/i18n/ko/I18N.md).

## 빠른 시작

```powershell
pwsh scripts\bootstrap.ps1 -InstallRoot "D:\Tool\debugger"
pwsh scripts\bootstrap.ps1 -Apply -CloneMcp -InstallRoot "D:\Tool\debugger"
powershell -File scripts\download-tools.ps1 -Apply
```

기본은 드라이런입니다. Windows PowerShell 5.1도 됩니다(UTF-8 BOM). PowerShell 7(`pwsh`)을 권장합니다.

## AI 에이전트에게

clone 후 로케일을 정하고 **해당 AGENTS를 먼저 읽으세요**. 질문한 뒤에 `bootstrap.ps1`을 실행합니다. 클라이언트 MCP는 `debugger-router`만. 백엔드 19개를 사용자 전역 MCP에 넣지 마세요.

## MCP

기본은 가벼운 `debugger-router` 하나입니다. 필요한 백엔드 하나를 켜고 끝냅니다.

## 보안

디버거, 인젝터, 훅, Frida, 캡처, 메모리 분석이 들어 있어 AV/EDR에 걸릴 수 있습니다. 드라이버 / Npcap / 호스트의 의심 샘플은 영향을 짧게 설명한 뒤 의도대로 실행합니다. **허가된** 보안 테스트, CTF, 연구, 교육용입니다.

## 라이선스

자체 작성 부분은 [LICENSE](LICENSE)(MIT). 업스트림 도구의 권리는 업스트림에 남습니다.
