#!/bin/bash

# 获取当前脚本的完整路径
script_path=$(realpath "$0")
script_dir=$(dirname "$script_path")

log_path="$script_dir/../../Restart.log"
log_path=$(realpath "$log_path")

boot_path="$script_dir/../../PalServer.sh"
boot_path=$(realpath "$boot_path")

date=$(date '+%Y-%m-%d %H:%M:%S')

# 动态创建分隔符
create_separator() {
    local msg="$1"
    local total_length=80
    local msg_length=${#msg}
    local remaining_length=$((total_length - msg_length))
    local separator=$(printf '=%.0s' $(seq 1 $remaining_length))
    echo "$msg$separator"
}

start_msg="[ERROR] WATCHDOG "
end_msg=""

screen_err=0
server_err=0

# 检查名为PalWorld的screen会话是否存在
if ! screen -list | grep -q "PalWorld"; then
    # 如果不存在，则创建一个新的名为PalWorld的screen会话
    screen_err=1
    screen -dmS PalWorld
fi

# 检查PalServer.sh和PalServer-Linux-Test是否在运行
if ! pgrep -f "$boot_path" > /dev/null && \
   ! pgrep -f "PalServer-Linux-Test" > /dev/null; then
    server_err=1
    steamcmd +login anonymous +app_update 2394010 validate +quit
    screen -S PalWorld -X stuff $"$boot_path\n"
fi

if [ $screen_err -eq 1 ] || [ $server_err -eq 1 ]; then
    echo "" >> "$log_path"
    echo "$(create_separator "$start_msg")" >> "$log_path"
    echo "-- $date" >> "$log_path"
    if [ $screen_err -eq 1 ]; then
        echo ">> PalWorld screen not found" >> "$log_path"
    fi
    if [ $server_err -eq 1 ]; then
        echo ">> PalWorld server down" >> "$log_path"
    fi
    echo "$(create_separator "$end_msg")" >> "$log_path"
fi
