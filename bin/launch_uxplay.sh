sudo firewall-cmd --add-port=6000/udp --add-port=6001/udp --add-port=7011/udp --add-port=7000/tcp --add-port=7100/tcp

uxplay -p udp 6000,6001,7011 -p tcp 7000,7100 -fps 60

