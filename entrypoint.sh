#!/bin/bash
set -e

# Initialize firewall if enabled
if [ "${ENABLE_FIREWALL}" = "true" ]; then
    echo "Initializing firewall..."
    sudo /usr/local/bin/init-firewall.sh
    echo "Firewall initialized."
fi

# Verify API key is set
if [ -z "${ANTHROPIC_API_KEY}" ]; then
    echo "Error: ANTHROPIC_API_KEY is not set."
    echo "Copy .env.example to .env and set your API key."
    exit 1
fi

# Launch Claude Code with auto-accept permissions
exec claude --dangerously-skip-permissions "$@"
