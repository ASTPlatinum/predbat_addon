#!/usr/bin/with-contenv bashio
set -euo pipefail

echo "Running Predbat add-on"

# Safety: don't ever print the Supervisor token
if [ -z "${SUPERVISOR_TOKEN:-}" ]; then
  echo "ERROR: SUPERVISOR_TOKEN is not set" >&2
  exit 1
fi

# Prefer the venv python; fall back to system python if needed
PYBIN="/opt/venv/bin/python"
if [ ! -x "$PYBIN" ]; then
  echo "Warning: /opt/venv/bin/python not found, falling back to system python"
  PYBIN="$(command -v python3 || true)"
fi

# Keep your dev toggle behaviour
if [ -f /config/dev ]; then
  echo "Dev mode: not copying hass.py"
else
  # Copy the shipped hass.py into /config so user edits persist
  cp -f /hass.py /config/hass.py
fi

# Start up
exec "$PYBIN" /startup.py "$SUPERVISOR_TOKEN"
