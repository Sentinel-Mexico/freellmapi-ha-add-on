# Changelog

## 1.0.0 — 2026-09-18

### Added

- Initial release: port of FreeLLMApi as a Home Assistant add-on.
- Based on FreeLLMApi (https://github.com/tashfeenahmed/freellmapi).
- OpenAI-compatible `/v1` endpoint exposed on port 3001.
- Built-in dashboard accessible via Home Assistant Ingress.
- SQLite database by default with optional MariaDB support.
- Persistent encrypted key storage (AES-256-GCM).
- CLI tools included for coding agent configuration.
- Ready for integration with Hermes, OpenClaw, and any OpenAI-compatible client.
- Multi-architecture support: amd64 and aarch64.
- Maintained by Sentinel Mexico.
