#!/usr/bin/env bash
set -euo pipefail

# Pull specific folders and top-level files from remote into local repo.
# Usage:
#   ./download.sh [-n] [-P]
#     -n             Dry run (no changes)
#     -P             Show progress
#
# Environment overrides (optional):
#   REMOTE_BASE      Default: /var/www/free-d-space.dept.trading
#   LOCAL_BASE       Default: repo root (directory of this script)

REMOTE=root@79.137.192.124
REMOTE_BASE=/var/www/free-d-space.dept.trading
LOCAL_BASE=/Users/apple/VSCodeProjects/crypted
DRY_RUN=""
PROGRESS=""

while getopts ":nP" opt; do
  case $opt in
    n)
      DRY_RUN="--dry-run"
      ;;
    P)
      PROGRESS="--progress"
      ;;
    :)
      echo "Option -$OPTARG requires an argument" >&2
      exit 1
      ;;
    *)
      echo "Unknown option: -$OPTARG" >&2
      echo "Usage: $0 [-n] [-P]" >&2
      exit 1
      ;;
  esac
done

REMOTE_HOST="${REMOTE}"
if [[ -z "${REMOTE_HOST}" ]]; then
  echo "Error: REMOTE is not set (e.g. user@host)" >&2
  exit 1
fi

REMOTE_BASE=${REMOTE_BASE:-/var/www/free-d-space.dept.trading}
# Default local base = directory of this script (repo root)
LOCAL_BASE=${LOCAL_BASE:-"$(cd "$(dirname "$0")" && pwd)"}

echo "Remote host:    ${REMOTE_HOST}"
echo "Remote base:    ${REMOTE_BASE}"
echo "Local base:     ${LOCAL_BASE}"
if [[ -n "${DRY_RUN}" ]]; then echo "Mode:          DRY RUN"; fi
if [[ -n "${PROGRESS}" ]]; then echo "Mode:          SHOW PROGRESS"; fi

RSYNC_BASE_FLAGS="-azvh --delete -e ssh ${DRY_RUN} ${PROGRESS}"
# Exclude Python bytecode caches everywhere (compatible with older rsync)
RSYNC_EXCLUDES=(
  --exclude '*/__pycache__/'
  --exclude '*/__pycache__/**'
)

echo "\n==> Syncing folders: backend, frontend, reports, scripts, telegram_bot, tests"
for dir in backend frontend reports scripts telegram_bot tests; do
  echo "  -> ${dir}"
  rsync ${RSYNC_BASE_FLAGS} "${RSYNC_EXCLUDES[@]}" "${REMOTE_HOST}:${REMOTE_BASE}/${dir}/" "${LOCAL_BASE}/${dir}/"
done

echo "\n==> Syncing top-level files from remote root"
# Copy only files at the remote root (exclude directories)
rsync ${RSYNC_BASE_FLAGS} "${RSYNC_EXCLUDES[@]}" --exclude '*/' "${REMOTE_HOST}:${REMOTE_BASE}/" "${LOCAL_BASE}/"

echo "\nDone."


