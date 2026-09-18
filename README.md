# FreeLLMApi for Home Assistant

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**Port of [FreeLLMApi](https://github.com/tashfeenahmed/freellmapi) for Home Assistant.**

34+ free LLM providers, 635 free model endpoints, one OpenAI-compatible
endpoint — running inside your Home Assistant as an add-on.

> This project is a community port. The original FreeLLMApi is developed by
> [Tashfeen Ahmed](https://github.com/tashfeenahmed/freellmapi) and licensed
> under MIT.

## Quick start

1. In Home Assistant, go to **Settings > Add-ons > Add-on Store**.
2. Click the three-dot menu (top-right) > **Repositories**.
3. Paste this repository URL and click **Add**:
   ```
   https://github.com/Sentinel-Mexico/freellmapi-ha-add-on
   ```
4. Find **FreeLLMApi for HA** in the store, click **Install**.
5. Start the add-on and open the **Web UI** to add your free-tier provider keys.
6. Point Hermes, OpenClaw, or any OpenAI client at:
   ```
   http://<YOUR_HA_IP>:3001/v1
   ```

## Features

- **Single endpoint** — `/v1` compatible with the OpenAI SDK.
- **Smart router** — picks the best available model and fails over
  automatically when a provider is rate-limited.
- **34+ providers** — Google, Groq, Mistral, Cohere, NVIDIA, and more.
- **Encrypted storage** — API keys encrypted with AES-256-GCM.
- **Dashboard** — manage keys, view usage, generate API tokens from the
  Home Assistant UI (Ingress).
- **CLI tools** — configure coding agents (Claude Code, Cursor, Cline, etc.)
  from the add-on terminal.
- **Flexible database** — SQLite by default, with optional MariaDB support.
- **Integration ready** — works with Hermes, OpenClaw, or any service that
  speaks the OpenAI API format.

## Integration examples

### Hermes

Set the LLM base URL in Hermes to:

```
http://homeassistant.local:3001/v1
```

### OpenClaw

Set `LLM_BASE_URL` in the OpenClaw bridge:

```
LLM_BASE_URL=http://homeassistant.local:3001/v1
LLM_API_KEY=freellmapi-...
```

### Python / OpenAI SDK

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://homeassistant.local:3001/v1",
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
| API Port | `3001` | Port for the /v1 endpoint |
| Database Engine | `sqlite` | `sqlite` or `mariadb` |
| MariaDB Host | `core-mariadb` | Only used when engine is `mariadb` |
| MariaDB Port | `3306` | Only used when engine is `mariadb` |
| Encryption Key | *(auto)* | Leave empty to auto-generate |

## Architecture

```
Home Assistant
+-- FreeLLMApi for HA
|   +-- API Server (:3001/v1)  <-- Hermes / OpenClaw / any client
|   +-- Dashboard (Ingress)    <-- HA Web UI
|   +-- CLI Tools              <-- Add-on Terminal
|   +-- SQLite / MariaDB       <-- Encrypted key storage
+-- Hermes Add-on
|   +-- connects to :3001/v1
+-- OpenClaw Add-on
    +-- connects to :3001/v1
```

## Credits

This add-on is a port of [FreeLLMApi](https://github.com/tashfeenahmed/freellmapi)
by Tashfeen Ahmed. All credit for the core LLM gateway goes to the original
project and its contributors.

## License

MIT — see [FreeLLMApi](https://github.com/tashfeenahmed/freellmapi) for the
upstream license.

## Maintained by

[Sentinel Mexico](https://github.com/Sentinel-Mexico)
