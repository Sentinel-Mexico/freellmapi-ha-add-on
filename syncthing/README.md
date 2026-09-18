<div align="center">

# Syncthing for Home Assistant

[![Version](https://img.shields.io/badge/version-1.0.0-blue?style=for-the-badge)](config.yaml)
[![License](https://img.shields.io/badge/License-MPL--2.0-green?style=for-the-badge)](https://github.com/syncthing/syncthing/blob/main/LICENSE)
[![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Add--on-41BDF5?style=for-the-badge&logo=homeassistant&logoColor=white)](https://www.home-assistant.io/)
[![Upstream](https://img.shields.io/badge/Upstream-Syncthing-blue?style=for-the-badge&logo=github)](https://github.com/syncthing/syncthing)
[![amd64](https://img.shields.io/badge/arch-amd64-informational?style=for-the-badge)](build.yaml)
[![aarch64](https://img.shields.io/badge/arch-aarch64-informational?style=for-the-badge)](build.yaml)

**Continuous file synchronization for your household.**
**Keep files in sync across all your devices -- encrypted and peer-to-peer.**

</div>

---

## About

**Syncthing for HA** is a Home Assistant add-on that packages [Syncthing](https://syncthing.net) to run as a supervised add-on within Home Assistant.

Syncthing is an open-source continuous file synchronization program that encrypts all communication end-to-end and operates peer-to-peer without any cloud service. It runs on Windows, macOS, Linux, Android, and more, keeping your files synchronized in real time across all your devices.

> [!NOTE]
> This is a community port. All credit for Syncthing goes to the original
> project and its contributors.

## Features

- **Real-time sync** -- files synchronize automatically as they change.
- **End-to-end encryption** -- all data transfers are encrypted with TLS.
- **Peer-to-peer** -- no cloud, no third-party servers, no accounts.
- **Selective sync** -- choose which folders to share with which devices.
- **File versioning** -- keep old versions of files for recovery.
- **Conflict handling** -- automatic conflict resolution with manual override.
- **Local discovery** -- devices on the same network find each other automatically.
- **NAT traversal** -- works across networks with relay fallback.
- **HA directory access** -- sync to/from Home Assistant shared, media, and backup folders.
- **Web interface** -- accessible from the HA sidebar via Ingress.
- **Lightweight** -- single Go binary, minimal resource usage.
- **Multi-architecture** -- supports `amd64` and `aarch64`.

## Quick Start

1. Install the add-on from the Home Assistant Add-on Store.
2. Start the add-on -- Syncthing will appear in the sidebar.
3. Click **Syncthing** in the sidebar to open the web interface.
4. Note your device ID (shown on the main screen).
5. Install Syncthing on another device and add each device's ID to the other.
6. Create a shared folder and select the connected device.

## Configuration

| Option | Default | Description |
|--------|---------|-------------|
| Log Level | `info` | `debug`, `info`, `warn`, or `error`. |
| GUI Username | *(empty)* | Web interface login username. |
| GUI Password | *(empty)* | Web interface login password. |

## Architecture

```
Home Assistant
├── Syncthing Add-on
│   ├── Syncthing Server             ◄── Peer-to-peer sync engine
│   ├── Web GUI (:8384)              ◄── Web browser / Ingress sidebar
│   ├── Sync Protocol (:22000)       ◄── Device-to-device transfers
│   ├── Local Discovery (:21027)     ◄── LAN device detection
│   └── HA Directories               ◄── /share, /media, /backup
```

## Network Ports

| Port | Protocol | Purpose |
|------|----------|---------|
| 8384 | TCP | Web interface and REST API |
| 22000 | TCP+UDP | Sync protocol and QUIC |
| 21027 | UDP | Local device discovery |

## Support

- [Syncthing Website](https://syncthing.net)
- [Syncthing GitHub](https://github.com/syncthing/syncthing)
- [Syncthing Documentation](https://docs.syncthing.net)
- [Syncthing Forum](https://forum.syncthing.net)
