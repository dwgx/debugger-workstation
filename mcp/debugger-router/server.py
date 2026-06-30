import asyncio
import json
import os
import time
from pathlib import Path
from typing import Any

from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client
from mcp.server.fastmcp import FastMCP


# ROOT resolves to the actual install path: DEBUGGER_ROOT env var wins, else the
# directory two levels above this file (MCP/debugger-router/server.py -> root).
ROOT = Path(os.environ.get("DEBUGGER_ROOT", Path(__file__).resolve().parents[2])).resolve()
# CANONICAL_ROOT is only used to translate legacy absolute paths that may appear
# in a .mcp.json authored on the original install. Distributed configs use the
# {{DEBUGGER_ROOT}} template instead, so this rarely matters. Override with
# DEBUGGER_CANONICAL_ROOT if your config carries a different hardcoded prefix.
CANONICAL_ROOT = Path(os.environ.get("DEBUGGER_CANONICAL_ROOT", r"D:\Tool\debugger"))
MCP_ROOT = ROOT / "MCP"
BACKEND_CONFIG = MCP_ROOT / ".mcp.json"

BACKEND_META: dict[str, dict[str, str]] = {
    "ghidra": {"category": "static-reversing", "note": "Ghidra project/plugin backed analysis."},
    "ida": {"category": "static-reversing", "note": "IDA Pro plugin bridge (port 13337); needs user-supplied IDA Pro 8.3+ with the ida-pro-mcp plugin installed."},
    "radare2": {"category": "static-reversing", "note": "radare2/r2mcp binary analysis; needs radare2 + r2mcp installed via r2pm."},
    "x64dbg": {"category": "debugger", "note": "x64dbg automate bridge; needs debugger session for live work."},
    "jadx": {"category": "mobile", "note": "JADX GUI/plugin backed APK/DEX inspection."},
    "apktool": {"category": "mobile", "note": "APK decode/build/resource/smali workspace operations."},
    "frida": {"category": "mobile-runtime", "note": "Frida device/process runtime automation."},
    "imhex": {"category": "static-reversing", "note": "ImHex API backed binary/hex operations."},
    "yaraflux": {"category": "rules", "note": "YARA rules, sample storage, and scanning."},
    "mobsf": {"category": "mobile", "note": "MobSF scan API bridge; needs MobSF service for real scans."},
    "ilspy": {"category": "dotnet", "note": ".NET assembly inspection/decompilation."},
    "dnspy": {"category": "dotnet", "note": ".NET assembly inspection and patch helper tools."},
    "wireshark": {"category": "network", "note": "tshark/Wireshark pcap analysis and capture helpers."},
    "reqable": {"category": "network", "note": "Reqable HAR/API/WebSocket analysis workspace."},
    "reclass": {"category": "memory", "note": "ReClass.NET memory structure bridge; needs ReClass GUI/plugin."},
    "sevenzip": {"category": "unpacking", "note": "7-Zip archive listing/extract/update helpers."},
    "cheatengine": {"category": "memory", "note": "Cheat Engine Lua bridge; needs CE and bridge loaded for live work."},
    "volatility3": {"category": "memory-forensics", "note": "Volatility3 memory-image forensics; exposes Vol3 plugins as tools."},
    "virustotal": {"category": "threat-intel", "note": "VirusTotal URL/file/IP/domain intel; needs VIRUSTOTAL_API_KEY; sends IOCs to the public VT API."},
}

INSTRUCTIONS = (
    "Lightweight router for a local portable debugger/reverse-engineering MCP backend set. "
    "Only this router is meant to start with the AI client by default; it starts heavy backends on demand for each call. "
    "Use list_backends and list_backend_tools before calling unfamiliar tools. "
    "Before destructive writes, process injection, live capture, debugger/memory mutation, or system-level actions, "
    "explain the risk and rollback path to the user first."
)

mcp = FastMCP("debugger-router", instructions=INSTRUCTIONS, log_level="ERROR")


def _resolve_command(command: str) -> str:
    command = command.replace("{{DEBUGGER_ROOT}}", str(ROOT))
    try:
        path = Path(command)
    except Exception:
        return command
    if not path.is_absolute():
        return str((ROOT / path).resolve())
    try:
        relative = path.relative_to(CANONICAL_ROOT)
    except ValueError:
        return command
    return str(ROOT / relative)


def _load_backends() -> dict[str, str]:
    # utf-8-sig tolerates a UTF-8 BOM in case the config was hand-edited or
    # written by a tool that prepends one.
    data = json.loads(BACKEND_CONFIG.read_text(encoding="utf-8-sig"))
    servers = data.get("mcpServers", {})
    backends: dict[str, str] = {}
    for name, cfg in servers.items():
        if name == "debugger-router":
            continue
        command = cfg.get("command")
        if command:
            backends[name] = _resolve_command(command)
    return backends


def _backend_env() -> dict[str, str]:
    env = os.environ.copy()
    env["PYTHONUTF8"] = "1"
    env["PYTHONIOENCODING"] = "utf-8"
    env["FASTMCP_SHOW_SERVER_BANNER"] = "false"
    env["FASTMCP_CHECK_FOR_UPDATES"] = "off"
    env["FASTMCP_ENABLE_RICH_LOGGING"] = "false"
    env["PATH"] = str(MCP_ROOT / "bin") + os.pathsep + env.get("PATH", "")
    return env


def _stdio_params(command: str) -> StdioServerParameters:
    if command.lower().endswith((".cmd", ".bat")):
        return StdioServerParameters(command="cmd.exe", args=["/c", command], env=_backend_env())
    return StdioServerParameters(command=command, args=[], env=_backend_env())


def _clamp_timeout(value: float) -> float:
    try:
        timeout = float(value)
    except Exception:
        timeout = 60.0
    return max(5.0, min(timeout, 300.0))


def _parse_args(arguments_json: str | None) -> dict[str, Any]:
    if not arguments_json:
        return {}
    parsed = json.loads(arguments_json)
    if not isinstance(parsed, dict):
        raise ValueError("arguments_json must decode to a JSON object")
    return parsed


def _jsonable(value: Any) -> Any:
    if value is None or isinstance(value, (str, int, float, bool)):
        return value
    if isinstance(value, list):
        return [_jsonable(item) for item in value]
    if isinstance(value, tuple):
        return [_jsonable(item) for item in value]
    if isinstance(value, dict):
        return {str(key): _jsonable(item) for key, item in value.items()}
    if hasattr(value, "model_dump"):
        return _jsonable(value.model_dump(mode="json", exclude_none=True))
    return repr(value)


async def _with_backend(backend: str, timeout_seconds: float, operation):
    backends = _load_backends()
    if backend not in backends:
        raise ValueError(f"Unknown backend '{backend}'. Use list_backends first.")
    params = _stdio_params(backends[backend])

    async def run():
        async with stdio_client(params) as (read, write):
            async with ClientSession(read, write) as session:
                await session.initialize()
                return await operation(session)

    return await asyncio.wait_for(run(), timeout=_clamp_timeout(timeout_seconds))


@mcp.tool()
def list_backends() -> dict[str, Any]:
    """List available on-demand debugger MCP backends without starting them."""
    backends = _load_backends()
    return {
        "count": len(backends),
        "default_startup": "Only debugger-router should be enabled by default; these backends start per router call.",
        "backends": [
            {
                "name": name,
                "command": command,
                "category": BACKEND_META.get(name, {}).get("category", "unknown"),
                "note": BACKEND_META.get(name, {}).get("note", ""),
            }
            for name, command in sorted(backends.items())
        ],
    }


@mcp.tool()
async def list_backend_tools(
    backend: str,
    include_schemas: bool = False,
    timeout_seconds: float = 40.0,
) -> dict[str, Any]:
    """Start one backend temporarily and list its tools, then close it."""

    async def operation(session: ClientSession):
        tools_result = await session.list_tools()
        tools = []
        for tool in tools_result.tools:
            item = {
                "name": tool.name,
                "description": (tool.description or "")[:1200],
            }
            if include_schemas:
                item["input_schema"] = _jsonable(getattr(tool, "inputSchema", None))
            tools.append(item)
        return {
            "backend": backend,
            "tool_count": len(tools),
            "tools": tools,
        }

    started = time.monotonic()
    result = await _with_backend(backend, timeout_seconds, operation)
    result["elapsed_seconds"] = round(time.monotonic() - started, 2)
    return result


@mcp.tool()
async def call_backend_tool(
    backend: str,
    tool_name: str,
    arguments_json: str = "{}",
    timeout_seconds: float = 90.0,
) -> dict[str, Any]:
    """Start one backend temporarily, call one backend tool, return the result, then close it."""
    arguments = _parse_args(arguments_json)

    async def operation(session: ClientSession):
        call = await session.call_tool(tool_name, arguments)
        return {
            "backend": backend,
            "tool": tool_name,
            "is_error": bool(getattr(call, "isError", False)),
            "content": _jsonable(getattr(call, "content", None)),
            "structured_content": _jsonable(getattr(call, "structuredContent", None)),
        }

    started = time.monotonic()
    result = await _with_backend(backend, timeout_seconds, operation)
    result["elapsed_seconds"] = round(time.monotonic() - started, 2)
    return result


@mcp.tool()
async def smoke_backend(backend: str, timeout_seconds: float = 40.0) -> dict[str, Any]:
    """Start one backend temporarily and verify MCP initialize plus tools/list."""
    started = time.monotonic()
    result = await list_backend_tools(backend=backend, include_schemas=False, timeout_seconds=timeout_seconds)
    return {
        "backend": backend,
        "status": "PASS" if result.get("tool_count", 0) > 0 else "FAIL_NO_TOOLS",
        "tool_count": result.get("tool_count", 0),
        "elapsed_seconds": round(time.monotonic() - started, 2),
    }


@mcp.tool()
def workflow_help() -> dict[str, Any]:
    """Show how the AI client should use this router and how to start direct MCP profiles when needed."""
    return {
        "normal_workflow": [
            "Use list_backends to choose a backend.",
            "Use list_backend_tools with include_schemas=true when arguments are unclear.",
            "Use call_backend_tool to run the specific backend tool.",
            "The backend process exits after each router call.",
        ],
        "direct_profile_examples": [
            "codex --profile mcp-mobile",
            "codex --profile mcp-re",
            "codex --profile mcp-net",
            "codex --profile mcp-ce",
            "codex --profile mcp-all",
        ],
        "important_limit": (
            "Some MCP clients do not currently hot-add new MCP tool lists into an already running session. "
            "The router is the default on-demand workaround."
        ),
    }


if __name__ == "__main__":
    mcp.run()
