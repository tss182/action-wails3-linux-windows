FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG GO_VERSION=1.26.0
ARG NODE_MAJOR=20
ARG WAILS_VERSION=v3.0.0

# Install Linux & Windows cross-build system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gcc \
    git \
    gnupg \
    libc6-dev \
    libgtk-4-dev \
    libwebkitgtk-6.0-dev \
    make \
    nsis \
    pkg-config \
    python3 \
    rpm \
    unzip \
    xz-utils \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Install Go
RUN ARCH="$(dpkg --print-architecture)" \
    && curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-${ARCH}.tar.gz" -o /tmp/go.tar.gz \
    && tar -C /usr/local -xzf /tmp/go.tar.gz \
    && rm -f /tmp/go.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"

# Install Node.js
RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Wails v3 CLI into /usr/local/bin so it is available regardless of HOME/GOPATH
RUN GOPATH=/tmp/gopath CGO_ENABLED=0 go install "github.com/wailsapp/wails/v3/cmd/wails3@${WAILS_VERSION}" \
    && mv /tmp/gopath/bin/wails3 /usr/local/bin/wails3 \
    && rm -rf /tmp/gopath /root/.cache/go-build
