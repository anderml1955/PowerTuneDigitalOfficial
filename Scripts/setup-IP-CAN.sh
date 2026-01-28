#!/bin/bash
# run from /etc/init.d/powertune if you want it to run at startup
#echo 'Set MAC address'

ip link set eth0 down
ip link set eth0 address 2C:CF:67:06:95:F2
ip link set eth0 up

#echo 'Set can0 to loopback'

ip link set can0 down
ip link set can0 up type can bitrate 1000000 loopback on
ifconfig can0 txqueuelen 1000

#echo 'On PT dash restart daemon on the Network tab'

