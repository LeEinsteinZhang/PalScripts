#!/bin/bash

# 备份保存时长
n=7

# 获取当前脚本的完整路径
script_path=$(realpath "$0")
script_dir=$(dirname "$script_path")

# 定位到备份目录的路径，假设备份目录位于脚本目录的上一级目录中的Backup文件夹
backup_dir="$script_dir/../Backup"
backup_dir=$(realpath "$backup_dir")
mkdir -p "${backup_dir}"

saved_dir="$script_dir/.."
saved_dir=$(realpath "$saved_dir")

# 获取时间
current_date=$(date +%Y%m%d)
current_hour=$(date +%H)

# 为当前日期创建备份目录
mkdir -p "${backup_dir}/${current_date}"

# 在Saved目录中创建备份存档
cd "$saved_dir" && zip -r "${backup_dir}/${current_date}/backup_${current_date}_${current_hour}.zip" ./Saved/

# 计算n天前的日期
n_days_ago=$(date -d "-${n} days" +%Y%m%d)

# 删除n天前的所有备份目录及其内容
find "${backup_dir}" -mindepth 1 -maxdepth 1 -type d -name "????????" | while read dir; do
    dir_name=$(basename "$dir")
    if [[ "$dir_name" < "$n_days_ago" ]]; then
        rm -rf "$dir"
    fi
done
