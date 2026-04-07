#!/usr/bin/env bash
set -Eeuo pipefail

ENV_FILE=".env"

# 필요한 디렉토리 생성
mkdir -p workspace opencode-home

# 권한 (호스트 UID/GID 기준으로 맞춤)
chown "$(id -u)":"$(id -g)" workspace opencode-home

# .env 준비
touch "${ENV_FILE}"

# UID/GID 중복 없이 갱신
{
  grep -Ev '^(UID|GID)=' "${ENV_FILE}" 2>/dev/null || true
  echo "UID=$(id -u)"
  echo "GID=$(id -g)"
} > "${ENV_FILE}.tmp"

mv "${ENV_FILE}.tmp" "${ENV_FILE}"
chmod 600 "${ENV_FILE}"

# 실행
docker compose up -d