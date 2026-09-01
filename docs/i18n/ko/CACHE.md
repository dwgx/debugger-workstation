# 선택적 사설 바이너리 캐시

<!-- I18N:START -->
[English](../../CACHE.md) · [简体中文](../zh-CN/CACHE.md) · [日本語](../ja/CACHE.md) · **한국어**
<!-- I18N:END -->

이 공개 템플릿은 서드파티 바이너리를 **포함하지 않습니다**（[DISCLAIMER.ko.md](../../../DISCLAIMER.ko.md)）.

**사적인** GitHub Release（또는 디스크 아카이브）에 공식 zip을 직접 보관한다면:

1. `_download-stage`와 보관 권한이 있는 clickwrap 트리를 묶는다（라이선스와 사설 저장이 없으면 IDA Pro를 넣지 않는다）.
2. 새 머신에서 이 뼈대를 clone하고 그 아카이브를 받은 뒤:

```powershell
powershell -File scripts\restore-from-cache.ps1 -ArchivePath .\debugger-tools-YYYY-MM-DD.7z -Apply
powershell -File scripts\download-tools.ps1 -Apply
```

무료 Npcap은 무인 설치할 수 없다（`/S`는 OEM만）. restore 스크립트는 설치 패키지만 복사한다. GUI를 한 번 누른다.

이 템플릿의 **공개** GitHub Releases에 서드파티 바이너리를 붙이지 않는다.
