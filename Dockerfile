# start from debian 10 slim version
FROM debian:10-slim

# install certbot, supervisor and utilities
RUN apt-get update && apt-get install --no-install-recommends -yqq \
    gnupg \
    apt-transport-https \
    cron \
    wget \
    ca-certificates \
    curl \
    procps \
    && apt-get install --no-install-recommends -yqq certbot \
    && apt-get install --no-install-recommends -yqq supervisor \
    && apt-get clean autoclean && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# install haproxy from official debian repos (https://haproxy.debian.net/)

RUN curl https://haproxy.debian.net/bernat.debian.org.gpg \
       | gpg --dearmor > /usr/share/keyrings/haproxy.debian.net.gpg \
    && echo deb "[signed-by=/usr/share/keyrings/haproxy.debian.net.gpg]" \
       http://haproxy.debian.net buster-backports-2.4 main \
       > /etc/apt/sources.list.d/haproxy.list \
    && apt-get update \
    # && apt-get install -yqq haproxy=2.4.\* \
    && apt-get clean autoclean && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# supervisord configuration
COPY conf/supervisord.conf /etc/supervisord.conf

# haproxy configuration
COPY conf/haproxy.cfg /etc/haproxy/haproxy.cfg
COPY haproxy-acme-validation-plugin/acme-http01-webroot.lua /etc/haproxy

# renewal script
COPY scripts/cert-renewal-haproxy.sh /

# renewal cron job
COPY conf/crontab.txt /var/crontab.txt

# install cron job and remove useless ones
RUN crontab /var/crontab.txt && chmod 600 /etc/crontab \
    && rm -f /etc/cron.d/certbot \
    && rm -f /etc/cron.hourly/* \
    && rm -f /etc/cron.daily/* \
    && rm -f /etc/cron.weekly/* \
    && rm -f /etc/cron.monthly/*

# cert creation script & bootstrap
COPY scripts/certs.sh /
COPY scripts/bootstrap.sh /

RUN mkdir /jail && chmod +x /certs.sh /bootstrap.sh /cert-renewal-haproxy.sh

EXPOSE 8080 8443

VOLUME /etc/letsencrypt
VOLUME /etc/haproxy

ENV STAGING=false

ENTRYPOINT ["sh", "/bootstrap.sh"]

#CMD ["sh", "-c", "tail -f /dev/null"]