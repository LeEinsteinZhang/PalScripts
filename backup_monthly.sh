#!/bin/bash
# 每月记录一份，记录12个月

# 备份保存时长
n=11

# 获取当前脚本的完整路径
script_path=$(realpath "$0")
script_dir=$(dirname "$script_path")

# 定位到备份目录的路径
backup_dir="$script_dir/../Pal/Backup"
backup_dir=$(realpath "$backup_dir")
mkdir -p "${backup_dir}"

saved_dir="$script_dir/../Pal"
saved_dir=$(realpath "$saved_dir")

# 获取时间（年月格式）
current_date=$(date +%Y%m)

# 为当前日期创建备份目录
mkdir -p "${backup_dir}/Monthly"

# 在Saved目录中创建备份存档
cd "$saved_dir" && zip -r "${backup_dir}/Monthly/backup_${current_date}.zip" ./Saved/

# 计算n个月前的年月
n_months_ago=$(date -d "-${n} months" +%Y%m)

# 删除n个月前的所有备份文件
find "${backup_dir}/Monthly" -mindepth 1 -maxdepth 1 -type f -name "backup_??????.zip" | while read file; do
    file_name=$(basename "$file" ".zip")
    backup_date=${file_name##*_}
    if [[ "$backup_date" < "$n_months_ago" ]]; then
        rm -rf "$file"
    fi
done