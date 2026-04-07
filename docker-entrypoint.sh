#!/usr/bin/env bash
set -Eeuo pipefail

NEW_HOME="${HOME}"
OLD_HOME="/home/node"

mkdir -p "${NEW_HOME}"
chmod 700 "${NEW_HOME}" 2>/dev/null || true

if [ "${NEW_HOME}" != "${OLD_HOME}" ]; then
  [ ! -e "${NEW_HOME}/.bashrc" ] && [ -f "${OLD_HOME}/.bashrc" ] && cp "${OLD_HOME}/.bashrc" "${NEW_HOME}/.bashrc"
  [ ! -e "${NEW_HOME}/.profile" ] && [ -f "${OLD_HOME}/.profile" ] && cp "${OLD_HOME}/.profile" "${NEW_HOME}/.profile"
fi

cd /workspace

exec "$@"