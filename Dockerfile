FROM ubuntu:23.04
MAINTAINER Rommel Mendiola <rommel.aquino.mendiola@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y ppp pptpd iptables redir

COPY ./dockerfiles/etc/ppp/pptpd-options /etc/ppp/pptpd-options
COPY ./dockerfiles/etc/pptpd.conf /etc/pptpd.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod 0700 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["pptpd", "--fg"]