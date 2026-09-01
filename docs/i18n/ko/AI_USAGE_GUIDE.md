# AI 사용 안내

<!-- I18N:START -->
[English](../../AI_USAGE_GUIDE.md) · [简体中文](../zh-CN/AI_USAGE_GUIDE.md) · [日本語](../ja/AI_USAGE_GUIDE.md) · **한국어**
<!-- I18N:END -->

clone 후 에이전트는 **먼저** [AGENTS.ko.md](../../../AGENTS.ko.md)를 읽는다（핸드셰이크 + MCP）.

이 파일은 부트스트랩 이후 읽기 순서입니다. `Reports\`, `OriginalBase\`, 백엔드 `tests\`는 설치 머신에서 만들어지며 뼈대 git에는 없습니다.

## 이 순서로 읽기

1. `AGENTS.ko.md` — 핸드셰이크, 지연 MCP, 고위험 작업.
2. `templates/i18n/ko/INIT_QUESTIONNAIRE.md` — 사용자가 설치를 요청했을 때.
3. `docs/WORKSTATION_RULES.md` — 업데이트 / 정리 / 배포（중국어 운영 규칙. 설치 루트 상대）.
4. `docs/TOOLS_INDEX.md` — 바이너리가 있는 뒤 도구별 명령.
5. `docs/EXPERT_PLAYBOOK.md` — 샘플 분류 플레이북（중국어）.
6. `docs/SMARTCLI.md` — SmartCLI의 CLI. GUI는 라우터.
7. `docs/AGENT_EVOLUTION.md` — 사후 노트.

MCP 템플릿: `mcp/.mcp.json.template`. 생성된 로컬 JSON은 gitignore.

## 기본 MCP

`debugger-router`만. 카탈로그 JSON은 라우터용. `mcp-all`을 사용자 전역 설정에 넣지 않는다.

## 명령

```powershell
pwsh scripts\bootstrap.ps1 -InstallRoot "D:\Tool\debugger"
powershell -File scripts\download-tools.ps1 -Apply
```

Npcap 설치 패키지는 받아도 된다. 드라이버는 조용히 설치하지 않는다. Cheat Engine은 cheatengine.org의 clickwrap.

## AI가 혼자 해도 되는 일

- 문서, 매니페스트, 노트를 읽는다.
- bootstrap 드라이런.
- 작업 후 쌍축 리뷰（`skills/debugger-review`）.

## 확인이 필요한 일

- `-Apply`, `-CloneMcp`, `download-tools.ps1 -Apply`.
- 드라이버, Defender 제외, 호스트에서 샘플 실행.

## 남은 위험

capa zip은 PUA로 막힐 수 있다. IDA Pro는 사용자가 준비. `.env`와 샘플은 커밋하지 않는다.
