#!/bin/bash

set -e
#iptables-restore < /etc/iptables/rules.v4
# enable IP forwarding
sysctl -w net.ipv4.ip_forward=0

# configure firewall
iptables -t filter -F

# Set the default policies
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Allow incoming traffic on interface ppp+
iptables -A INPUT -i ppp+ -j ACCEPT

# Allow forwarding traffic on interface ppp+
iptables -A FORWARD -i ppp+ -j ACCEPT

# Allow outgoing traffic on interface ppp+
iptables -A FORWARD -o ppp+ -j ACCEPT
iptables -A OUTPUT -o ppp+ -j ACCEPT

iptables -A INPUT -i eth0 -p tcp --dport 1723 -j ACCEPT
iptables -A INPUT -i eth0 -p gre -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# OCT_2="${MAIN_OCTET:-10.1}"

# for i in {2..254}; do

#     redir -s :$((i + 10000)) $OCT_2.0.$i:8728
#     redir -s :$((i + 20000)) $OCT_2.0.$i:8291

#     redir -s :$((i + 10000)) $OCT_2.1.$i:8728
#     redir -s :$((i + 20000)) $OCT_2.1.$i:8291

#     redir -s :$((i + 10000)) $OCT_2.2.$i:8728
#     redir -s :$((i + 20000)) $OCT_2.2.$i:8291

#     redir -s :$((i + 10000)) $OCT_2.3.$i:8728
#     redir -s :$((i + 20000)) $OCT_2.3.$i:8291
# done

echo "export WASP_ENDPOINT=${WASP_ENDPOINT}" >> "/opt/envs.sh"
echo "export OCT_2=${OCT_2}" >> "/opt/envs.sh"
#shell2http --port 8085 -form /init-redir 'curl -sL "$WASP_ENDPOINT/api/pptp/redir?real=$v_realm" | bash' &
#shell2http --port 8086 -form /make-redir 'redir -s ":$v_src_ip" $v_dest_ip:$v_dest_port' &

pptpd
echo "Start: API = ${WASP_ENDPOINT}" >> "/var/log/syslog"
#curl -sL "https://wasp.rmendiola.site/api/pptp/up?interface_name=ppp0&device_name=/dev/pts/0&device_speed=115200&local_ip=10.1.0.1&remote_ip=10.1.0.2&param=119.94.108.25"
tail -f "/var/log/syslog"
exec "$@"
