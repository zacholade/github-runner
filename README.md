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
      - PAT=<personal-access-token>
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```

## Environment Variables

| Variable | Required | Description |
|---|---|---|
| `REPO_URL` | Yes | Repository URL (e.g. `https://github.com/owner/repo`) |
| `PAT` | Yes | GitHub Personal Access Token with `repo` scope |
| `RUNNER_NAME` | No | Runner name (default: `self-hosted-docker`) |
| `RUNNER_LABELS` | No | Comma-separated labels (default: `self-hosted`) |

A fresh registration token is generated from the PAT on each container start, so the runner survives restarts without manual token rotation.

## Creating a PAT

Go to GitHub **Settings → Developer settings → Personal access tokens → Fine-grained tokens** and create a token with **Administration (read & write)** permission on the target repository.

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
