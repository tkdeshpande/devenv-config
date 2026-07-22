FROM ubuntu:latest

WORKDIR /app

COPY . .

RUN apt-get update && \
  apt-get install -y git curl neovim tmux build-essential nodejs npm ca-certificates && \
  rm -rf /var/lib/apt/lists/*

# Install Go (latest stable, arch-detected)
RUN ARCH=$(dpkg --print-architecture) && \
  GO_VERSION=$(curl -fsSL "https://go.dev/VERSION?m=text" | head -1) && \
  curl -fsSL "https://go.dev/dl/${GO_VERSION}.linux-${ARCH}.tar.gz" | tar -C /usr/local -xz

# Install Rust
RUN curl -fsSL https://sh.rustup.rs | sh -s -- -y

# Install Claude Code (native installer)
RUN curl -fsSL https://claude.ai/install.sh | bash

ENV PATH="/root/.local/bin:/usr/local/go/bin:/root/.cargo/bin:${PATH}"

CMD ["sh", "-c", "echo 'Container started...' && tail -f /dev/null"]
