# Changelog

## 1.0.5 — 2026-09-19

### Fixed

- Fixed blank screen when accessing Vikunja through Home Assistant ingress: rewrote absolute asset paths to relative so JS/CSS/API requests route through the ingress proxy correctly.

## 1.0.4 — 2026-09-19

### Fixed

- Disabled CORS (not needed behind Home Assistant ingress proxy) to resolve "service.publicurl is required" startup error.
- Set publicurl from frontend_url when provided.

## 1.0.3 — 2026-09-18

### Fixed

- Added missing openssl package required for service secret generation at startup.

## 1.0.2 — 2026-09-18

### Fixed

- Fixed Docker build: removed reference to non-existent frontend directory (frontend is embedded in the Vikunja binary).

## 1.0.1 — 2026-09-18

### Changed

- Updated icon and logo to official Vikunja branding.

## 1.0.0 — 2026-09-18

### Added

- Initial release of Vikunja as a Home Assistant add-on.
- Based on Vikunja 2.5.0.
- Web interface accessible via Home Assistant Ingress sidebar.
- Direct access on port 3456 for API and client connections.
- SQLite database with persistent storage.
- Configurable registration, email (SMTP), frontend URL, and service secret.
- CalDAV support for syncing with native calendar/reminder apps.
- Multi-architecture support: amd64 and aarch64.
