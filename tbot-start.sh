#!/usr/bin/env bash

BASEDIR="$(cd $(dirname ${BASH_SOURCE[0]}) >/dev/null 2>&1 && pwd)"
echo "${BASEDIR}"
echo "$1"

TELEGRAM_TOKEN="$1"
TELEGRAM_ID=($2)
SHELL_BOT_API_URL="https://github.com/shellscriptx/shellbot.git"

helper.get_api() {
  echo "[INFO] ShellBot API - Getting the newest version"
  git clone ${SHELL_BOT_API_URL} ${BASEDIR} > /dev/null

  echo "[INFO] Providing the API for the bot's project folder"
}

bot.metrics() {
        local metric=$1
        arr=(${metric})
        arr[0]="/metric"
        metric=(${arr[@]:1})

        message=$(curl 127.0.0.1:12798/metrics | grep -i ${metric} | awk '{ print $2}')
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
}

helper.get_api

source ${BASEDIR}/ShellBot.sh
ShellBot.init --token "${TELEGRAM_TOKEN}" --monitor --flush

curl -s -X POST https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage -d chat_id=${TELEGRAM_ID} -d text="Bot is up and running..."

while :
do
        ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30

        for id in $(ShellBot.ListUpdates)
        do
        (
            if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/txsProcessedNum" )" ]]; then
                message="Tx Processed: "
                message+=$(curl 127.0.0.1:12798/metrics | grep -i cardano_node_metrics_txsProcessedNum | awk '{ print $2}')
                ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
            fi
            if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/metric" )" ]]; then
                        bot.metrics "${message_text[$id]}"
            fi
        ) &
        done
done

