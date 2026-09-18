<div align="center">

# FreeLLMApi for Home Assistant

[![Version](https://img.shields.io/badge/version-1.0.4-blue?style=for-the-badge)](config.yaml)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](https://github.com/tashfeenahmed/freellmapi/blob/main/LICENSE)
[![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Add--on-41BDF5?style=for-the-badge&logo=homeassistant&logoColor=white)](https://www.home-assistant.io/)
[![Upstream](https://img.shields.io/badge/Upstream-FreeLLMApi-purple?style=for-the-badge&logo=github)](https://github.com/tashfeenahmed/freellmapi)
[![amd64](https://img.shields.io/badge/arch-amd64-informational?style=for-the-badge)](build.yaml)
[![aarch64](https://img.shields.io/badge/arch-aarch64-informational?style=for-the-badge)](build.yaml)

**7.4 billion tokens per month · 34 free LLM providers · 635 free model endpoints**
**All behind one `/v1` endpoint — inside your Home Assistant.**

</div>

---

## About

**FreeLLMApi for HA** is a Home Assistant add-on that ports the open-source project [FreeLLMApi](https://github.com/tashfeenahmed/freellmapi) by [Tashfeen Ahmed](https://github.com/tashfeenahmed) into the Home Assistant ecosystem. It aggregates the free tiers from dozens of AI providers behind a single OpenAI-compatible endpoint running locally on your HA instance.

The original project — FreeLLMApi — solves a real problem: every serious AI lab now offers a free tier (a few million tokens per month, a few thousand requests per day). Each one on its own is limited, but stacked together they add up to roughly **7.4 billion tokens per month** of working inference capacity, spread across **474 model families / 635 provider endpoints**.

The problem with stacking them manually is painful: thirty-four different SDKs, thirty-four different rate limits, thirty-four points of failure. FreeLLMApi collapses all of that into a single OpenAI-compatible endpoint.

> [!NOTE]
> This add-on is a community port maintained by [Sentinel Mexico](https://github.com/Sentinel-Mexico).
> All credit for the core engine goes to the original project and its contributors.

## Upstream: FreeLLMApi

This add-on is based on [FreeLLMApi](https://github.com/tashfeenahmed/freellmapi), an MIT-licensed project that offers:

| Feature | Details |
|---------|---------|
| **Providers** | 34+ free providers: Google, Groq, Cerebras, Mistral, OpenRouter, Cloudflare, Cohere, NVIDIA, HuggingFace, Z.ai (Zhipu), ModelScope, and 22 more |
| **Models** | 474 model families, 635 free endpoints (584 chat, 41 embeddings, 7 transcription, 3 video) |
| **Tokens** | ~7.4 billion tokens/month of combined free capacity |
| **API Surface** | `/v1/chat/completions`, `/v1/completions`, `/v1/images/generations`, `/v1/audio/transcriptions`, `/v1/embeddings`, `/v1/models` |
| **Catalog** | Self-updating model catalog via signed feed |
| **Security** | Keys encrypted with AES-256-GCM, single unified token for clients |
| **Router** | 6 routing strategies, automatic failover with cooldowns and key rotation |
| **Dashboard** | React UI with support for 60 languages, light/dark themes |

For more information, see the [upstream project README](https://github.com/tashfeenahmed/freellmapi#readme) and the [model catalog](https://freellmapi.co/models.html).

## Features (Home Assistant Adaptations)

This add-on extends FreeLLMApi with native integration into the HA ecosystem:

- **Single endpoint** — `/v1` compatible with OpenAI SDK, Anthropic SDK, and any OpenAI-compatible client, accessible on port `39101`.
- **Smart router** — automatically picks the best available model with healthy keys under their rate limits, and fails over to the next model on 429/5xx errors.
- **Dashboard via Ingress** — access the admin panel directly from the Home Assistant sidebar without opening additional ports.
- **CLI tools** — configure coding agents (Claude Code, Codex CLI, Cursor, Cline, Aider, and more) from the add-on terminal.
- **Flexible database** — built-in SQLite by default, or MariaDB if you use the official HA add-on.
- **Encryption at rest** — provider keys encrypted with AES-256-GCM; auto-generates the encryption key on first startup.
- **Persistence** — data is stored in HA's persistent storage (`/data/freellmapi`).
- **Multi-architecture** — supports `amd64` and `aarch64` with Home Assistant base images.
- **Healthcheck** — automatic service verification every 30 seconds.

## Compatible Agents & Clients

FreeLLMApi is compatible with a wide range of coding agents and clients:

| Agent | Automated Setup | Base URL |
|-------|-----------------|----------|
| Claude Code | `setup-claude` | root |
| Codex CLI | `setup-codex` | `/v1` |
| Cline | `setup-cline` | `/v1` |
| Continue | `setup-continue` | `/v1` |
| Aider | `setup-aider` | `/v1` |
| Cursor | `setup-cursor` | `/v1` |
| Roo Code | `setup-roo` | `/v1` |
| Goose | `setup-goose` | `/v1` |
| OpenClaw | `setup-openclaw` | `/v1` |
| Hermes Agent | `setup-hermes` | `/v1` |

> Plus any OpenAI-compatible client, Anthropic SDK, Gemini SDK, or Ollama-capable app.

## Quick Start

### 1. Add the repository

In Home Assistant, go to **Settings → Add-ons → Add-on Store**, click the three-dot menu (top-right) → **Repositories**, and paste:

```
https://github.com/Sentinel-Mexico/freellmapi-ha-add-on
```

### 2. Install the add-on

Find **FreeLLMApi for HA** in the store and click **Install**.

### 3. Start and configure

Start the add-on, open the **Web UI** from the Home Assistant sidebar, and add your free-tier provider keys.

### 4. Connect clients

Point any OpenAI-compatible client at:

```
http://<YOUR_HA_IP>:39101/v1
```

Or from another add-on on the same host:

```
http://homeassistant.local:39101/v1
```

## Configuration

| Option | Default | Description |
|--------|---------|-------------|
| `api_port` | `39101` | Port for the `/v1` endpoint |
| `log_level` | `info` | Logging level: `debug`, `info`, `warn`, `error` |
| `db_engine` | `sqlite` | Database engine: `sqlite` or `mariadb` |
| `mariadb_host` | `core-mariadb` | MariaDB host (only with `mariadb` engine) |
| `mariadb_port` | `3306` | MariaDB port (only with `mariadb` engine) |
| `mariadb_user` | *(empty)* | MariaDB user |
| `mariadb_password` | *(empty)* | MariaDB password |
| `mariadb_database` | `freellmapi` | MariaDB database name |
| `encryption_key` | *(auto)* | AES-256-GCM encryption key; leave empty to auto-generate |

### Database

By default, FreeLLMApi uses **SQLite**, storing everything in a single file inside the add-on's persistent storage. No additional configuration needed.

If you prefer **MariaDB**, install the official MariaDB add-on first, then:

1. Set **Database Engine** to `mariadb`.
2. Fill in the host, port, user, password, and database name.
3. The default host `core-mariadb` works with the official HA MariaDB add-on.

### Encryption Key

Your provider keys are encrypted at rest with AES-256-GCM. The add-on auto-generates an encryption key on first startup and persists it. You only need to set this manually if you are migrating from an existing FreeLLMApi instance.

## API Endpoints

| Path | Description |
|------|-------------|
| `/v1/chat/completions` | Chat completions (streaming supported) |
| `/v1/completions` | Text completions |
| `/v1/embeddings` | Text embeddings |
| `/v1/images/generations` | Image generation |
| `/v1/audio/transcriptions` | Audio transcription |
| `/v1/models` | List available models |

## CLI Tools

Open the add-on terminal in Home Assistant to access the FreeLLMApi CLI:

```bash
freellmapi list              # Show supported coding agent tools
freellmapi setup-claude      # Configure Claude Code
freellmapi setup-cursor      # Configure Cursor
freellmapi setup-generic     # Configure any OpenAI-compatible client
```

The CLI automatically points to the local server. Add `--help` to any command for details.

## Integration Examples

### With Hermes

In the Hermes add-on configuration:

- **LLM Base URL**: `http://homeassistant.local:39101/v1`
- **API Key**: the unified API key from your FreeLLMApi dashboard

### With OpenClaw

In the OpenClaw bridge configuration:

```env
LLM_BASE_URL=http://homeassistant.local:39101/v1
LLM_API_KEY=freellmapi-...
```

### Python / OpenAI SDK

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://<YOUR_HA_IP>:39101/v1",
    api_key="freellmapi-..."  # from the dashboard
)

response = client.chat.completions.create(
    model="auto",
    messages=[{"role": "user", "content": "Hello!"}]
)
```

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                  Home Assistant OS                    │
│                                                       │
│  ┌──────────────────────────────────────────────┐    │
│  │          FreeLLMApi for HA Add-on             │    │
│  │                                                │    │
│  │  ┌────────────┐  ┌────────────────────────┐   │    │
│  │  │   Nginx    │  │    Node.js Server       │   │    │
│  │  │  (Ingress) │──│  API Router (:39101)    │   │    │
│  │  │   :8099    │  │                          │   │    │
│  │  └────────────┘  │  ├── Smart Routing      │   │    │
│  │                    │  ├── Failover Engine    │   │    │
│  │  ┌────────────┐  │  ├── AES-256-GCM Crypto │   │    │
│  │  │  React UI  │  │  └── Rate Tracker       │   │    │
│  │  │ (Dashboard)│  └───────────┬──────────────┘   │    │
│  │  └────────────┘              │                   │    │
│  │                    ┌─────────┴─────────┐         │    │
│  │                    │  SQLite / MariaDB  │         │    │
│  │                    │  (encrypted keys)  │         │    │
│  │                    └───────────────────┘         │    │
│  └──────────────────────────────────────────────┘    │
│                         ▲                             │
│          ┌──────────────┼──────────────┐              │
│          │              │              │              │
│     ┌────┴────┐   ┌────┴────┐   ┌────┴────┐         │
│     │ Hermes  │   │OpenClaw │   │ Clients │         │
│     │ Add-on  │   │ Add-on  │   │ (any)   │         │
│     └─────────┘   └─────────┘   └─────────┘         │
└─────────────────────────────────────────────────────┘
                          │
              ┌───────────┼───────────┐
              ▼           ▼           ▼
         ┌────────┐  ┌────────┐  ┌────────┐
         │ Google │  │  Groq  │  │Mistral │  ... 34+ providers
         └────────┘  └────────┘  └────────┘
```

## Add-on Structure

```
freellmapi/
├── cli/                     # CLI for coding agent configuration
│   ├── src/                 # TypeScript source code
│   └── tools.json           # CLI tool definitions
├── client/                  # React dashboard (Vite)
│   ├── src/                 # UI components and logic
│   └── vite.config.ts       # Vite configuration
├── server/                  # Node.js API server
│   ├── src/                 # TypeScript source code
│   └── vitest.config.ts     # Test configuration
├── shared/                  # Shared modules across server/client/cli
├── translations/            # Add-on translations for HA
├── config.yaml              # Add-on manifest (metadata, options, schema)
├── build.yaml               # Multi-arch build configuration
├── Dockerfile               # Multi-stage build (builder + Alpine runtime)
├── run.sh                   # Startup script (bashio, env, nginx, node)
├── nginx-ingress.conf       # Reverse proxy for HA Ingress
├── DOCS.md                  # Documentation visible from HA
├── CHANGELOG.md             # Change history
├── icon.png                 # Add-on icon (256x256)
└── logo.png                 # Add-on logo
```

## Credits

- **Original project:** [FreeLLMApi](https://github.com/tashfeenahmed/freellmapi) by [Tashfeen Ahmed](https://github.com/tashfeenahmed)
- **Home Assistant port:** [Sentinel Mexico](https://github.com/Sentinel-Mexico)

## License

This add-on is licensed under **MIT**, same as the upstream FreeLLMApi project.

---

<div align="center">

**Maintained by [Sentinel Mexico](https://github.com/Sentinel-Mexico)**

</div>
