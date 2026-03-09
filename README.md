<div align="center">

# NDN Sentinel

**Lightweight Endpoint Detection & Response for Linux Infrastructure**

[![Built with Rust](https://img.shields.io/badge/Built%20with-Rust-orange?style=flat-square)](https://www.rust-lang.org/)
[![Platform](https://img.shields.io/badge/Platform-Linux-blue?style=flat-square)](https://www.linux.org/)
[![License](https://img.shields.io/badge/License-Proprietary-red?style=flat-square)]()
[![Agent Size](https://img.shields.io/badge/Memory-14MB-green?style=flat-square)]()

*Real-time threat detection without the performance overhead.*

</div>

---

## The Problem

Organizations running Linux infrastructure spend thousands per month on compute — GPU clusters, AI training, model inference, bare metal servers — with zero endpoint protection. Legacy EDR tools consume 500MB+ of memory and degrade workload performance. For environments where every resource matters, that tradeoff isn't acceptable.

## The Solution

NDN Sentinel is a purpose-built Linux EDR agent that delivers real-time threat detection at a fraction of the resource cost. Designed for performance-sensitive infrastructure including GPU clouds, AI platforms, and high-compute environments.

![NDN Sentinel Dashboard](Screenshot%202026-03-09%20112515.png)

## Key Capabilities

- **20 Real-Time Detection Types** — Cryptominers, reverse shells, fileless malware, process injection, web shells, C2 connections, and more
- **14MB Memory Footprint** — 35x lighter than legacy EDR solutions
- **One-Command Deployment** — Install and protect in under 30 seconds
- **Real-Time Email Alerts** — Instant notification on critical threats
- **Multi-Tenant Architecture** — Per-organization data isolation and access control
- **Agent Self-Protection** — Anti-tamper and anti-debug capabilities
- **Automated Threat Response** — Malicious processes terminated automatically
- **Auto-Updates** — Agent stays current without manual intervention

## Quick Start
```bash
curl -sL https://raw.githubusercontent.com/phayes00/ndn-sentinel/main/install.sh | sudo bash -s -- \
  --org-id <YOUR_ORG_ID> \
  --supabase-url <SUPABASE_URL> \
  --supabase-key <SUPABASE_KEY>
```

Agent starts protecting immediately as a systemd service.

## Uninstall
```bash
curl -sL https://raw.githubusercontent.com/phayes00/ndn-sentinel/main/uninstall.sh | sudo bash
```

## System Requirements

| Requirement | Minimum |
|------------|---------|
| OS | Any systemd-based Linux (Ubuntu, Debian, RHEL, Fedora, Arch, Amazon Linux) |
| Architecture | x86_64 |
| Memory | 14MB |
| Disk | 20MB |
| Permissions | Root |

## How It Works

NDN Sentinel runs as a lightweight background service that continuously monitors system activity across multiple detection vectors. Threats are detected in real time, logged to a centralized dashboard, and optionally trigger email alerts and automated response actions.

All telemetry is scoped to your organization with full data isolation between tenants.

## Dashboard

The management dashboard provides:

- Endpoint visibility and health monitoring
- Real-time alert feed with severity filtering
- Threat breakdown and timeline analysis
- Agent performance metrics (CPU, memory, uptime)
- Team management and notification settings
- One-click install command generation

## Proven in Production

NDN Sentinel has detected real-world threats on live infrastructure including suspicious C2 connections, SSH brute force attempts, and unauthorized process execution — with zero false positives on production workloads.

## Contact

**Patrick Hayes** — Founder, NDN Innovations

Email: ndnsentinel@gmail.com

---

<div align="center">

*NDN Sentinel — Protection without the performance penalty.*

</div>
