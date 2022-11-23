#!/bin/bash

ex_lk(){
export SHELL=/data/data/com.termux/files/out/usr/bin/bash
export PREFIX=/data/data/com.termux/files/out/usr
export LD_PRELOAD=/data/data/com.termux/files/out/usr/lib/libtermux-exec.so
export TMPDIR=/data/data/com.termux/files/out/usr/tmp
export PATH=/data/data/com.termux/files/out/usr/bin
export _=/data/data/com.termux/files/usr/bin/env
export LD_LIBRARY_PATH=/data/data/com.termux/files/out/usr/lib
}

cache(){
echo "正在清空安装文件......"
rm -rf $OLDPWD/../out 2>/dev/null
rm -rf $PWD_DOWNLOAD
}

search(){ #搜索常用地址 寻找文件
termux-setup-storage
read -p '请授予权限后回车'
while true;do
if [ "`ls /sdcard`" != "" ]
then
ls /sdcard |grep "linux-aarch64.tgz" && Pwd_DOWNLOAD=/sdcard/linux-aarch64.tgz
ls /sdcard/Quark/Download |grep "linux-aarch64.tgz" && Pwd_DOWNLOAD=/sdcard/Quark/Download/linux-aarch64.tgz
ls /sdcard/Download |grep "linux-aarch64.tgz" && Pwd_DOWNLOAD=/sdcard/Download/linux-aarch64.tgz
if [[ "$Pwd_DOWNLOAD" == "" ]];then
PWD_LOG=/sdcard/Quark/Download/CloudDrive
for i in `ls $PWD_LOG`
do
ls ${PWD_LOG}/${i} |grep "linux-aarch64.tgz" && Pwd_DOWNLOAD=${PWD_LOG}/${i}/linux-aarch64.tgz
done
fi
	if [ "$Pwd_DOWNLOAD" = "" ]
	then
	echo -e "\e[31merr:\e[0m 未找到linux-aarch64.tgz 请手动把linux-aarch64.tgz复制到内部存储根目录后重新执行该脚本"
	exit 1
	fi
break
fi
done
}

main(){
echo "开始执行"
cd $OLDPWD && cd ..
mkdir out
search
tar -zxvf  $Pwd_DOWNLOAD -C out/
rm -rf home

echo -e "开始恢复\e[33mhome\e[0m"
echo -e "\e[31m长时间\e[0m没有反应是\e[31m正常的\e[0m"
cp -r out/home ./
echo "-----------------"
echo "建立临时链接……"
rm -rf usr
ex_lk
cp -r out/usr ./
echo '
if [[ "$LSBL_SWIT" != 1 ]]
then
LSBL_SWIT=1
tmoe proot ubuntu jammy arm64
fi' >> ~/.bashrc
read -p '请问是否需要清空安装文件? [y/n]: ' tmp
if [ "$tmp" = "y" ]
then
cache
elif [ "$tmp" = "Y" ]
then
cache
else
echo "好吧好吧0 0"
echo "文件位置在`pwd`/out & linux-aarch64.tgz 如有需要请自行清空哦"
fi
echo "恢复已完成 请重启termux"
}

if [ "`uname -m`" = "aarch64" ]
then
read -p '此脚本有一定风险,如果termux内部有重要资料请不要使用......回车继续 输入e取消' msg
if [ "$msg" != "e" ]
then
main
else
echo "用户取消......请稍等......"
rm $0 linux-aarch64.tgz
exit 0
fi
else
echo -e "\e[31merr: \e[0m您的系统不支持这个脚本哦......"
fi
