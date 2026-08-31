# Optional private binary cache

This public template **does not** ship third-party binaries (see [DISCLAIMER.md](../DISCLAIMER.md)).

If you keep your **own** private GitHub Release (or disk archive) of official zips:

1. Pack `_download-stage` plus any clickwrap trees you are allowed to keep (not IDA Pro unless you have a license and a private store).
2. On a new machine, clone this skeleton, download that archive, then:

```powershell
powershell -File scripts\restore-from-cache.ps1 -ArchivePath .\debugger-tools-YYYY-MM-DD.7z -Apply
powershell -File scripts\download-tools.ps1 -Apply
```

Free Npcap cannot silent-install (`/S` is OEM-only). The restore script copies the installer; click the GUI once.

Do not attach third-party binaries to **public** GitHub Releases of this template.
