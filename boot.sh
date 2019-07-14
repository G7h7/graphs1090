#!/bin/bash

mkdir -p /run/graphs1090

source /etc/default/graphs1090

if [ -f /var/lib/collectd/rrd/localhost/dump1090-localhost/dump1090_messages-messages_978.rrd ]
then
	sed -i -e 's/ style="display:none"> <!-- dump978 -->/> <!-- dump978 -->/' /usr/share/graphs1090/html/index.html
	sed -i -e "/sed -i -e 's\/ style=\"display/d" /usr/share/graphs1090/graphs1090.sh
else
	sed -i -e 's/panel-default"> <!-- dump978 -->/panel-default" style="display:none"> <!-- dump978 -->/' /usr/share/graphs1090/html/index.html
fi

if [[ $all_large == "yes" ]]; then
	sed -i -e 's?flex: 50%; // all_large?flex: 100%; // all_large?' /usr/share/graphs1090/html/portal.css
else
	sed -i -e 's?flex: 100%; // all_large?flex: 50%; // all_large?' /usr/share/graphs1090/html/portal.css
fi

if [[ $1 == "nographs" ]]; then
	exit 0
fi

if [[ $1 == "slow" ]]; then
	sleep 15
fi

if rrdtool info /var/lib/collectd/rrd/localhost/dump1090-localhost/dump1090_range-median.rrd  | grep -qs 'MIN'; then
	cp -T -r -n /var/lib/collectd/rrd/localhost /var/lib/collectd/rrd/rme_rra_backup
	/usr/share/graphs1090/rem_rra.sh /var/lib/collectd/rrd/localhost/
fi

for i in 1h 6h 24h 48h 7d 14d 30d 90d 180d 365d 730d 1095d
do
	/usr/share/graphs1090/graphs1090.sh $i $1
done
