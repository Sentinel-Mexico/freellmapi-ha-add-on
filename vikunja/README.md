<div align="center">

# Vikunja for Home Assistant

[![Version](https://img.shields.io/badge/version-1.0.4-blue?style=for-the-badge)](config.yaml)
[![License](https://img.shields.io/badge/License-AGPL--3.0-green?style=for-the-badge)](https://github.com/go-vikunja/vikunja/blob/main/LICENSE)
[![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Add--on-41BDF5?style=for-the-badge&logo=homeassistant&logoColor=white)](https://www.home-assistant.io/)
[![Upstream](https://img.shields.io/badge/Upstream-Vikunja-blue?style=for-the-badge&logo=github)](https://github.com/go-vikunja/vikunja)
[![amd64](https://img.shields.io/badge/arch-amd64-informational?style=for-the-badge)](build.yaml)
[![aarch64](https://img.shields.io/badge/arch-aarch64-informational?style=for-the-badge)](build.yaml)

**Self-hosted task and project management for your household.**
**Open-source alternative to Todoist, Trello, and Microsoft To Do.**

</div>

---

## About

**Vikunja for HA** is a Home Assistant add-on that packages [Vikunja](https://vikunja.io) by [the Vikunja team](https://github.com/go-vikunja) to run as a supervised add-on within Home Assistant.

Vikunja is a full-featured, open-source task management application written in Go with a Vue.js frontend. It supports task lists, kanban boards, Gantt charts, calendar views, file attachments, reminders, labels, priorities, team collaboration, and CalDAV sync with native apps.

> [!NOTE]
> This is a community port. All credit for Vikunja goes to the original
> project and its contributors.

## Features

- **Task lists** -- create and organize tasks with due dates, priorities, labels, and assignees.
- **Kanban boards** -- drag-and-drop task management in board view.
- **Gantt charts** -- visualize project timelines.
- **Calendar view** -- see all tasks with due dates in a calendar.
- **Reminders** -- get notified about upcoming tasks (requires SMTP).
- **File attachments** -- attach files to any task.
- **Team collaboration** -- share projects with family members, assign tasks.
- **CalDAV sync** -- sync tasks with Apple Reminders, Thunderbird, GNOME Calendar, and other CalDAV clients.
- **Sharing links** -- share task lists via public links.
- **Web interface** -- accessible from the HA sidebar via Ingress.
- **Lightweight** -- Go binary with SQLite; runs with minimal resources.
- **Multi-architecture** -- supports `amd64` and `aarch64`.

## Quick Start

1. Install the add-on from the Home Assistant Add-on Store.
2. Start the add-on -- Vikunja will appear in the sidebar.
3. Click **Vikunja** in the sidebar to open the web interface.
4. Create your first account.
5. **Disable registration** in the add-on configuration once all accounts are created.

## Configuration

| Option | Default | Description |
|--------|---------|-------------|
| Service Secret | *(auto)* | JWT signing key. Leave empty to auto-generate. |
| Frontend URL | *(empty)* | Full URL for external access (e.g. `https://tasks.example.com`). |
| Log Level | `info` | `debug`, `info`, `warn`, or `error`. |
| Allow Registration | `true` | Let new users register. Disable after setup. |
| Enable Email | `false` | Enable SMTP for notifications and reminders. |
| SMTP Host | *(empty)* | Mail server hostname. |
| SMTP Port | `587` | Mail server port. |
| SMTP Username | *(empty)* | Mail server authentication. |
| SMTP Password | *(empty)* | Mail server authentication. |
| SMTP From | *(empty)* | Sender address for outgoing emails. |

## Architecture

```
Home Assistant
├── Vikunja Add-on
│   ├── Vikunja Server (:3456)   ◄── Web browser / mobile apps
│   ├── Web Interface (Ingress)  ◄── HA Web UI sidebar
│   ├── CalDAV Endpoint          ◄── Apple Reminders / Thunderbird
│   └── SQLite DB                ◄── Task and project storage
```

## Support

- [Vikunja Website](https://vikunja.io)
- [Vikunja Documentation](https://vikunja.io/docs)
- [Vikunja GitHub](https://github.com/go-vikunja/vikunja)
- [Vikunja Community](https://community.vikunja.io)
