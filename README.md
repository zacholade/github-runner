# Self-Hosted GitHub Actions Runner

Dockerised self-hosted GitHub Actions runner with Docker-in-Docker support. Supports both `amd64` and `arm64` architectures.

## Quick Start

```yaml
services:
  github-runner:
    image: ghcr.io/zacholade/github-runner:latest
    restart: unless-stopped
    environment:
      - REPO_URL=https://github.com/<owner>/<repo>
      - TOKEN=<registration-token>
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```

## Environment Variables

| Variable | Required | Description |
|---|---|---|
| `REPO_URL` | Yes | Repository URL (e.g. `https://github.com/owner/repo`) |
| `TOKEN` | Yes | Runner registration token |
| `RUNNER_NAME` | No | Runner name (default: `self-hosted-docker`) |
| `RUNNER_LABELS` | No | Comma-separated labels (default: `self-hosted`) |

## Getting a Registration Token

Go to your repository **Settings → Actions → Runners → New self-hosted runner**. The token is shown in the configure step.

## Usage in Workflows

```yaml
jobs:
  build:
    runs-on: self-hosted
```

## What's Included

- Docker CLI (uses host Docker via socket mount)
- AWS CLI
- Git, curl, jq
- Auto-deregisters on container stop
