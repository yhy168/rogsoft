#! /bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)

# 判断路由架构和平台
case $(uname -m) in
	aarch64)
		if [ "`uname -o|grep Merlin`" ] && [ -d "/koolshare" ];then
			echo_date 固件平台【koolshare merlin hnd/axhnd aarch64】符合安装要求，开始安装插件！
		else
			echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的固件平台不能安装！！！
			echo_date 退出安装！
			rm -rf /tmp/shellinabox* >/dev/null 2>&1
			exit 1
		fi
		;;
	*)
		echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的平台：$(uname -m)不能安装！！！
		echo_date 退出安装！
		rm -rf /tmp/shellinabox* >/dev/null 2>&1
		exit 1
	;;
esac

# stop shellinaboxd
killall shellinaboxd >/dev/null 2>&1

# 安装插件
rm -rf /koolshare/init.d/*shellinabox*
cp -rf /tmp/shellinabox/shellinabox /koolshare/
cp -rf /tmp/shellinabox/res/* /koolshare/res/
cp -rf /tmp/shellinabox/scripts/* /koolshare/scripts/
cp -rf /tmp/shellinabox/webs/* /koolshare/webs/
cp -rf /tmp/shellinabox/uninstall.sh /koolshare/scripts/uninstall_shellinabox
chmod 755 /koolshare/shellinabox/*	
chmod 755 /koolshare/scripts/*
# open in new window
dbus set softcenter_module_shellinabox_install="1"
dbus set softcenter_module_shellinabox_target="target=_blank"
dbus remove shellinabox_enable

# enable shellinaboxd
PID=`pidof shellinaboxd`
[ -z "$PID" ] && /koolshare/shellinabox/shellinaboxd --css=/koolshare/shellinabox/white-on-black.css -b

# 离线安装用
dbus set shellinabox_version="$(cat $DIR/version)"
dbus set softcenter_module_shellinabox_version="$(cat $DIR/version)"
dbus set softcenter_module_shellinabox_description="超强的SSH网页客户端~"
dbus set softcenter_module_shellinabox_install="1"
dbus set softcenter_module_shellinabox_name="shellinabox"
dbus set softcenter_module_shellinabox_title="shellinabox工具箱"

# 完成
echo_date "shellinabox插件安装完毕！"
rm -rf /tmp/shellinabox* >/dev/null 2>&1
exit 0
