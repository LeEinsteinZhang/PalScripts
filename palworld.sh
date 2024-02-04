#!/bin/bash

DATE=$(date '+%Y-%m-%d %H:%M:%S')

# 检查名为PalWorld的screen会话是否存在
if ! screen -list | grep -q "PalWorld"; then
    # 如果不存在，则创建一个新的名为PalWorld的screen会话
    screen -dmS PalWorld
    echo "INIT SCREEN $DATE" >> '/home/lez/Steam/steamapps/common/PalServer/Restart.log'
fi

# 检查./PalServer.sh和PalServer-Linux-Test是否在运行
if ! ps aux | grep '[/]home/lez/Steam/steamapps/common/PalServer/PalServer.sh' > /dev/null && \
   ! ps aux | grep '[P]alServer-Linux-Test' > /dev/null; then
    #Update The Version of Server
    echo "UPDATING SERVER"
    steamcmd +login anonymous +app_update 2394010 validate +quit
    # 如果没有运行，进入名为PalWorld的screen并执行脚本
    echo "STARTING SERVER"
    screen -S PalWorld -X stuff $'/home/lez/Steam/steamapps/common/PalServer/PalServer.sh\n'
    # 记录重启操作到日志文件
    echo "RESTART $DATE" >> '/home/lez/Steam/steamapps/common/PalServer/Restart.log'
fi
