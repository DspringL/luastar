#!/bin/sh

#####################################################################
# usage:
# sh check.sh
# sh check.sh <env>

# examples:
# sh check.sh prod -- use conf/nginx-prod.conf to start OpenResty
# sh check.sh -- use conf/nginx-dev.conf to start OpenResty
#####################################################################

if [ -n "$1" ];then
	PROFILE="$1"
else
   PROFILE=local
fi
[ ! -d "logs" ] && mkdir -p logs
[ ! -d "tmp" ] && mkdir -p tmp
nginx -t -p `pwd`/ -c conf/nginx-${PROFILE}.conf
