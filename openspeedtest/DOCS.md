# OpenSpeedTest Home Assistant Add-on

## What it does

OpenSpeedTest lets you measure the speed of your local network directly
from any web browser. It tests download speed, upload speed, ping, and
jitter — all without sending any data to external servers.

Use it to check the Wi-Fi speed on different parts of your house, verify
your wired connections, or confirm your ISP speed from your Home
Assistant server.

## Getting started

Once the add-on is running, click **SpeedTest** in the Home Assistant
sidebar to open the test. Click the **START** button to begin measuring
your network speed.

You can also access OpenSpeedTest directly at:

```
http://<YOUR_HA_IP>:3000
```

## How it works

OpenSpeedTest runs entirely in your browser. When you start a test:

1. **Download test** — your browser downloads data from the add-on to
   measure download speed.
2. **Upload test** — your browser uploads data to the add-on to measure
   upload speed.
3. **Ping test** — measures the round-trip time between your device and
   the server.
4. **Jitter test** — measures the variation in ping times.

All data stays on your local network. Nothing is sent to the internet.

## What it measures

- **LAN speed** — when accessed from a device on the same network as
  Home Assistant, it measures your local network throughput (useful for
  testing Wi-Fi vs wired, switch performance, etc.).
- **WAN speed** — when accessed from outside your network (via VPN or
  port forwarding), it effectively measures your internet connection
  speed to your HA server.

## Configuration

This add-on has no configuration options. It works out of the box.

## Support

- [OpenSpeedTest Website](https://openspeedtest.com)
- [OpenSpeedTest GitHub](https://github.com/openspeedtest/Docker-Image)
