<div align="center">

# Linkwarden for Home Assistant

[![Version](https://img.shields.io/badge/version-1.0.0-blue?style=for-the-badge)](config.yaml)
[![License](https://img.shields.io/badge/License-AGPL--3.0-green?style=for-the-badge)](https://github.com/linkwarden/linkwarden/blob/main/LICENSE)
[![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Add--on-41BDF5?style=for-the-badge&logo=homeassistant&logoColor=white)](https://www.home-assistant.io/)
[![Upstream](https://img.shields.io/badge/Upstream-Linkwarden-blue?style=for-the-badge&logo=github)](https://github.com/linkwarden/linkwarden)
[![amd64](https://img.shields.io/badge/arch-amd64-informational?style=for-the-badge)](build.yaml)
[![aarch64](https://img.shields.io/badge/arch-aarch64-informational?style=for-the-badge)](build.yaml)

**Self-hosted bookmark manager and web archive for your household.**
**Save, organize, and preserve web pages -- never lose a link again.**

</div>

---

## About

**Linkwarden for HA** is a Home Assistant add-on that packages [Linkwarden](https://linkwarden.app) by [Daniel](https://github.com/daniel31x13) to run as a supervised add-on within Home Assistant.

Linkwarden is a collaborative bookmark manager that automatically archives web pages as screenshots, PDFs, and readable articles. It supports collections, tags, full-text search, collaboration, browser extensions, and a REST API.

> [!NOTE]
> This is a community port. All credit for Linkwarden goes to the original
> project and its contributors.

## Features

- **Save bookmarks** -- store any URL with automatic metadata extraction.
- **Web archival** -- automatic screenshots, PDF snapshots, and readable article extraction.
- **Collections** -- organize bookmarks into hierarchical collections.
- **Tags** -- label bookmarks with tags for quick filtering.
- **Full-text search** -- search across all your bookmarks and archived content.
- **Collaboration** -- share collections with family members.
- **Browser extensions** -- one-click saving from Chrome, Firefox, and Safari.
- **REST API** -- programmatic access for automations.
- **Import/export** -- import from browser bookmarks, Pocket, Omnivore, and more.
- **Web interface** -- accessible from the HA sidebar via Ingress.
- **Embedded database** -- PostgreSQL included, no external database needed.
- **Multi-architecture** -- supports `amd64` and `aarch64`.

## Quick Start

1. Install the add-on from the Home Assistant Add-on Store.
2. Start the add-on -- Linkwarden will appear in the sidebar.
3. Click **Linkwarden** in the sidebar to open the web interface.
4. Create your first account.
5. **Disable registration** in the add-on configuration once all accounts are created.
6. Install a browser extension and point it to `http://<HA_IP>:3000`.

## Configuration

| Option | Default | Description |
|--------|---------|-------------|
| Auth Secret | *(auto)* | Session encryption key. Leave empty to auto-generate. |
| Allow Registration | `true` | Let new users register. Disable after setup. |
| Log Level | `info` | `debug`, `info`, `warn`, or `error`. |
| SMTP Host | *(empty)* | Mail server for password resets and invitations. |
| SMTP Port | `587` | Mail server port. |
| SMTP Username | *(empty)* | Mail server authentication. |
| SMTP Password | *(empty)* | Mail server authentication. |
| SMTP From | *(empty)* | Sender address for outgoing emails. |

## Architecture

```
Home Assistant
├── Linkwarden Add-on
│   ├── Linkwarden Server (:3000)  ◄── Web browser / extensions
│   ├── Web Interface (Ingress)    ◄── HA Web UI sidebar
│   ├── PostgreSQL DB              ◄── Bookmark and user storage
│   └── Archive Storage            ◄── Screenshots, PDFs, articles
```

## Support

- [Linkwarden Website](https://linkwarden.app)
- [Linkwarden GitHub](https://github.com/linkwarden/linkwarden)
- [Linkwarden Documentation](https://docs.linkwarden.app)
