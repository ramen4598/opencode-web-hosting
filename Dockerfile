FROM node:bookworm-slim

# You can change UID, GID, NODE_PASSWORD at .env or docker-compose.yml
ARG UID=1000
ARG GID=1000
ARG NODE_PASSWORD=yourpassword

ENV DEBIAN_FRONTEND=noninteractive
ENV NODE_ENV=production

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    bash \
    unzip \
    tini \
    vim \
    sudo \
    passwd \
    && rm -rf /var/lib/apt/lists/*

RUN groupmod -g "${GID}" node \
    && usermod -u "${UID}" -g "${GID}" node

# node password setting + sudo setting
RUN echo "node:${NODE_PASSWORD}" | chpasswd \
    && usermod -aG sudo node \
    && echo "node ALL=(ALL) PASSWD:ALL" > /etc/sudoers.d/node \
    && chmod 0440 /etc/sudoers.d/node

RUN mkdir -p /home/opencode /workspace \
    && chown -R node:node /home/opencode /workspace

USER node

RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/home/node/.bun/bin:${PATH}"

RUN bun add -g opencode-ai@latest

WORKDIR /workspace

EXPOSE 4096

COPY --chmod=755 docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/docker-entrypoint.sh"]
CMD ["opencode", "web", "--hostname", "0.0.0.0", "--port", "4096"]