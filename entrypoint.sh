#!/bin/bash

set -e
#iptables-restore < /etc/iptables/rules.v4
# enable IP forwarding
sysctl -w net.ipv4.ip_forward=1

# configure firewall

iptables -t nat -A POSTROUTING -s 10.1.0.0/24 ! -d 10.1.0.0/24 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.1.1.0/24 ! -d 10.1.1.0/24 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.1.2.0/24 ! -d 10.1.2.0/24 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.1.3.0/24 ! -d 10.1.3.0/24 -j MASQUERADE

iptables -A FORWARD -s 10.1.0.0/24 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j TCPMSS --set-mss 1356
iptables -A FORWARD -s 10.1.1.0/24 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j TCPMSS --set-mss 1356
iptables -A FORWARD -s 10.1.2.0/24 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j TCPMSS --set-mss 1356
iptables -A FORWARD -s 10.1.3.0/24 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j TCPMSS --set-mss 1356

# iptables -t filter -A INPUT -i ppp+ -j ACCEPT
# iptables -t filter -A FORWARD -i ppp+ -j ACCEPT
# iptables -t filter -A FORWARD -o ppp+ -j ACCEPT
# iptables -t filter -A OUTPUT -o ppp+ -j ACCEPT

# iptables -t nat -A POSTROUTING -o ppp+ -j MASQUERADE
# iptables -t nat -A POSTROUTING -s 0.0.0.0/0 -o eth0 -j MASQUERADE

# iptables -A FORWARD -i ppp+ -o eth0 -j ACCEPT
# iptables -A FORWARD -i eth0 -o ppp+ -j ACCEPT
# iptables -A INPUT -i eth0 -p tcp --dport 1723 -j ACCEPT
# iptables -A INPUT -i eth0 -p gre -j ACCEPT

iptables -A INPUT -i ppp+ -j ACCEPT
iptables -A OUTPUT -o ppp+ -j ACCEPT
iptables -A FORWARD -i ppp+ -j ACCEPT
iptables -A FORWARD -o ppp+ -j ACCEPT

iptables -A INPUT -p tcp --dport 1723 -j ACCEPT
iptables -A INPUT -p gre -j ACCEPT

OCT_2="${MAIN_OCTET:-10.1}"

for i in {2..254}; do

    redir -s :$((i + 10000)) $OCT_2.0.$i:8728
    redir -s :$((i + 20000)) $OCT_2.0.$i:8291

    redir -s :$((i + 10000)) $OCT_2.1.$i:8728
    redir -s :$((i + 20000)) $OCT_2.1.$i:8291

    redir -s :$((i + 10000)) $OCT_2.2.$i:8728
    redir -s :$((i + 20000)) $OCT_2.2.$i:8291

    redir -s :$((i + 10000)) $OCT_2.3.$i:8728
    redir -s :$((i + 20000)) $OCT_2.3.$i:8291
done

exec "$@"
