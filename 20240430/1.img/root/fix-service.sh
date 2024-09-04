#! /bin/bash
if [ ! -e /root/fix.log ]; then
    touch /root/fix.log
fi
echo "$(date +%Y-%m-%d_%H-%M-%S)_start fix-service" > /root/fix.log
times=0
while (( times < 181 ))
do
    for usb_dir in /home/mks/gcode_files/sd*; do
		if [ -d "$usb_dir/ELEGOO_UPDATE_DIR" ]; then
			if [ -e "$usb_dir/ELEGOO_UPDATE_DIR/ELEGOO_GIGA_FIX_BAG.deb" ]; then
				echo "$(date +%Y-%m-%d_%H-%M-%S):文件ELEGOO_GIGA_FIX_BAG.deb存在于$usb_dir/ELEGOO_UPDATE_DIR" >> /root/fix.log
				UPDATE_PATH="$usb_dir/ELEGOO_UPDATE_DIR"
				if [ ! -e ${UPDATE_PATH}/fix_tag ];then
					if dpkg -i --force-overwrite ${UPDATE_PATH}/ELEGOO_GIGA_FIX_BAG.deb
					then
						touch ${UPDATE_PATH}/fix_klipper_successed
						touch ${UPDATE_PATH}/fix_tag
						echo "$(date +%Y-%m-%d_%H-%M-%S):fix klipper successed"  >> /root/fix.log
						sync
						reboot
					else
						touch ${UPDATE_PATH}/fix_klipper_failed
						echo "$(date +%Y-%m-%d_%H-%M-%S):fix klipper failed"  >> /root/fix.log
					fi
				else
					echo "$(date +%Y-%m-%d_%H-%M-%S):fixed,nothing need to do" >> /root/fix.log
				fi
			else
				echo "$(date +%Y-%m-%d_%H-%M-%S):文件ELEGOO_GIGA_FIX_BAG.deb不存在于$usb_dir/ELEGOO_UPDATE_DIR" >> /root/fix.log
			fi
		else
			echo "$(date +%Y-%m-%d_%H-%M-%S):目录$usb_dir/ELEGOO_UPDATE_DIR不存在" >> /root/fix.log
		fi
	done
	if [ -e /root/waitting_fix_mode ]; then
		times=0
		echo "$(date +%Y-%m-%d_%H-%M-%S) fix-service once again" > /root/fix.log
	fi
	sleep 1
	(( times++ ))
done

while (true)
do
	sleep 10086 #for live
done
