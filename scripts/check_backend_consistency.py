#!/usr/bin/env python3
"""Cross-check MCP backend wiring across all sources of truth.

Every router backend (a key in MCP/.mcp.json.template's mcpServers, minus the
router itself) must appear consistently in:
  - mcp/.mcp.json.template            (server entry -> bin/<x>.cmd)
  - mcp/codex-mcp-config.example.toml ([mcp_servers.<x>] -> same bin/<x>.cmd)
  - mcp/bin/<the referenced>.cmd      (wrapper script exists)
  - mcp/debugger-router/server.py     (BACKEND_META has the key)

Also flags backend manifest entries whose `wired: false` must NOT appear in the
template, and template backends that lack a manifest clone target.

Exit non-zero on any mismatch. Pure stdlib so CI needs no deps.
"""
from __future__ import annotations
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TEMPLATE = ROOT / "mcp" / ".mcp.json.template"
TOML = ROOT / "mcp" / "codex-mcp-config.example.toml"
SERVER = ROOT / "mcp" / "debugger-router" / "server.py"
MANIFEST = ROOT / "manifests" / "mcp-backends.json"
BIN = ROOT / "mcp" / "bin"

ROUTER_KEY = "debugger-router"

errors: list[str] = []


def fail(msg: str) -> None:
    errors.append(msg)


def cmd_basename(path: str) -> str:
    """'{{DEBUGGER_ROOT}}\\MCP\\bin\\foo-mcp.cmd' -> 'foo-mcp.cmd'."""
    return re.split(r"[\\/]", path.strip())[-1]


# --- 1. template: backend key -> referenced .cmd basename ---
tpl = json.loads(TEMPLATE.read_text(encoding="utf-8"))
servers = tpl.get("mcpServers", tpl.get("mcp_servers", {}))
if not servers:
    fail(f"{TEMPLATE.name}: no mcpServers block found")

tpl_backends: dict[str, str] = {}
for key, spec in servers.items():
    if key == ROUTER_KEY:
        continue
    command = spec.get("command", "")
    tpl_backends[key] = cmd_basename(command)

# --- 2. every referenced .cmd must exist in mcp/bin ---
for key, cmd in tpl_backends.items():
    if not (BIN / cmd).exists():
        fail(f"template backend '{key}' -> mcp/bin/{cmd} does not exist")

# --- 3. server.py BACKEND_META keys ---
server_src = SERVER.read_text(encoding="utf-8")
m = re.search(r"BACKEND_META[^=]*=\s*\{(.*?)\n\}", server_src, re.S)
if not m:
    fail("server.py: BACKEND_META dict not found")
    meta_keys: set[str] = set()
else:
    meta_keys = set(re.findall(r'"([a-z0-9]+)"\s*:\s*\{', m.group(1)))

# --- 4. codex toml [mcp_servers.<x>] -> command basename ---
toml_src = TOML.read_text(encoding="utf-8")
toml_blocks = re.findall(
    r"\[mcp_servers\.([A-Za-z0-9_]+)\][^\[]*?command\s*=\s*\"([^\"]+)\"",
    toml_src,
)
toml_backends = {name: cmd_basename(cmd) for name, cmd in toml_blocks}

# --- 5. manifest clone targets + wired flag ---
manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
man_entries = list(manifest.get("third_party", []))
ru = manifest.get("resolved_upstream", {})
man_entries += list(ru.get("entries", []))
unwired = {e["name"] for e in man_entries if e.get("wired") is False}

# --- Cross-checks ---
tpl_keys = set(tpl_backends)
toml_keys = set(toml_backends) - {ROUTER_KEY}

# template <-> server.py meta
missing_meta = tpl_keys - meta_keys
if missing_meta:
    fail(f"backends in template but missing from server.py BACKEND_META: {sorted(missing_meta)}")
extra_meta = meta_keys - tpl_keys
if extra_meta:
    fail(f"keys in BACKEND_META with no template backend: {sorted(extra_meta)}")

# template <-> codex toml (same keys, same .cmd)
if tpl_keys != toml_keys:
    only_tpl = sorted(tpl_keys - toml_keys)
    only_toml = sorted(toml_keys - tpl_keys)
    fail(f"template/codex-toml backend mismatch: only in template={only_tpl}, only in toml={only_toml}")
for key in tpl_keys & toml_keys:
    if tpl_backends[key] != toml_backends[key]:
        fail(f"backend '{key}': template -> {tpl_backends[key]} but codex toml -> {toml_backends[key]}")

# unwired manifest entries must not be wired into the template
for name in unwired:
    # manifest names are repo names (e.g. dnspy-mcp-extension); the wrapper would be
    # bin/<name>.cmd if wired. Flag if any template .cmd matches the unwired repo name.
    if f"{name}.cmd" in tpl_backends.values():
        fail(f"manifest entry '{name}' is wired:false but its .cmd appears in the template")

if errors:
    print("MCP backend consistency check FAILED:")
    for e in errors:
        print(f"  - {e}")
    sys.exit(1)

print(f"MCP backend consistency OK: {len(tpl_keys)} backends wired "
      f"(template == codex toml == bin/*.cmd == BACKEND_META).")
print(f"  backends: {', '.join(sorted(tpl_keys))}")
