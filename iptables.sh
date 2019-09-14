���ܣ��������Ƿ����������ɾ���˿ڣ���Ȩָ����������ָ���˿�
--------------------------------------------------------------------------------
#!/bin/bash

function add() {
echo " "
echo "firewall����������Ϣ"
firewall-cmd --list-all
echo "                 "
echo \n"usage:
     1����Ӷ˿�{add 80}
     2��ɾ���˿�{deladd 80}
     3�����ָ�����������Σ�����ָ���˿�{addhost x.x.x.x 80}
     4��ɾ��ָ�����������Σ�����ָ���˿�{delhost x.x.x.x 80}
------------------------------------------------------------------------------------
"
read -p '������Ҫ��ӵĶ˿�:'  cless   port  pp
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
  echo "  " && echo "������������������add  port"  	
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
[ $(id -u) -gt 0 ] && echo "����root�û�ִ�д˽ű���" && echo " " && exit 1
fir=`firewall-cmd --state &> /dev/null`
if [ $? -gt 0 ]; then
    read -p "�Ƿ���������ǽ[y/n]:" inpt
    if [ "$inpt"x = "y"x ]; then
        systemctl start firewalld &> /dev/null
        if [ $? -gt 0 ];then
            echo '����ʧ������firewalld����'
            exit 1
         else
            echo ' '
   	    echo '��ǰϵͳ���г���Ķ˿�'
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