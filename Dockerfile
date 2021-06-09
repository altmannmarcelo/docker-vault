# Pull base image.
FROM ubuntu:focal

RUN apt update && DEBIAN_FRONTEND=noninteractive apt -y install wget gpg lsb-core

RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list

RUN apt update && apt install vault

COPY entrypoint.sh /bin/entrypoint.sh

RUN chmod +x /bin/entrypoint.sh

RUN cd /opt/vault/tls/ && \
    rm -rf *

COPY ssl.conf /opt/vault/tls/ssl.conf

RUN cat /opt/vault/tls/ssl.conf

RUN cd /opt/vault/tls/ && \
    openssl req -config ssl.conf -x509 -days 365 -batch -nodes -newkey rsa:2048 -keyout tls.key -out tls.crt && \
    cat tls.key tls.crt > tls.pem

EXPOSE 8200

RUN echo "disable_mlock = true" >>  /etc/vault.d/vault.hcl

RUN echo "export VAULT_CACERT=/opt/vault/tls/tls.crt" >> /etc/profile

CMD ["/bin/entrypoint.sh"]
