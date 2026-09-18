<div align="center">

# OpenSpeedTest for Home Assistant

[![Version](https://img.shields.io/badge/version-1.0.0-blue?style=for-the-badge)](config.yaml)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](https://github.com/openspeedtest/Docker-Image/blob/main/LICENSE)
[![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Add--on-41BDF5?style=for-the-badge&logo=homeassistant&logoColor=white)](https://www.home-assistant.io/)
[![Upstream](https://img.shields.io/badge/Upstream-OpenSpeedTest-blue?style=for-the-badge&logo=github)](https://github.com/openspeedtest/Docker-Image)
[![amd64](https://img.shields.io/badge/arch-amd64-informational?style=for-the-badge)](build.yaml)
[![aarch64](https://img.shields.io/badge/arch-aarch64-informational?style=for-the-badge)](build.yaml)

**Self-hosted network speed test for your household.**
**Measure download, upload, ping, and jitter -- no external servers needed.**

</div>

---

## About

**OpenSpeedTest for HA** is a Home Assistant add-on that packages [OpenSpeedTest](https://openspeedtest.com) to run as a supervised add-on within Home Assistant.

OpenSpeedTest is an HTML5-based network speed test that runs entirely in the browser. It measures download speed, upload speed, ping, and jitter without sending any data outside your local network. It works on any modern browser — desktop, mobile, and even smart TVs.

> [!NOTE]
> This is a community port. All credit for OpenSpeedTest goes to the original
> project and its contributors.

## Features

- **Download speed** -- measure how fast your device downloads from the server.
- **Upload speed** -- measure how fast your device uploads to the server.
- **Ping** -- round-trip latency between your device and the server.
- **Jitter** -- variation in ping times for connection stability.
- **100% local** -- all data stays on your network, nothing sent to the internet.
- **Zero config** -- works out of the box, no settings needed.
- **Any browser** -- HTML5-based, works on desktop, mobile, and smart TVs.
- **Lightweight** -- static files served by nginx, minimal resource usage.
- **Web interface** -- accessible from the HA sidebar via Ingress.
- **Multi-architecture** -- supports `amd64` and `aarch64`.

## Quick Start

1. Install the add-on from the Home Assistant Add-on Store.
2. Start the add-on -- SpeedTest will appear in the sidebar.
3. Click **SpeedTest** in the sidebar.
4. Click **START** to begin the speed test.

## Use Cases

- **Test Wi-Fi coverage** -- run the test from different rooms to find dead spots.
- **Verify wired connections** -- confirm gigabit speeds on wired devices.
- **ISP speed check** -- measure your internet speed from the HA server.
- **Network troubleshooting** -- compare speeds across devices and connections.

## Architecture

```
Home Assistant
├── OpenSpeedTest Add-on
│   ├── Nginx Web Server (:3000)   ◄── Any web browser on the network
│   ├── Web Interface (Ingress)    ◄── HA Web UI sidebar
│   └── HTML5 Speed Test Engine    ◄── Runs entirely in the browser
```

## Support

- [OpenSpeedTest Website](https://openspeedtest.com)
- [OpenSpeedTest GitHub](https://github.com/openspeedtest/Docker-Image)
