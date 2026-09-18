# Changelog

## 1.0.4 — 2026-09-18

### Changed

- Replaced icons with pixel-perfect renders of the official FreeLLMApi SVG logo
  (white circle + green dot on dark rounded square).

## 1.0.3 — 2026-09-18

### Fixed

- Fixed startup crash caused by better-sqlite3 native module incompatibility.
  The module is now rebuilt against Alpine musl libc during the Docker build.

## 1.0.2 — 2026-09-18

### Changed

- Replaced placeholder icons with the official FreeLLMApi logo.

## 1.0.1 — 2026-09-18

### Changed

- Default API port changed from 3001 to 39101 to avoid conflicts with other services.
- Healthcheck now uses the configured port instead of a hardcoded value.

## 1.0.0 — 2026-09-18

### Added

- Initial release: port of FreeLLMApi as a Home Assistant add-on.
- Based on FreeLLMApi (https://github.com/tashfeenahmed/freellmapi).
- OpenAI-compatible `/v1` endpoint exposed on port 39101.
- Built-in dashboard accessible via Home Assistant Ingress.
- SQLite database by default with optional MariaDB support.
- Persistent encrypted key storage (AES-256-GCM).
- CLI tools included for coding agent configuration.
- Ready for integration with Hermes, OpenClaw, and any OpenAI-compatible client.
- Multi-architecture support: amd64 and aarch64.
- Maintained by Sentinel Mexico.
