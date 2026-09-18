<div align="center">

# Netdata for Home Assistant

[![Version](https://img.shields.io/badge/version-1.0.0-blue?style=for-the-badge)](config.yaml)
[![License](https://img.shields.io/badge/License-GPL--3.0-green?style=for-the-badge)](https://github.com/netdata/netdata/blob/master/LICENSE)
[![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Add--on-41BDF5?style=for-the-badge&logo=homeassistant&logoColor=white)](https://www.home-assistant.io/)
[![Upstream](https://img.shields.io/badge/Upstream-Netdata-blue?style=for-the-badge&logo=github)](https://github.com/netdata/netdata)
[![amd64](https://img.shields.io/badge/arch-amd64-informational?style=for-the-badge)](build.yaml)
[![aarch64](https://img.shields.io/badge/arch-aarch64-informational?style=for-the-badge)](build.yaml)

**Real-time infrastructure monitoring for your Home Assistant server.**
**Thousands of metrics per second with beautiful, interactive dashboards.**

</div>

---

## About

**Netdata for HA** is a Home Assistant add-on that packages [Netdata](https://www.netdata.cloud) to run as a supervised add-on within Home Assistant.

Netdata is an open-source monitoring agent that collects per-second metrics from systems, hardware, containers, and applications. It features an interactive web dashboard with hundreds of auto-generated charts, intelligent alerts, and a highly efficient time-series database — all running locally with no cloud dependency.

> [!NOTE]
> This is a community port. All credit for Netdata goes to the original
> project and its contributors.

## Features

- **Per-second metrics** -- thousands of data points collected every second.
- **Zero configuration** -- auto-detects hardware, OS, containers, and applications.
- **Interactive dashboards** -- zoomable, pannable, real-time charts.
- **Lightweight** -- typically under 1% CPU and 100 MB RAM.
- **Persistent storage** -- dbengine keeps days of per-second history.
- **Process monitoring** -- detailed per-process CPU, memory, I/O, and network.
- **Disk health** -- S.M.A.R.T. monitoring for disk failure prediction.
- **Network analysis** -- per-interface bandwidth, packets, errors, and drops.
- **No cloud required** -- everything runs locally on your HA server.
- **Web interface** -- accessible from the HA sidebar via Ingress.
- **Multi-architecture** -- supports `amd64` and `aarch64`.

## Quick Start

1. Install the add-on from the Home Assistant Add-on Store.
2. Start the add-on -- Netdata will appear in the sidebar.
3. Click **Netdata** in the sidebar to open the monitoring dashboard.
4. Charts auto-populate with system metrics immediately.

## Configuration

| Option | Default | Description |
|--------|---------|-------------|
| Log Level | `info` | `debug`, `info`, `warning`, or `error`. |

## Architecture

```
Home Assistant
├── Netdata Add-on
│   ├── Netdata Agent              ◄── Metric collection engine
│   ├── Web Dashboard (:19999)     ◄── Interactive charts / Ingress
│   ├── Time-Series DB (dbengine)  ◄── Persistent metric storage
│   └── Plugin Collectors          ◄── CPU, memory, disk, network, etc.
```

## Monitored Metrics

| Category | Examples |
|----------|----------|
| CPU | Per-core usage, frequency, interrupts, context switches |
| Memory | RAM, swap, page cache, committed, huge pages |
| Disk | I/O bandwidth, operations, latency, space, inodes |
| Network | Per-interface bandwidth, packets, errors, drops |
| Processes | By name, CPU and memory per process, forks, threads |
| System | Uptime, load average, entropy, IPC |

## Support

- [Netdata Website](https://www.netdata.cloud)
- [Netdata GitHub](https://github.com/netdata/netdata)
- [Netdata Documentation](https://learn.netdata.cloud)
- [Netdata Community](https://community.netdata.cloud)
