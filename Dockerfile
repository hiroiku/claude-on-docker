FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ripgrep \
    jq \
    vim \
    less \
    procps \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash claude
RUN mkdir -p /workspace /home/claude/.claude \
    && chown -R claude:claude /workspace /home/claude/.claude

USER claude
RUN curl -fsSL https://claude.ai/install.sh | bash
ENV PATH="/home/claude/.local/bin:${PATH}"
ENV DISABLE_AUTOUPDATER=1

WORKDIR /workspace
ENTRYPOINT ["claude", "--dangerously-skip-permissions"]
