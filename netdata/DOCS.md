# Netdata Home Assistant Add-on

## What it does

Netdata is a real-time infrastructure monitoring agent. It collects
thousands of system and application metrics per second — CPU, memory,
disk I/O, network traffic, running processes, and more — and presents
them in interactive, auto-updating dashboards.

Everything runs locally. No cloud account is needed to view your metrics.

## Getting started

Once the add-on is running, click **Netdata** in the Home Assistant sidebar
to open the monitoring dashboard. You will see live charts updating in
real time.

You can also access Netdata directly at:

```
http://<YOUR_HA_IP>:19999
```

## What is monitored

Netdata automatically detects and monitors:

| Category | Examples |
|----------|----------|
| CPU | Usage per core, frequency, interrupts, context switches |
| Memory | RAM, swap, page cache, committed, huge pages |
| Disk | I/O bandwidth, operations, latency, space, inodes |
| Network | Bandwidth, packets, errors, drops per interface |
| Processes | By name, CPU/memory per process, forks, threads |
| System | Uptime, load average, entropy, IPC |

## Configuration

### Log Level

Controls how much detail appears in the add-on logs.

- **debug** — very verbose, useful for troubleshooting collection issues
- **info** — normal operation (default)
- **warning** — only warnings and errors
- **error** — only errors

## Data retention

Netdata stores metrics in its internal time-series database (dbengine)
inside the add-on's persistent storage. The default allocation is 256 MB,
which typically holds several days of per-second data depending on the
number of metrics collected.

The data survives add-on restarts and updates. Home Assistant backups
include add-on data automatically.

## Performance

Netdata is designed to be lightweight:

- Typically uses less than 1% CPU
- Memory usage scales with the number of metrics collected (usually 50-150 MB)
- Disk I/O is minimal thanks to an efficient database engine

## Support

- [Netdata Website](https://www.netdata.cloud)
- [Netdata GitHub](https://github.com/netdata/netdata)
- [Netdata Documentation](https://learn.netdata.cloud)
- [Netdata Community](https://community.netdata.cloud)
