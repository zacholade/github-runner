#!/bin/bash
set -e

if [ -z "$REPO_URL" ] || [ -z "$TOKEN" ]; then
  echo "Error: REPO_URL and TOKEN environment variables are required"
  exit 1
fi

# Register the runner
./config.sh --url "$REPO_URL" --token "$TOKEN" --unattended --replace --name "${RUNNER_NAME:-self-hosted-docker}" --labels "${RUNNER_LABELS:-self-hosted}"

# Deregister on exit
cleanup() {
  echo "Removing runner..."
  ./config.sh remove --token "$TOKEN"
}
trap cleanup EXIT

# Start the runner
./run.sh
