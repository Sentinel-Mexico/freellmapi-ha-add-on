<div align="center">

# Home Assistant Add-ons

[![Version](https://img.shields.io/badge/version-1.0.4-blue?style=for-the-badge)](freellmapi/config.yaml)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Add--on-41BDF5?style=for-the-badge&logo=homeassistant&logoColor=white)](https://www.home-assistant.io/)
[![Standard](https://img.shields.io/badge/Standard-agentskills.io-black?style=for-the-badge)](https://agentskills.io)

**Community port of [FreeLLMApi](https://github.com/tashfeenahmed/freellmapi) for Home Assistant.**

34+ free LLM providers · 635 free model endpoints · One OpenAI-compatible `/v1` endpoint
running inside your Home Assistant as a supervised add-on.

</div>

---

## Project Description

This repository contains Home Assistant add-ons maintained by [Sentinel Mexico](https://github.com/Sentinel-Mexico). The main add-on is **FreeLLMApi for HA**, a port of the open-source project [FreeLLMApi](https://github.com/tashfeenahmed/freellmapi) by [Tashfeen Ahmed](https://github.com/tashfeenahmed), adapted to run as a supervised add-on within the Home Assistant ecosystem.

FreeLLMApi aggregates the free tiers from 34+ AI providers (Google, Groq, Mistral, Cohere, NVIDIA, and more) behind a single OpenAI-compatible endpoint (`/v1`). It includes smart routing, automatic failover when a provider is rate-limited, AES-256-GCM encrypted key storage, and per-key usage tracking.

> [!NOTE]
> This is a community port. All credit for the core LLM engine goes to the
> original [FreeLLMApi](https://github.com/tashfeenahmed/freellmapi) project and its contributors.

## Overview

The goal of this repository is to provide Home Assistant users with access to hundreds of free AI models without requiring external infrastructure. By installing this add-on, your Home Assistant instance becomes a local LLM gateway that any service or automation can consume through the standard OpenAI API.

```
Home Assistant
├── FreeLLMApi for HA
│   ├── API Server (:39101/v1)  ◄── Hermes / OpenClaw / any client
│   ├── Dashboard (Ingress)     ◄── HA Web UI
│   ├── CLI Tools               ◄── Add-on Terminal
│   └── SQLite / MariaDB        ◄── Encrypted key storage
├── Hermes Add-on
│   └── connects to :39101/v1
└── OpenClaw Add-on
    └── connects to :39101/v1
```

## Key Features

- **Single endpoint** — `/v1` compatible with OpenAI SDK, Anthropic, and any OpenAI-compatible client.
- **Smart router** — picks the best available model and automatically fails over when a provider hits its rate limit.
- **34+ providers** — Google, Groq, Mistral, Cohere, NVIDIA, Cerebras, OpenRouter, Cloudflare, HuggingFace, Z.ai, and more.
- **635 free model endpoints** — chat, embeddings, audio transcription, and images.
- **Encrypted storage** — API keys encrypted with AES-256-GCM at rest.
- **Built-in dashboard** — manage keys, view usage, and generate API tokens from the Home Assistant UI (Ingress).
- **CLI tools** — configure coding agents (Claude Code, Cursor, Cline, Aider, etc.) from the add-on terminal.
- **Flexible database** — SQLite by default with optional MariaDB support.
- **Integration ready** — works with Hermes, OpenClaw, or any service that speaks the OpenAI API format.
- **Multi-architecture** — supports `amd64` and `aarch64`.

## Available Add-ons

| Add-on | Description | Version |
|--------|-------------|---------|
| [FreeLLMApi for HA](freellmapi/) | Free LLM gateway with 34+ providers | 1.0.4 |

## Installation & Setup

### Prerequisites

- Home Assistant OS or Home Assistant Supervised.
- Access to **Settings → Add-ons → Add-on Store**.

### Installation Steps

1. In Home Assistant, go to **Settings → Add-ons → Add-on Store**.
2. Click the three-dot menu (top-right) → **Repositories**.
3. Paste this repository URL and click **Add**:
   ```
   https://github.com/Sentinel-Mexico/freellmapi-ha-add-on
   ```
4. Find **FreeLLMApi for HA** in the store, click **Install**.
5. Start the add-on and open the **Web UI** to add your free-tier provider keys.
6. Point Hermes, OpenClaw, or any OpenAI client at:
   ```
   http://<YOUR_HA_IP>:39101/v1
   ```

### Integration Examples

#### Hermes

Set the LLM base URL in Hermes:

```
http://homeassistant.local:39101/v1
```

#### OpenClaw

Set `LLM_BASE_URL` in the OpenClaw bridge:

```
LLM_BASE_URL=http://homeassistant.local:39101/v1
LLM_API_KEY=freellmapi-...
```

#### Python / OpenAI SDK

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://homeassistant.local:39101/v1",
    api_key="freellmapi-..."
)

r = client.chat.completions.create(
    model="auto",
    messages=[{"role": "user", "content": "Turn off the living room lights"}]
)
```

## Configuration

| Option | Default | Description |
|--------|---------|-------------|
| API Port | `39101` | Port for the `/v1` endpoint |
| Log Level | `info` | Logging level: `debug`, `info`, `warn`, `error` |
| Database Engine | `sqlite` | `sqlite` or `mariadb` |
| MariaDB Host | `core-mariadb` | Only used when engine is `mariadb` |
| MariaDB Port | `3306` | Only used when engine is `mariadb` |
| Encryption Key | *(auto)* | Leave empty to auto-generate |

## Tech Stack

| Technology | Usage |
|------------|-------|
| **Node.js 20** | API server and CLI runtime |
| **TypeScript** | Development language (server, client, CLI) |
| **React + Vite** | Web dashboard (client) |
| **SQLite / MariaDB** | Key storage and usage statistics |
| **Nginx** | Reverse proxy for Home Assistant Ingress |
| **Docker** | Multi-stage build (Alpine base) |
| **Bash (bashio)** | Startup script and HA Supervisor integration |

## Repository Structure

```
.
├── freellmapi/              # Main add-on
│   ├── cli/                 # CLI tools for coding agents
│   ├── client/              # React dashboard (Vite)
│   ├── server/              # Node.js API server
│   ├── shared/              # Shared modules
│   ├── translations/        # Add-on translations
│   ├── CHANGELOG.md         # Add-on changelog
│   ├── DOCS.md              # Add-on documentation (visible in HA)
│   ├── Dockerfile           # Multi-stage build
│   ├── build.yaml           # Build configuration for HA
│   ├── config.yaml          # Add-on manifest
│   ├── nginx-ingress.conf   # Ingress proxy configuration
│   ├── package.json         # Monorepo workspaces
│   └── run.sh               # Startup script (bashio)
├── public/
│   └── icons/               # Repository icons
├── README.md                # This file
└── repository.yaml          # Add-on repository manifest
```

## Documentation

- [Add-on Documentation (DOCS.md)](freellmapi/DOCS.md) — Complete guide visible from Home Assistant.
- [Changelog](freellmapi/CHANGELOG.md) — Version history.
- [Original FreeLLMApi](https://github.com/tashfeenahmed/freellmapi) — Upstream project documentation.
- [FreeLLMApi Models Catalog](https://freellmapi.co/models.html) — Full catalog of free models.

## Contributing

Contributions are welcome. To contribute:

1. Fork this repository.
2. Create a branch from `main` with a descriptive name.
3. Make your changes and ensure the Docker build works correctly.
4. Open a Pull Request describing the changes.

For contributions to the core LLM engine, head to the [upstream FreeLLMApi repository](https://github.com/tashfeenahmed/freellmapi).

## Credits

This add-on is a port of [FreeLLMApi](https://github.com/tashfeenahmed/freellmapi)
by [Tashfeen Ahmed](https://github.com/tashfeenahmed). All credit for the core
LLM gateway goes to the original project and its contributors.

## License

MIT — see the [original FreeLLMApi repository](https://github.com/tashfeenahmed/freellmapi) for the upstream license.

---

<div align="center">

**Maintained by [Sentinel Mexico](https://github.com/Sentinel-Mexico)**

</div>
