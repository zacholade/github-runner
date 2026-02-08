#!/bin/bash
set -e

if [ -z "$REPO_URL" ]; then
  echo "Error: REPO_URL environment variable is required"
  exit 1
fi

if [ -z "$PAT" ]; then
  echo "Error: PAT environment variable is required"
  exit 1
fi

REPO_PATH=$(echo "$REPO_URL" | sed 's|https://github.com/||')

get_registration_token() {
  curl -s -X POST \
    -H "Authorization: token $PAT" \
    -H "Accept: application/vnd.github+json" \
    "https://api.github.com/repos/${REPO_PATH}/actions/runners/registration-token" | jq -r .token
}

get_remove_token() {
  curl -s -X POST \
    -H "Authorization: token $PAT" \
    -H "Accept: application/vnd.github+json" \
    "https://api.github.com/repos/${REPO_PATH}/actions/runners/remove-token" | jq -r .token
}

# Always generate a fresh token and register
TOKEN=$(get_registration_token)
if [ "$TOKEN" = "null" ] || [ -z "$TOKEN" ]; then
  echo "Error: Failed to generate registration token. Check your PAT has the 'repo' scope."
  exit 1
fi

DISABLE_UPDATE_FLAG=""
if [ "${DISABLE_AUTO_UPDATE:-false}" = "true" ]; then
  DISABLE_UPDATE_FLAG="--disableupdate"
fi

./config.sh --url "$REPO_URL" --token "$TOKEN" --unattended --replace $DISABLE_UPDATE_FLAG --name "${RUNNER_NAME:-self-hosted-docker}" --labels "${RUNNER_LABELS:-self-hosted}"

# Deregister on exit
cleanup() {
  echo "Removing runner..."
  REMOVE_TOKEN=$(get_remove_token)
  ./config.sh remove --token "$REMOVE_TOKEN"
}
trap cleanup EXIT

./run.sh
