#!/bin/sh

#####################################################################
# usage:
# sh start.sh
# sh start.sh <env>

# examples:
# sh start.sh prod -- use conf/nginx-prod.conf to start OpenResty
# sh start.sh -- use conf/nginx-dev.conf to start OpenResty
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
# 进程存在先结束，忽略app用户下的nginx进程
pid=`ps -ef | grep nginx | grep -v app | grep -v grep | awk '{print $2}'`
if [ "${pid}" ];then
  ps -ef | grep nginx | grep -v app | grep -v grep | awk '{print $2}' | xargs -n 1 kill -9
fi
echo "Use profile: nginx-"${PROFILE}".conf start"
nginx -p `pwd`/ -c conf/nginx-${PROFILE}.conf
# 删除临时产生的off文件
rm -rf off
