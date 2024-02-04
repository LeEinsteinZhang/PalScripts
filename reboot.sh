#!/bin/bash

# 获取当前脚本的完整路径
script_path=$(realpath "$0")
script_dir=$(dirname "$script_path")

log_path="$script_dir/../Restart.log"
log_path=$(realpath "$log_path")

boot_path="$script_dir/../PalServer.sh"
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

start_msg="[SCHEDULED] RESTART SERVER "
end_msg=""

# 记录开始重启
echo "" >> "$log_path"
echo "$(create_separator "$start_msg")" >> "$log_path"
echo "-- $date" >> "$log_path"

# 检查名为PalWorld的screen会话是否存在
if screen -list | grep -q "PalWorld"; then
    echo ">> STOPPING SERVER" >> "$log_path"
    # 发送停止服务器的命令。这里替换成你的服务器停止命令。
    screen -S PalWorld -X quit
    # 等待服务器完全停止，可能需要调整sleep时间
    sleep 10
else
    echo ">> [ERROR] [$date] PalWorld screen not found" >> "$log_path"
fi

# 更新服务器版本
echo ">> UPDATING SERVER" >> "$log_path"
steamcmd +login anonymous +app_update 2394010 validate +quit

# 重启服务器
echo ">> INITIAL SCREEN" >> "$log_path"
screen -dmS PalWorld
echo ">> STARTING SERVER" >> "$log_path"
screen -S PalWorld -X stuff $"$boot_path\n"

# 记录重启成功
echo ">> RESTART SERVER SUCCESSFUL" >> "$log_path"
echo "$(create_separator "$end_msg")" >> "$log_path"
