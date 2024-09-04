#! /bin/bash

echo "$(date +%Y-%m-%d_%H-%M-%S) start cfg webcam-id" > /root/debug_webcam-id.log
while [ ! -d /dev/v4l/by-id/ ]; do
	echo "$(date +%Y-%m-%d_%H-%M-%S) no id" > /root/debug_webcam-id.log
	sleep 1
done

if [ -d "/dev/v4l/by-id/" ];then
	while [ "$(ls -A /dev/v4l/by-id/)" == "" ]
	do
		echo "$(date +%Y-%m-%d_%H-%M-%S) empty id in /dev/v4l/by-id/" > /root/debug_webcam-id.log
		sleep 1
	done
	path=$(ls /dev/v4l/by-id/* |grep index0)
	echo "$(date +%Y-%m-%d_%H-%M-%S) get id info :$path" >> /root/debug_webcam-id.log
	if [ -f "/home/mks/printer_data/config/crowsnest.conf" ];then
		content=$(cat /home/mks/printer_data/config/crowsnest.conf)
		webcam_content=$(echo "$content" | grep "device:" | awk -F': ' '{print $2}' | cut -d'#' -f1 | tr -d ' ')
		if [[ -z "$webcam_content" ]]; then
			echo "empty cfg device:" >> /root/debug_webcam-id.log
			sed -i "s|device:.*|device:"${path}"|g" /home/mks/printer_data/config/crowsnest.conf
			echo "set id finish" >> /root/debug_webcam-id.log
		else
			echo "crowsnest.cfg device: $webcam_content" >> /root/debug_webcam-id.log
			if [ "$path" == "$webcam_content" ]; then
				echo "nothing need to do with crowsnest.cfg" >> /root/debug_webcam-id.log
			else
				echo "need to update crowsnest.cfg" >> /root/debug_webcam-id.log
				sed -i "s|device:.*|device:"${path}"|g" /home/mks/printer_data/config/crowsnest.conf
				echo "set id finish" >> /root/debug_webcam-id.log
			fi
		fi
	else
		touch /home/mks/printer_data/config/crowsnest.conf
		echo '[crowsnest]' > /home/mks/printer_data/config/crowsnest.conf
		echo 'log_path: ~/printer_data/logs/crowsnest.log' >> /home/mks/printer_data/config/crowsnest.conf
		echo 'log_level: verbose' >> /home/mks/printer_data/config/crowsnest.conf
        echo 'delete_log: false' >> /home/mks/printer_data/config/crowsnest.conf
        echo '[cam 1]' >> /home/mks/printer_data/config/crowsnest.conf
        echo 'mode: mjpg' >> /home/mks/printer_data/config/crowsnest.conf
        echo 'port: 8080' >> /home/mks/printer_data/config/crowsnest.conf
		sed -i "s|device:.*|device:"${path}"|g" /home/mks/printer_data/config/crowsnest.conf
        echo 'resolution: 640x480' >> /home/mks/printer_data/config/crowsnest.conf
        echo 'max_fps: 15' >> /home/mks/printer_data/config/crowsnest.conf
		echo "set id finish" >> /root/debug_webcam-id.log
	fi
	systemctl restart crowsnest.service
fi

