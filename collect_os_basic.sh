#!/bin/bash
#######
##0.Hostname,Version
##1.Cpu(p_num,c_num,model,cache)
##2.Mem,Swap
##3.Disk
##4.Files
##5.Network
#######
host="`hostname`,`awk '{print$3}' /proc/version`"
cpu=`awk 'BEGIN{p_max=0}/processor/{a=a+1};/cache size/{b=$4""$5}/cpu MHz/{b=$NF};/physical id/{if($NF>p_max)p_max=$NF fi};NR==5{for(i=4;i<=NF;i++)c=c""$i};END{print p_max+1","a","b","c}' /proc/cpuinfo`
mem=`awk '/MemTotal/{a=$2""$3};/SwapTotal/{b=$2""$3};END{print a","b}' /proc/meminfo`
disk=`fdisk -l|awk '/Disk \/dev/{a=a""$2""$3""$4}END{print a}'`
file=`df -m|awk 'NR>1{a=$NF":"$2"MB,"a}END{print a}'`
net=`ip addr list|awk '$1=="inet"&&/scope/{a=$NF":"$2","a}END{print a}'`
##
echo "$host|$cpu|$mem|$disk|$file|$net"
##
#######
##Use
#######
dstat -c -l --top-cpu --top-cputime -y --proc-count -m --top-mem -d --top-io --tcp --udp --net-packets --output UseTmp 1 3
