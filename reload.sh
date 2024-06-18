#!/bin/sh

#####################################################################
# usage:
# sh reload.sh
# sh reload.sh <env>

# examples:
# sh reload.sh prod -- use conf/nginx-prod.conf to reload OpenResty
# sh reload.sh -- use conf/nginx-dev.conf to reload OpenResty
#####################################################################

if [ -n "$1" ];then
	PROFILE="$1"
else
   PROFILE=local
fi
# 写出环境变量到本地文件
echo "export PROFILE=$PROFILE" > .bashrc
[ ! -d "logs" ] && mkdir -p logs
[ ! -d "tmp" ] && mkdir -p tmp
# 获取进程pid，忽略app用户下的nginx进程，多worker返回是列表
pid=`ps -ef | grep nginx | grep -v app | grep -v grep | awk '{print $2}'`
if [ ! "${pid}" ];then
  # 进程不存在先启动
  echo "Use profile: nginx-"${PROFILE}".conf start"
  nginx -p `pwd`/ -c conf/nginx-${PROFILE}.conf
fi
echo "Use profile: nginx-"${PROFILE}".conf reload"
nginx -s reload -p `pwd`/ -c conf/nginx-${PROFILE}.conf