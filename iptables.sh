功能：检查服务是否启动，添加删除端口，授权指定主机访问指定端口
--------------------------------------------------------------------------------
#!/bin/bash

function add() {
echo " "
echo "firewall所有配置信息"
firewall-cmd --list-all
echo "                 "
echo \n"usage:
     1、添加端口{add 80}
     2、删除端口{deladd 80}
     3、添加指定主机或网段，访问指定端口{addhost x.x.x.x 80}
     4、删除指定主机或网段，访问指定端口{delhost x.x.x.x 80}
------------------------------------------------------------------------------------
"
read -p '输入需要添加的端口:'  cless   port  pp
ok=0
case $cless in
add)
   status=$(firewall-cmd --zone=public --add-port=$port/tcp --permanent)
   echo "add port status:${status}"
   ok=1
;;
deladd)
   status=$(firewall-cmd --zone=public --remove-port=$port/tcp --permanent)
   echo "remove port status:${status}"
   ok=1
;;
addhost)
  status=$(firewall-cmd --permanent --zone=public --add-rich-rule="rule family="ipv4" source address="$port" port protocol="tcp" port="$pp" accept")
  echo "host port status:${status}"
  ok=1
;;
delhost)
  status=$(firewall-cmd --permanent --zone=public --remove-rich-rule="rule family="ipv4" source address="$port" port protocol="tcp" port="$pp" accept")
  echo "host port status:${status}"
  ok=1
;;
*)
  echo "  " && echo "必须输入两个参数，add  port"  	
  echo "  "
;;
esac

if [ ${ok} == 1 ]
then
    status=`firewall-cmd --reload`
    echo "reload firewall status:${status}"
    ports=`firewall-cmd --list-all`
    echo "ports list:${ports}"
fi

}

echo   " "
[ $(id -u) -gt 0 ] && echo "请用root用户执行此脚本！" && echo " " && exit 1
fir=`firewall-cmd --state &> /dev/null`
if [ $? -gt 0 ]; then
    read -p "是否启动防火墙[y/n]:" inpt
    if [ "$inpt"x = "y"x ]; then
        systemctl start firewalld &> /dev/null
        if [ $? -gt 0 ];then
            echo '启动失败请检查firewalld服务'
            exit 1
         else
            echo ' '
   	    echo '当前系统运行程序的端口'
   	    ss -tnlp |awk '{print $4}' |awk -F ':' '{print $2}' |grep -v '^$'
            echo " " && echo " "
            add
        fi
    else
       exit 1
    fi
else
  add
fi