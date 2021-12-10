#!/usr/bin/env bash

export BASEDIR="$(cd $(dirname ${BASH_SOURCE[0]}) >/dev/null 2>&1 && pwd)"

TELEGRAM_TOKEN="$1"
TELEGRAM_ID=($2)
SHELL_BOT_API_URL="https://github.com/shellscriptx/shellbot.git"
SHELL_BOT_PATH=${BASEDIR}/shellbot

helper.get_api() {
  echo "[INFO] Providing the API for the bot's project folder"
  ls ${SHELL_BOT_PATH} > /dev/null 2>&1 || git clone ${SHELL_BOT_API_URL} ${SHELL_BOT_PATH} > /dev/null 2>&1
}