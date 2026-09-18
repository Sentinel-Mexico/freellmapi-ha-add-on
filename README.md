<div align="center">

# Home Assistant Add-ons

[![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Add--ons-41BDF5?style=for-the-badge&logo=homeassistant&logoColor=white)](https://www.home-assistant.io/)
[![Standard](https://img.shields.io/badge/Standard-agentskills.io-black?style=for-the-badge)](https://agentskills.io)

**Community add-ons for Home Assistant by [Sentinel Mexico](https://github.com/Sentinel-Mexico).**

</div>

---

## Available Add-ons

| Add-on | Description | Version |
|--------|-------------|---------|
| [FreeLLMApi for HA](freellmapi/) | OpenAI-compatible LLM gateway with 34+ free providers | 1.0.5 |
| [Vaultwarden for HA](vaultwarden/) | Self-hosted Bitwarden-compatible password manager | 1.0.0 |
| [Vikunja for HA](vikunja/) | Self-hosted task and project management | 1.0.0 |
| [Linkwarden for HA](linkwarden/) | Self-hosted bookmark manager and web archive | 1.0.0 |

---

## FreeLLMApi for HA

A port of [FreeLLMApi](https://github.com/tashfeenahmed/freellmapi) by [Tashfeen Ahmed](https://github.com/tashfeenahmed). Aggregates the free tiers from 34+ AI providers (Google, Groq, Mistral, Cohere, NVIDIA, and more) behind a single OpenAI-compatible `/v1` endpoint. Includes smart routing, automatic failover, AES-256-GCM encrypted key storage, and per-key usage tracking.

**Use it with:** Hermes, OpenClaw, or any service that speaks the OpenAI API format.

```
Home Assistant
├── FreeLLMApi for HA
│   ├── API Server (:3001/v1)   ◄── Hermes / OpenClaw / any client
│   ├── Dashboard (Ingress)     ◄── HA Web UI
│   ├── CLI Tools               ◄── Add-on Terminal
│   └── SQLite / MariaDB        ◄── Encrypted key storage
```

[Full documentation →](freellmapi/README.md)

---

## Vaultwarden for HA

A port of [Vaultwarden](https://github.com/dani-garcia/vaultwarden) by [Daniel Garcia](https://github.com/dani-garcia). Lightweight, Rust-based Bitwarden server that supports passwords, TOTP, passkeys, file attachments, Bitwarden Send, organizations, and emergency access — using under 50 MB of RAM.

**Use it with:** any official Bitwarden client (browser extension, desktop, mobile, CLI).

```
Home Assistant
├── Vaultwarden Add-on
│   ├── Vaultwarden Server (:8080)  ◄── Bitwarden clients
│   ├── Web Vault (Ingress)         ◄── HA Web UI sidebar
│   ├── Admin Panel (/admin)        ◄── Server management
│   └── SQLite DB                   ◄── Encrypted vault storage
```

[Full documentation →](vaultwarden/README.md)

---

## Vikunja for HA

A port of [Vikunja](https://vikunja.io) by the [Vikunja team](https://github.com/go-vikunja). Full-featured task management with lists, kanban boards, Gantt charts, calendar views, reminders, team collaboration, and CalDAV sync with native apps like Apple Reminders.

**Use it with:** any web browser, CalDAV-compatible apps (Apple Reminders, Thunderbird).

```
Home Assistant
├── Vikunja Add-on
│   ├── Vikunja Server (:3456)   ◄── Web browser / mobile apps
│   ├── Web Interface (Ingress)  ◄── HA Web UI sidebar
│   ├── CalDAV Endpoint          ◄── Apple Reminders / Thunderbird
│   └── SQLite DB                ◄── Task and project storage
```

[Full documentation →](vikunja/README.md)

---

## Linkwarden for HA

A port of [Linkwarden](https://linkwarden.app) by [Daniel](https://github.com/daniel31x13). A collaborative bookmark manager that automatically archives web pages as screenshots, PDFs, and readable articles. Supports collections, tags, full-text search, browser extensions, and a REST API.

**Use it with:** any web browser, browser extensions (Chrome, Firefox, Safari).

```
Home Assistant
├── Linkwarden Add-on
│   ├── Linkwarden Server (:3000)  ◄── Web browser / extensions
│   ├── Web Interface (Ingress)    ◄── HA Web UI sidebar
│   ├── PostgreSQL DB              ◄── Bookmark and user storage
│   └── Archive Storage            ◄── Screenshots, PDFs, articles
```

[Full documentation →](linkwarden/README.md)

---

## Installation

1. In Home Assistant, go to **Settings → Add-ons → Add-on Store**.
2. Click the three-dot menu (top-right) → **Repositories**.
3. Paste this repository URL and click **Add**:
   ```
   https://github.com/Sentinel-Mexico/ha-add-ons
   ```
4. All add-ons will appear in the store. Install whichever you need.

## Repository Structure

```
.
├── freellmapi/              # FreeLLMApi add-on
│   ├── cli/                 # CLI tools for coding agents
│   ├── client/              # React dashboard (Vite)
│   ├── server/              # Node.js API server
│   ├── shared/              # Shared modules
│   ├── translations/        # Add-on translations
│   ├── config.yaml          # Add-on manifest
│   ├── Dockerfile           # Multi-stage build
│   └── run.sh               # Startup script (bashio)
├── vaultwarden/             # Vaultwarden add-on
│   ├── translations/        # Add-on translations
│   ├── config.yaml          # Add-on manifest
│   ├── Dockerfile           # Multi-stage build
│   └── run.sh               # Startup script (bashio)
├── vikunja/                 # Vikunja add-on
│   ├── translations/        # Add-on translations
│   ├── config.yaml          # Add-on manifest
│   ├── Dockerfile           # Multi-stage build
│   └── run.sh               # Startup script (bashio)
├── linkwarden/              # Linkwarden add-on
│   ├── translations/        # Add-on translations
│   ├── config.yaml          # Add-on manifest
│   ├── Dockerfile           # Multi-stage build
│   └── run.sh               # Startup script (bashio)
├── README.md                # This file
└── repository.yaml          # Add-on repository manifest
```

## Contributing

Contributions are welcome. To contribute:

1. Fork this repository.
2. Create a branch from `main` with a descriptive name.
3. Make your changes and ensure the Docker build works correctly.
4. Open a Pull Request describing the changes.

For contributions to the upstream projects, visit [FreeLLMApi](https://github.com/tashfeenahmed/freellmapi), [Vaultwarden](https://github.com/dani-garcia/vaultwarden), [Vikunja](https://github.com/go-vikunja/vikunja), or [Linkwarden](https://github.com/linkwarden/linkwarden).

## Credits

- **FreeLLMApi** by [Tashfeen Ahmed](https://github.com/tashfeenahmed) — MIT License
- **Vaultwarden** by [Daniel Garcia](https://github.com/dani-garcia) — AGPL-3.0 License
- **Vikunja** by the [Vikunja team](https://github.com/go-vikunja) — AGPL-3.0 License
- **Linkwarden** by [Daniel](https://github.com/daniel31x13) — AGPL-3.0 License

---

<div align="center">

**Maintained by [Sentinel Mexico](https://github.com/Sentinel-Mexico)**

</div>
