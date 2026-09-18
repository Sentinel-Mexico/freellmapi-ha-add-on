# Syncthing Home Assistant Add-on

## What it does

Syncthing continuously synchronizes files between two or more devices in
real time. All communication is encrypted end-to-end, and no data ever
passes through a cloud server — devices connect directly to each other,
peer-to-peer.

Use it to keep photos, documents, music, or backups in sync between your
Home Assistant server, laptops, phones, and NAS devices.

## Getting started

Once the add-on is running, click **Syncthing** in the Home Assistant sidebar
to open the web interface. From there you can:

1. See your device ID (needed to pair with other devices).
2. Add remote devices by entering their device IDs.
3. Create shared folders and select which devices can access them.

You can also access Syncthing directly at:

```
http://<YOUR_HA_IP>:8384
```

Install the Syncthing app on your other devices:

- **Android** — available on Google Play and F-Droid
- **Windows / macOS / Linux** — download from syncthing.net
- **iOS** — third-party app "Möbius Sync" available on the App Store

## Shared Home Assistant directories

The add-on has access to several Home Assistant directories that you can
use as sync targets:

| Path | Description |
|------|-------------|
| `/share` | Home Assistant shared folder |
| `/media` | Home Assistant media folder |
| `/backup` | Home Assistant backup folder |

When adding a folder in Syncthing, set the folder path to one of these
directories (or a subdirectory inside them).

## Configuration

### GUI authentication

Set a username and password to protect the Syncthing web interface. This
is especially important if you access Syncthing via the direct port
(8384) rather than only through the Home Assistant sidebar.

If you leave both fields empty, the web interface is accessible without
a login. When using only Ingress (the sidebar link), Home Assistant's
own authentication protects access.

### Network ports

Syncthing uses host networking for optimal performance:

| Port | Protocol | Purpose |
|------|----------|---------|
| 8384 | TCP | Web interface |
| 22000 | TCP+UDP | Sync protocol and QUIC |
| 21027 | UDP | Local device discovery |

These ports must be open on your firewall for devices outside your
local network to connect.

## Data and backups

Syncthing configuration is stored in `/data/syncthing/config/` inside
the add-on's persistent storage. The configuration includes your device
identity (key pair), folder settings, and device connections.

Back up this directory regularly. The Home Assistant backup feature
includes add-on data automatically. If you lose the configuration, you
will need to re-pair all devices.

## Support

- [Syncthing Website](https://syncthing.net)
- [Syncthing GitHub](https://github.com/syncthing/syncthing)
- [Syncthing Documentation](https://docs.syncthing.net)
- [Syncthing Forum](https://forum.syncthing.net)
