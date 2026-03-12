# AI Server Monitoring Stack

Production-ready monitoring stack for GPU AI servers using Prometheus, Grafana, and exporters.

This stack provides real-time monitoring for:

- GPU utilization
- GPU temperature
- GPU power consumption
- system CPU / memory
- container health
- disk usage
- Podman container metrics

The system is designed for **AI / ML training servers** and supports **GPU monitoring using NVIDIA DCGM exporter**.

---

# Architecture

Internet
↓
Cloudflare Tunnel
↓
Ubuntu Server

Podman Containers
├── Grafana
├── Prometheus
├── DCGM GPU Exporter
└── Podman Exporter

↓
Grafana Dashboards

Monitoring flow:

Exporters → Prometheus → Grafana

Alert flow:

Prometheus → Alert rules → Alertmanager → Telegram (optional)

---

# Stack Components

| Component | Purpose |
|---|---|
| Prometheus | Time-series metrics database |
| Grafana | Visualization dashboards |
| DCGM Exporter | NVIDIA GPU metrics |
| Podman Exporter | Podman container metrics |
| Node Exporter | System hardware metrics |
| Cloudflare Tunnel | Secure remote access |

---

# Repository Structure

```
monitoring/
│
├── podman-compose.yml
│
├── prometheus/
│   ├── prometheus.yml
│   └── alerts_ai_server.yml
│
├── grafana/
│   └── provisioning/
│       ├── datasources/
│       ├── dashboards/
│       ├── alerting/
│       └── plugins/
│
├── data/                # runtime storage (ignored by git)
│   ├── grafana/
│   └── prometheus/
│
└── .gitignore
```

---

# Requirements

Minimum recommended server specs for AI monitoring:

| Resource | Recommended |
|---|---|
CPU | 4 cores |
RAM | 8GB |
Disk | 50GB |
GPU | NVIDIA RTX / A-series |

Software requirements:

```
Ubuntu 22.04 / 24.04
Podman
Podman Compose
NVIDIA driver
```

Optional:

```
Cloudflare Tunnel
Tailscale
```

---

# Installation

Clone repository:

```bash
git clone <repo-url>
cd monitoring
```

Start monitoring stack:

```bash
podman compose up -d
```

Verify containers:

```bash
podman ps
```

Expected:

```
grafana
prometheus
dcgm-exporter
prometheus-podman-exporter
```

---

# Access Services

| Service | URL |
|---|---|
Grafana | http://localhost:3000 |
Prometheus | http://localhost:9090 |

Remote access (via Cloudflare Tunnel):

```
https://grafana-dev.chrest-studio.com
https://prometheus-dev.chrest-studio.com
```

---

# Default Credentials

Grafana:

```
username: admin
password: admin
```

Change immediately in production.

---

# GPU Monitoring

GPU metrics are provided by **NVIDIA DCGM exporter**.

Metrics include:

| Metric | Description |
|---|---|
GPU temperature | thermal monitoring |
GPU utilization | compute load |
GPU memory usage | VRAM usage |
GPU power usage | power draw |
GPU clock speed | GPU throttling detection |

Verify metrics:

```bash
curl http://localhost:9400/metrics
```

---

# Prometheus Targets

Configured scrape targets:

```
node exporter      :9100
process exporter   :9256
podman exporter    :9882
prometheus         :9090
dcgm exporter      :9400
```

Prometheus config:

```
prometheus/prometheus.yml
```

---

# Alert Rules

Production AI server alerts included:

- GPU overheating
- GPU memory exhaustion
- GPU ECC errors
- GPU clock throttling
- GPU PCIe errors
- container crash loops
- container OOM
- high CPU usage
- memory leaks
- disk saturation
- disk latency spikes

Alert rules file:

```
prometheus/alerts_ai_server.yml
```

Reload Prometheus after changes:

```bash
curl -X POST http://localhost:9090/-/reload
```

---

# Grafana Dashboards

Recommended dashboards:

| Dashboard | Purpose |
|---|---|
Node Exporter Full | system metrics |
Podman Exporter | container metrics |
NVIDIA GPU Dashboard | GPU performance |

Import dashboards from:

https://grafana.com/grafana/dashboards/

---

# Runtime Data

Runtime data is stored in:

```
data/prometheus/
data/grafana/
```

These directories contain:

- TSDB metrics storage
- Grafana SQLite database
- WAL logs

These files are **ignored by git**.

---

# Updating Stack

Pull new images:

```bash
podman compose pull
```

Restart stack:

```bash
podman compose down
podman compose up -d
```

---

# Troubleshooting

Check Prometheus targets:

```
http://localhost:9090/targets
```

Check GPU metrics:

```bash
curl http://localhost:9400/metrics
```

Check container metrics:

```bash
curl http://localhost:9882/metrics
```

Check cloudflared logs:

```bash
journalctl -u cloudflared -f
```

---

# Security Recommendations

For production deployment:

- restrict Grafana access via Cloudflare Access
- use strong Grafana admin password
- enable TLS if exposing locally
- restrict SSH access
- enable firewall rules

---

# Maintenance

Recommended tasks:

| Task | Frequency |
|---|---|
update container images | monthly |
backup Grafana DB | weekly |
check alert rules | quarterly |
review disk usage | weekly |

---

# License

Internal infrastructure tooling.

---

# Author

AI Monitoring Stack for GPU servers.
```

---
