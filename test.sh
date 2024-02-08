#!/bin/bash

# 获取当前脚本的完整路径
script_path=$(realpath "$0")
script_dir=$(dirname "$script_path")

# 计划任务（Cron Jobs）定义
palword_jobs="# PalWorld Jobs"
backup_job="*/15 * * * * $script_dir/backup.sh"
backup_daily_job="0 6 * * * $script_dir/backup_daily.sh"
backup_monthly_job="0 0 1 * * $script_dir/backup_monthly.sh"
reboot_job="1 6 * * * $script_dir/reboot.sh"
watchdog_job="*/5 * * * * $script_dir/watchdog.sh"

# 检查并添加每个cron作业
add_cron_job_if_not_exists() {
    local job="$1"
    (crontab -l 2>/dev/null | grep -Fq -- "$job") || (crontab -l 2>/dev/null; echo "$job") | crontab -
}

# 添加每个计划任务
add_cron_job_if_not_exists "$palword_jobs"
add_cron_job_if_not_exists "$backup_job"
add_cron_job_if_not_exists "$backup_daily_job"
add_cron_job_if_not_exists "$backup_monthly_job"
add_cron_job_if_not_exists "$reboot_job"
add_cron_job_if_not_exists "$watchdog_job"
