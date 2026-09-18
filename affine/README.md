<div align="center">

# AFFiNE for Home Assistant

[![Version](https://img.shields.io/badge/version-1.0.0-blue?style=for-the-badge)](config.yaml)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](https://github.com/toeverything/AFFiNE/blob/canary/LICENSE)
[![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Add--on-41BDF5?style=for-the-badge&logo=homeassistant&logoColor=white)](https://www.home-assistant.io/)
[![Upstream](https://img.shields.io/badge/Upstream-AFFiNE-blue?style=for-the-badge&logo=github)](https://github.com/toeverything/AFFiNE)
[![amd64](https://img.shields.io/badge/arch-amd64-informational?style=for-the-badge)](build.yaml)
[![aarch64](https://img.shields.io/badge/arch-aarch64-informational?style=for-the-badge)](build.yaml)

**Self-hosted knowledge base for your household.**
**Docs, whiteboards, and databases -- all in one place.**

</div>

---

## About

**AFFiNE for HA** is a Home Assistant add-on that packages [AFFiNE](https://affine.pro) by [TOEVERYTHING](https://github.com/toeverything) to run as a supervised add-on within Home Assistant.

AFFiNE is a next-gen knowledge base that combines the best of documents, whiteboards, and databases. It supports rich-text editing with Markdown, infinite-canvas whiteboards, structured databases, real-time collaboration, offline editing, and an AI assistant with bring-your-own-key support.

> [!NOTE]
> This is a community port. All credit for AFFiNE goes to the original
> project and its contributors.

## Features

- **Documents** -- rich-text editor with Markdown, code blocks, tables, and embeds.
- **Whiteboards** -- infinite canvas for diagrams, mind maps, and visual brainstorming.
- **Databases** -- structured tables for projects, tasks, and data tracking.
- **AI Copilot** -- bring your own API key for AI-powered writing assistance.
- **Real-time collaboration** -- multiple users editing the same page live.
- **Offline support** -- changes sync automatically when reconnected.
- **Version history** -- track changes and restore previous versions.
- **Import/export** -- Markdown, HTML, and Notion import support.
- **Admin panel** -- manage users, workspaces, and settings from `/admin`.
- **Web interface** -- accessible from the HA sidebar via Ingress.
- **Embedded database** -- PostgreSQL and Redis included, no external services needed.
- **Multi-architecture** -- supports `amd64` and `aarch64`.

## Quick Start

1. Install the add-on from the Home Assistant Add-on Store.
2. Start the add-on -- AFFiNE will appear in the sidebar.
3. Click **AFFiNE** in the sidebar to open the web interface.
4. Create your first account (this becomes the admin).
5. Start creating documents, whiteboards, and databases.

## Configuration

| Option | Default | Description |
|--------|---------|-------------|
| Server Name | `AFFiNE Self-hosted` | Display name for this instance. |
| Log Level | `info` | `debug`, `info`, `warn`, or `error`. |
| SMTP Host | *(empty)* | Mail server for password resets and invitations. |
| SMTP Port | `587` | Mail server port. |
| SMTP Username | *(empty)* | Mail server authentication. |
| SMTP Password | *(empty)* | Mail server authentication. |
| SMTP Sender | *(empty)* | Sender address for outgoing emails. |

## Architecture

```
Home Assistant
├── AFFiNE Add-on
│   ├── AFFiNE Server (:3010)      ◄── Web browser / desktop app
│   ├── Web Interface (Ingress)    ◄── HA Web UI sidebar
│   ├── PostgreSQL DB              ◄── Document and user storage
│   ├── Redis Cache                ◄── Real-time sync and sessions
│   └── File Storage               ◄── Uploaded files and attachments
```

## Support

- [AFFiNE Website](https://affine.pro)
- [AFFiNE GitHub](https://github.com/toeverything/AFFiNE)
- [AFFiNE Documentation](https://docs.affine.pro)
