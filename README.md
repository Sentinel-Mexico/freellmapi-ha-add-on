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

## Descripción del Proyecto

Este repositorio contiene add-ons de Home Assistant mantenidos por [Sentinel Mexico](https://github.com/Sentinel-Mexico). El add-on principal es **FreeLLMApi for HA**, un port del proyecto open-source [FreeLLMApi](https://github.com/tashfeenahmed/freellmapi) de [Tashfeen Ahmed](https://github.com/tashfeenahmed), adaptado para ejecutarse como add-on supervisado dentro del ecosistema de Home Assistant.

FreeLLMApi agrega los tiers gratuitos de más de 34 proveedores de IA (Google, Groq, Mistral, Cohere, NVIDIA, entre otros) detrás de un único endpoint compatible con OpenAI (`/v1`). Incluye enrutamiento inteligente, failover automático cuando un proveedor está limitado por rate, almacenamiento de claves cifrado con AES-256-GCM y seguimiento de uso por clave.

> [!NOTE]
> Este proyecto es un port comunitario. Todo el crédito por el motor central de LLM va al
> proyecto original [FreeLLMApi](https://github.com/tashfeenahmed/freellmapi) y sus contribuidores.

## Overview

El objetivo de este repositorio es proporcionar a los usuarios de Home Assistant acceso a cientos de modelos de IA gratuitos sin necesidad de infraestructura externa. Al instalar este add-on, tu instancia de Home Assistant se convierte en un gateway local de LLMs que cualquier servicio o automatización puede consumir a través del estándar OpenAI API.

```
Home Assistant
├── FreeLLMApi for HA
│   ├── API Server (:39101/v1)  ◄── Hermes / OpenClaw / cualquier cliente
│   ├── Dashboard (Ingress)     ◄── UI Web de HA
│   ├── CLI Tools               ◄── Terminal del Add-on
│   └── SQLite / MariaDB        ◄── Almacenamiento cifrado de claves
├── Hermes Add-on
│   └── conecta a :39101/v1
└── OpenClaw Add-on
    └── conecta a :39101/v1
```

## Key Features

- **Endpoint único** — `/v1` compatible con el SDK de OpenAI, Anthropic y cualquier cliente OpenAI-compatible.
- **Smart router** — selecciona el mejor modelo disponible y realiza failover automático cuando un proveedor alcanza su rate limit.
- **34+ proveedores** — Google, Groq, Mistral, Cohere, NVIDIA, Cerebras, OpenRouter, Cloudflare, HuggingFace, Z.ai y más.
- **635 endpoints de modelos gratuitos** — chat, embeddings, transcripción de audio e imágenes.
- **Almacenamiento cifrado** — claves API cifradas con AES-256-GCM en reposo.
- **Dashboard integrado** — gestiona claves, visualiza uso y genera tokens API desde la UI de Home Assistant (Ingress).
- **Herramientas CLI** — configura agentes de código (Claude Code, Cursor, Cline, Aider, etc.) desde la terminal del add-on.
- **Base de datos flexible** — SQLite por defecto con soporte opcional para MariaDB.
- **Listo para integración** — funciona con Hermes, OpenClaw o cualquier servicio que hable el formato OpenAI API.
- **Multi-arquitectura** — soporta `amd64` y `aarch64`.

## Add-ons Disponibles

| Add-on | Descripción | Versión |
|--------|-------------|---------|
| [FreeLLMApi for HA](freellmapi/) | Gateway de LLMs gratuitos con 34+ proveedores | 1.0.4 |

## Installation & Setup

### Requisitos previos

- Home Assistant OS o Home Assistant Supervised.
- Acceso a **Settings → Add-ons → Add-on Store**.

### Pasos de instalación

1. En Home Assistant, ve a **Settings → Add-ons → Add-on Store**.
2. Haz clic en el menú de tres puntos (esquina superior derecha) → **Repositories**.
3. Pega la URL de este repositorio y haz clic en **Add**:
   ```
   https://github.com/Sentinel-Mexico/freellmapi-ha-add-on
   ```
4. Busca **FreeLLMApi for HA** en la tienda, haz clic en **Install**.
5. Inicia el add-on y abre la **Web UI** para agregar tus claves de proveedor gratuito.
6. Apunta Hermes, OpenClaw, o cualquier cliente OpenAI a:
   ```
   http://<TU_IP_HA>:39101/v1
   ```

### Ejemplos de integración

#### Hermes

Configura la URL base del LLM en Hermes:

```
http://homeassistant.local:39101/v1
```

#### OpenClaw

Configura `LLM_BASE_URL` en el bridge de OpenClaw:

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
    messages=[{"role": "user", "content": "Apaga las luces de la sala"}]
)
```

## Configuration

| Opción | Default | Descripción |
|--------|---------|-------------|
| API Port | `39101` | Puerto para el endpoint `/v1` |
| Log Level | `info` | Nivel de logging: `debug`, `info`, `warn`, `error` |
| Database Engine | `sqlite` | `sqlite` o `mariadb` |
| MariaDB Host | `core-mariadb` | Solo cuando el engine es `mariadb` |
| MariaDB Port | `3306` | Solo cuando el engine es `mariadb` |
| Encryption Key | *(auto)* | Dejar vacío para auto-generar |

## Tech Stack

| Tecnología | Uso |
|------------|-----|
| **Node.js 20** | Runtime del servidor API y CLI |
| **TypeScript** | Lenguaje de desarrollo (server, client, CLI) |
| **React + Vite** | Dashboard web (client) |
| **SQLite / MariaDB** | Persistencia de claves y estadísticas |
| **Nginx** | Proxy inverso para Ingress de Home Assistant |
| **Docker** | Multi-stage build (Alpine base) |
| **Bash (bashio)** | Script de arranque e integración con HA Supervisor |

## Repository Structure

```
.
├── freellmapi/              # Add-on principal
│   ├── cli/                 # Herramientas CLI para agentes de código
│   ├── client/              # Dashboard React (Vite)
│   ├── server/              # Servidor API Node.js
│   ├── shared/              # Módulos compartidos
│   ├── translations/        # Traducciones del add-on
│   ├── CHANGELOG.md         # Historial de cambios del add-on
│   ├── DOCS.md              # Documentación del add-on (visible en HA)
│   ├── Dockerfile           # Build multi-stage
│   ├── build.yaml           # Configuración de build para HA
│   ├── config.yaml          # Manifiesto del add-on
│   ├── nginx-ingress.conf   # Configuración de proxy Ingress
│   ├── package.json         # Monorepo workspaces
│   └── run.sh               # Script de arranque (bashio)
├── public/
│   └── icons/               # Iconos del repositorio
├── README.md                # Este archivo
└── repository.yaml          # Manifiesto del repositorio de add-ons
```

## Documentation

- [Documentación del add-on (DOCS.md)](freellmapi/DOCS.md) — Guía completa visible desde Home Assistant.
- [Changelog](freellmapi/CHANGELOG.md) — Historial de cambios por versión.
- [FreeLLMApi original](https://github.com/tashfeenahmed/freellmapi) — Documentación del proyecto upstream.
- [FreeLLMApi Models Catalog](https://freellmapi.co/models.html) — Catálogo completo de modelos gratuitos.

## Contributing

Las contribuciones son bienvenidas. Si deseas aportar:

1. Haz fork de este repositorio.
2. Crea una rama desde `main` con un nombre descriptivo.
3. Realiza tus cambios y asegúrate de que el build de Docker funciona correctamente.
4. Abre un Pull Request describiendo los cambios.

Para contribuciones al motor core de LLM, dirígete al [repositorio upstream de FreeLLMApi](https://github.com/tashfeenahmed/freellmapi).

## Credits

Este add-on es un port de [FreeLLMApi](https://github.com/tashfeenahmed/freellmapi)
por [Tashfeen Ahmed](https://github.com/tashfeenahmed). Todo el crédito por el gateway
core de LLM va al proyecto original y sus contribuidores.

## License

MIT — consulta el [repositorio original de FreeLLMApi](https://github.com/tashfeenahmed/freellmapi) para la licencia upstream.

---

<div align="center">

**Maintained by [Sentinel Mexico](https://github.com/Sentinel-Mexico)**

</div>
