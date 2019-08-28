#!/bin/bash
yum -y install whois   #whois命令查询域名到期时间
for i in `cat /root/httplist.txt`
do
 x=`whois $i | awk '/Creation Date:/{print $3}' | awk -F 'T' '{print $1}'`
 y=`whois $i | awk '/Registry Expiry Date:/{print $4}'   | awk -F 'T' '{print $1}'`
 c=`date +%F`  #当前时间
 z=`echo $(($(date +%s -d "${y}") - $(date +%s -d "${c}")))`
 s=`expr $z / 86400`

 curl -k https://$i > /dev/null
 u=`echo $?`
 if [ $u -ne 0 ];then
  echo "$i 证书掉了或域名不存在" >> /root/httpguoqi4.txt
  else
   echo "$i 证书正常" >>  /root/httpguoqi4.txt
 fi

 echo "$x"  >>  /root/httpguoqi1.txt  #域名的起始时间
 echo "$y"  >>  /root/httpguoqi2.txt  #域名的到期时间
 echo "$s"  >>  /root/httpguoqi3.txt  #还剩多少天到期

#分四个文件方便导出再导进Excle表格
done
