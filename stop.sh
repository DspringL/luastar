#!/bin/sh

#####################################################################
# usage:
# sh stop.sh
# sh stop.sh <env>

# examples:
# sh stop.sh prod -- use conf/nginx-prod.conf to stop OpenResty
# sh stop.sh -- use conf/nginx-dev.conf to stop OpenResty
#####################################################################

if [ -n "$1" ];then
	PROFILE="$1"
else
   PROFILE=local
fi

# 删除环境变量本地文件
[ -f ".bashrc" ] && rm -rf .bashrc
# 获取进程pid，忽略app用户下的nginx进程，多worker返回是列表
pid=`ps -ef | grep nginx | grep -v app | grep -v grep | awk '{print $2}'`
if [ "${pid}" ];then
  echo "Use profile: nginx-"${PROFILE}".conf stop"
  curl -X GET 'http://localhost:900/shutdown/flush'
  nginx -s stop -p `pwd`/ -c conf/nginx-${PROFILE}.conf
else
  echo "nginx not running nothing todo"
fi

