FROM ubuntu:23.04
MAINTAINER Rommel Mendiola <rommel.aquino.mendiola@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y ppp pptpd iptables redir curl

COPY ./dockerfiles/etc/ppp/pptpd-options /etc/ppp/pptpd-options
COPY ./dockerfiles/etc/pptpd.conf /etc/pptpd.conf

COPY ./dockerfiles/etc/ppp/ip-up.d/routes-up /etc/ppp/ip-up.d/routes-up
COPY ./dockerfiles/etc/ppp/ip-down.d/routes-down /etc/ppp/ip-down.d/routes-down
RUN chmod +x ./etc/ppp/ip-up.d/routes-up
RUN chmod +x ./etc/ppp/ip-down.d/routes-down

COPY entrypoint.sh /entrypoint.sh
RUN chmod 0700 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
#CMD ["pptpd", "--fg"]