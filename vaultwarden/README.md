<div align="center">

# Vaultwarden for Home Assistant

[![Version](https://img.shields.io/badge/version-1.0.0-blue?style=for-the-badge)](config.yaml)
[![License](https://img.shields.io/badge/License-AGPL--3.0-green?style=for-the-badge)](https://github.com/dani-garcia/vaultwarden/blob/main/LICENSE.txt)
[![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Add--on-41BDF5?style=for-the-badge&logo=homeassistant&logoColor=white)](https://www.home-assistant.io/)
[![Upstream](https://img.shields.io/badge/Upstream-Vaultwarden-blue?style=for-the-badge&logo=github)](https://github.com/dani-garcia/vaultwarden)
[![amd64](https://img.shields.io/badge/arch-amd64-informational?style=for-the-badge)](build.yaml)
[![aarch64](https://img.shields.io/badge/arch-aarch64-informational?style=for-the-badge)](build.yaml)

**Self-hosted password manager for your entire household.**
**Bitwarden-compatible -- works with every official Bitwarden client.**

</div>

---

## About

**Vaultwarden for HA** is a Home Assistant add-on that packages [Vaultwarden](https://github.com/dani-garcia/vaultwarden) by [Daniel Garcia](https://github.com/dani-garcia) to run as a supervised add-on within Home Assistant.

Vaultwarden is a lightweight, Rust-based implementation of the Bitwarden server API. It supports passwords, TOTP tokens, passkeys (FIDO2/WebAuthn), file attachments, Bitwarden Send, organization vaults, and emergency access -- all with a fraction of the resources the official Bitwarden server requires.

> [!NOTE]
> This is a community port. All credit for Vaultwarden goes to the original
> project and its contributors.

## Features

- **Full Bitwarden compatibility** -- works with all official Bitwarden browser extensions, desktop apps, and mobile apps.
- **Passwords & TOTP** -- store login credentials with built-in two-factor code generation.
- **Passkeys** -- FIDO2/WebAuthn support for passwordless authentication.
- **Bitwarden Send** -- securely share text or files with expiring links.
- **Organizations** -- share vaults between family members or household users.
- **File attachments** -- attach files to vault items.
- **Emergency access** -- grant trusted contacts access in case of emergency.
- **Web vault** -- full web interface accessible from the HA sidebar via Ingress.
- **Admin panel** -- manage users and server settings from `/admin`.
- **Lightweight** -- under 50 MB RAM; SQLite database; no MSSQL needed.
- **Multi-architecture** -- supports `amd64` and `aarch64`.

## Quick Start

1. Install the add-on from the Home Assistant Add-on Store.
2. Start the add-on -- Vaultwarden will be available in the sidebar.
3. Click **Vaultwarden** in the sidebar to open the web vault.
4. Create your first account.
5. **Disable signups** in the add-on configuration once all accounts are created.
6. Install a Bitwarden client on your devices and point it to `http://<HA_IP>:8080`.

## Configuration

| Option | Default | Description |
|--------|---------|-------------|
| Allow Signups | `true` | Let new users register. Disable after setup. |
| Admin Token | *(empty)* | Secret to access `/admin`. Leave empty to disable. |
| Log Level | `info` | `debug`, `info`, `warn`, or `error`. |
| Domain | *(empty)* | Full URL for external access (e.g. `https://vault.example.com`). |
| SMTP Host | *(empty)* | Mail server for email features. Leave empty to disable. |
| SMTP Port | `587` | Mail server port. |
| SMTP Security | `starttls` | `starttls`, `force_tls`, or `off`. |
| SMTP Username | *(empty)* | Mail server authentication. |
| SMTP Password | *(empty)* | Mail server authentication. |
| SMTP From | *(empty)* | Sender address for outgoing emails. |

## Architecture

```
Home Assistant
├── Vaultwarden Add-on
│   ├── Vaultwarden Server (:8080)  ◄── Bitwarden clients
│   ├── Web Vault (Ingress)         ◄── HA Web UI sidebar
│   ├── Admin Panel (/admin)        ◄── Server management
│   └── SQLite DB                   ◄── Encrypted vault storage
├── Bitwarden Browser Extension
│   └── connects to :8080
└── Bitwarden Mobile App
    └── connects to :8080
```

## Support

- [Vaultwarden GitHub](https://github.com/dani-garcia/vaultwarden)
- [Vaultwarden Wiki](https://github.com/dani-garcia/vaultwarden/wiki)
- [Bitwarden Help Center](https://bitwarden.com/help/)
