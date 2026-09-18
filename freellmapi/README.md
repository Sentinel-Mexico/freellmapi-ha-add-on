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

**FreeLLMApi for HA** es un add-on de Home Assistant que porta el proyecto open-source [FreeLLMApi](https://github.com/tashfeenahmed/freellmapi) de [Tashfeen Ahmed](https://github.com/tashfeenahmed) al ecosistema de Home Assistant. Permite agregar los tiers gratuitos de decenas de proveedores de IA detrás de un único endpoint OpenAI-compatible que corre localmente en tu instancia de HA.

El proyecto original — FreeLLMApi — resuelve un problema real: cada laboratorio de IA serio ofrece un tier gratuito (unos cuantos millones de tokens al mes, unos miles de requests al día). Cada uno por separado es limitado, pero apilados suman aproximadamente **7.4 mil millones de tokens por mes** de capacidad de inferencia, distribuidos en **474 familias de modelos / 635 endpoints** de proveedores gratuitos.

El problema de apilarlos manualmente es doloroso: treinta y cuatro SDKs diferentes, treinta y cuatro rate limits distintos, treinta y cuatro puntos de falla. FreeLLMApi colapsa todo eso en un solo endpoint compatible con OpenAI.

> [!NOTE]
> Este add-on es un port comunitario mantenido por [Sentinel Mexico](https://github.com/Sentinel-Mexico).
> Todo el crédito por el motor core va al proyecto original y sus contribuidores.

## Upstream: FreeLLMApi

Este add-on se basa en [FreeLLMApi](https://github.com/tashfeenahmed/freellmapi), un proyecto MIT que ofrece:

| Característica | Detalle |
|---------------|---------|
| **Proveedores** | 34+ proveedores gratuitos: Google, Groq, Cerebras, Mistral, OpenRouter, Cloudflare, Cohere, NVIDIA, HuggingFace, Z.ai (Zhipu), ModelScope, y 22 más |
| **Modelos** | 474 familias de modelos, 635 endpoints gratuitos (584 chat, 41 embeddings, 7 transcripción, 3 video) |
| **Tokens** | ~7.4 mil millones de tokens/mes de capacidad libre combinada |
| **Superficie API** | `/v1/chat/completions`, `/v1/completions`, `/v1/images/generations`, `/v1/audio/transcriptions`, `/v1/embeddings`, `/v1/models` |
| **Catálogo** | Auto-actualización de catálogo de modelos vía feed firmado |
| **Seguridad** | Claves cifradas con AES-256-GCM, un solo token unificado para clientes |
| **Router** | 6 estrategias de enrutamiento, failover automático con cooldowns y rotación de claves |
| **Dashboard** | UI React con soporte para 60 idiomas, temas claro/oscuro |

Para más información, consulta el [README del proyecto upstream](https://github.com/tashfeenahmed/freellmapi#readme) y el [catálogo de modelos](https://freellmapi.co/models.html).

## Features (Adaptaciones para Home Assistant)

Este add-on extiende FreeLLMApi con integración nativa al ecosistema de HA:

- **Endpoint único** — `/v1` compatible con OpenAI SDK, Anthropic SDK, y cualquier cliente OpenAI-compatible, accesible en el puerto `39101`.
- **Smart router** — selecciona automáticamente el mejor modelo disponible con claves saludables bajo sus rate limits, y realiza failover al siguiente modelo ante errores 429/5xx.
- **Dashboard vía Ingress** — accede al panel de administración directamente desde la sidebar de Home Assistant sin necesidad de abrir puertos adicionales.
- **Herramientas CLI** — configura agentes de código (Claude Code, Codex CLI, Cursor, Cline, Aider, y más) desde la terminal del add-on.
- **Base de datos flexible** — SQLite integrado por defecto, o MariaDB si usas el add-on oficial de HA.
- **Cifrado en reposo** — claves de proveedores cifradas con AES-256-GCM; auto-genera la clave de cifrado en el primer arranque.
- **Persistencia** — los datos se guardan en el almacenamiento persistente de HA (`/data/freellmapi`).
- **Multi-arquitectura** — soporta `amd64` y `aarch64` con imágenes base de Home Assistant.
- **Healthcheck** — verificación automática del servicio cada 30 segundos.

## Compatible Agents & Clients

FreeLLMApi es compatible con una amplia gama de agentes de código y clientes:

| Agente | Setup automático | Base URL |
|--------|------------------|----------|
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

> Además de cualquier cliente compatible con OpenAI, Anthropic SDK, Gemini SDK, u Ollama.

## Quick Start

### 1. Agregar el repositorio

En Home Assistant, ve a **Settings → Add-ons → Add-on Store**, haz clic en el menú de tres puntos (esquina superior derecha) → **Repositories**, pega:

```
https://github.com/Sentinel-Mexico/freellmapi-ha-add-on
```

### 2. Instalar el add-on

Busca **FreeLLMApi for HA** en la tienda y haz clic en **Install**.

### 3. Iniciar y configurar

Inicia el add-on, abre la **Web UI** desde la sidebar de Home Assistant y agrega tus claves de proveedores gratuitos.

### 4. Conectar clientes

Apunta cualquier cliente OpenAI-compatible a:

```
http://<TU_IP_HA>:39101/v1
```

O desde otro add-on en el mismo host:

```
http://homeassistant.local:39101/v1
```

## Configuration

| Opción | Default | Descripción |
|--------|---------|-------------|
| `api_port` | `39101` | Puerto para el endpoint `/v1` |
| `log_level` | `info` | Nivel de logging: `debug`, `info`, `warn`, `error` |
| `db_engine` | `sqlite` | Motor de base de datos: `sqlite` o `mariadb` |
| `mariadb_host` | `core-mariadb` | Host de MariaDB (solo con engine `mariadb`) |
| `mariadb_port` | `3306` | Puerto de MariaDB (solo con engine `mariadb`) |
| `mariadb_user` | *(vacío)* | Usuario de MariaDB |
| `mariadb_password` | *(vacío)* | Contraseña de MariaDB |
| `mariadb_database` | `freellmapi` | Nombre de la base de datos MariaDB |
| `encryption_key` | *(auto)* | Clave de cifrado AES-256-GCM; dejar vacío para auto-generar |

### Base de datos

Por defecto, FreeLLMApi usa **SQLite**, almacenando todo en un archivo dentro del almacenamiento persistente del add-on. Sin configuración adicional.

Si prefieres **MariaDB**, instala primero el add-on oficial de MariaDB, luego:

1. Cambia **Database Engine** a `mariadb`.
2. Completa host, puerto, usuario, contraseña y nombre de base de datos.
3. El host por defecto `core-mariadb` funciona con el add-on oficial de HA.

### Clave de cifrado

Tus claves de proveedor se cifran en reposo con AES-256-GCM. El add-on auto-genera una clave en el primer arranque y la persiste. Solo necesitas configurarla manualmente si migras desde una instancia existente de FreeLLMApi.

## API Endpoints

| Ruta | Descripción |
|------|-------------|
| `/v1/chat/completions` | Completions de chat (streaming soportado) |
| `/v1/completions` | Text completions |
| `/v1/embeddings` | Text embeddings |
| `/v1/images/generations` | Generación de imágenes |
| `/v1/audio/transcriptions` | Transcripción de audio |
| `/v1/models` | Listar modelos disponibles |

## CLI Tools

Abre la terminal del add-on en Home Assistant para acceder al CLI de FreeLLMApi:

```bash
freellmapi list              # Mostrar agentes de código soportados
freellmapi setup-claude      # Configurar Claude Code
freellmapi setup-cursor      # Configurar Cursor
freellmapi setup-generic     # Configurar cualquier cliente OpenAI-compatible
```

El CLI apunta automáticamente al servidor local. Agrega `--help` a cualquier comando para más detalles.

## Integration Examples

### Con Hermes

En la configuración del add-on Hermes:

- **LLM Base URL**: `http://homeassistant.local:39101/v1`
- **API Key**: la clave unificada de tu dashboard FreeLLMApi

### Con OpenClaw

En la configuración del bridge de OpenClaw:

```env
LLM_BASE_URL=http://homeassistant.local:39101/v1
LLM_API_KEY=freellmapi-...
```

### Python / OpenAI SDK

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://<TU_IP_HA>:39101/v1",
    api_key="freellmapi-..."  # desde el dashboard
)

response = client.chat.completions.create(
    model="auto",
    messages=[{"role": "user", "content": "¡Hola!"}]
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
├── cli/                     # CLI para configurar agentes de código
│   ├── src/                 # Código fuente TypeScript
│   └── tools.json           # Definición de herramientas CLI
├── client/                  # Dashboard React (Vite)
│   ├── src/                 # Componentes y lógica de UI
│   └── vite.config.ts       # Configuración de Vite
├── server/                  # Servidor API Node.js
│   ├── src/                 # Código fuente TypeScript
│   └── vitest.config.ts     # Configuración de tests
├── shared/                  # Módulos compartidos entre server/client/cli
├── translations/            # Traducciones del add-on para HA
├── config.yaml              # Manifiesto del add-on (metadatos, opciones, esquema)
├── build.yaml               # Configuración de build multi-arch
├── Dockerfile               # Build multi-stage (builder + runtime Alpine)
├── run.sh                   # Script de arranque (bashio, env, nginx, node)
├── nginx-ingress.conf       # Proxy inverso para Ingress de HA
├── DOCS.md                  # Documentación visible desde HA
├── CHANGELOG.md             # Historial de cambios
├── icon.png                 # Icono del add-on (256x256)
└── logo.png                 # Logo del add-on
```

## Credits

- **Proyecto original:** [FreeLLMApi](https://github.com/tashfeenahmed/freellmapi) por [Tashfeen Ahmed](https://github.com/tashfeenahmed)
- **Port para Home Assistant:** [Sentinel Mexico](https://github.com/Sentinel-Mexico)

## License

Este add-on está licenciado bajo **MIT**, al igual que el proyecto upstream FreeLLMApi.

---

<div align="center">

**Maintained by [Sentinel Mexico](https://github.com/Sentinel-Mexico)**

</div>
