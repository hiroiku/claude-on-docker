FROM node:20-bookworm-slim

# System packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ripgrep \
    jq \
    vim \
    less \
    procps \
    sudo \
    iptables \
    ipset \
    iproute2 \
    dnsutils \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code
RUN npm install -g @anthropic-ai/claude-code

# Create non-root user with sudo access
RUN useradd -m -s /bin/bash claude \
    && echo "claude ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/claude

# Create directories
RUN mkdir -p /workspace /home/claude/.claude \
    && chown -R claude:claude /workspace /home/claude/.claude

# Disable auto-updater inside container
ENV DISABLE_AUTOUPDATER=1

# Copy scripts
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY init-firewall.sh /usr/local/bin/init-firewall.sh
RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/init-firewall.sh

USER claude
WORKDIR /workspace

ENTRYPOINT ["entrypoint.sh"]
