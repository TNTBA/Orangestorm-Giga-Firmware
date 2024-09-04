#!/bin/sh
### BEGIN INIT INFO
# Provides:          taskset.sh
# Required-Start:    
# Required-Stop:     
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: taskset other 0-3
### END INIT INFO

case "$1" in
    stop|status)

    ;;
    start|force-reload|restart|reload)
    export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:
    for pid in `pstree -ap |grep klippy |grep -v grep |sed -e 's/[^0-9][^0-9]*/ /g'`
    do
        if [ -d /proc/$pid ]; then
            #echo "$pid exist"
            taskset -cap 0-1 $pid
        #else
            #echo "no $pid"
        fi
    done
    for pid in `pstree -ap |grep klipper_mcu |grep -v grep |sed -e 's/[^0-9][^0-9]*/ /g'`
    do
        if [ -d /proc/$pid ]; then
            #echo "$pid exist"
            taskset -cap 1 $pid
        #else
            #echo "no $pid"
        fi
    done
    for pid in `pstree -ap |grep moonraker |grep -v grep |sed -e 's/[^0-9][^0-9]*/ /g'`
    do
        if [ -d /proc/$pid ]; then
            #echo "$pid exist"
            taskset -cap 2 $pid
        #else
            #echo "no $pid"
        fi
    done
    for pid in `pstree -ap |grep znp_tjc |grep -v grep |sed -e 's/[^0-9][^0-9]*/ /g'`
    do
        if [ -d /proc/$pid ]; then
            #echo "$pid exist"
            taskset -cap 3 $pid
        #else
            #echo "no $pid"
        fi
    done
    for pid in `pstree -ap |grep -v klipp |grep -v python |sed -e 's/[^0-9][^0-9]*/ /g'`
    do
        if [ -d /proc/$pid ]; then
            #echo "$pid exist"
            taskset -cap 2-3 $pid
        #else
            #echo "no $pid"
        fi
        #如果要屏蔽pid为1的就用下面的代码
        # if [ "$pid" -ne 1 ]; then  # 排除 PID 为 1的进程
        #     if [ -d /proc/$pid ]; then
        #         taskset -cap 2-3 $pid
        #     fi
        # fi
    done
    ;;
    *)
        echo 'Usage: /etc/init.d/taskset {start|reload|restart|force-reload|stop|status}'
        exit 3
        ;;
esac

exit 0