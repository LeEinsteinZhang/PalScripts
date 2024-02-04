#!/bin/bash

# 定义备份文件夹和当前日期时间
BACKUP_DIR="$HOME/Steam/steamapps/common/PalServer/Pal/Backup"
CURRENT_DATETIME=$(date +%Y%m%d%H%M)

# 创建备份
cd "$HOME/Steam/steamapps/common/PalServer/Pal" && zip -r "${BACKUP_DIR}/backup_${CURRENT_DATETIME}.zip" ./Saved/

# 删除超过14天的备份文件
find "$BACKUP_DIR" -type f -name 'backup_*.zip' -mtime +7 -exec rm {} \;
