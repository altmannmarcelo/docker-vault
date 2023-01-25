#!/bin/sh

_MINIO_ROOT_USER=admin
_MINIO_ROOT_PASSWORD=password
_MINIO_PORT=9000
if [ ! -z "$USER" ]; then
    _MINIO_ROOT_USER=$USER
fi
if [ ! -z "$PASSWORD" ]; then
    _MINIO_ROOT_PASSWORD=$PASSWORD
fi
if [ ! -z "$PORT" ]; then
    _MINIO_PORT=$PORT
fi


# generate self signed certs
#cd /root/.minio/certs
#openssl genrsa -out private.key 2048

#MINIO_ROOT_USER=${_MINIO_ROOT_USER} MINIO_ROOT_PASSWORD=${_MINIO_ROOT_PASSWORD} minio server --address :${_MINIO_PORT} /mnt/data
export VAULT_CACERT=/opt/vault/tls/tls.crt
/usr/bin/vault server -config=/etc/vault.d/vault.hcl &
sleep 5
vault operator init > /opt/vault/init.file
for key in $(cat /opt/vault/init.file | grep 'Unseal Key' | awk '{print $4}'); do vault operator unseal $key; done
vault login $(cat /opt/vault/init.file | grep 'Initial Root Token' | awk '{print $4}')
vault secrets enable -path=secret kv-v2
SERVER_IP=127.0.0.1
VAULT_TOKEN=$(cat /opt/vault/init.file | grep 'Initial Root Token' | awk '{print $4}')
sleep 2
echo "*************************"
echo "Remote Config"
echo "*************************"
echo "docker cp vault:/opt/vault/tls/tls.crt ~/vault.crt"
echo "export VAULT_ADDR=https://${SERVER_IP}:8200"
echo "export VAULT_CACERT=~/vault.crt"
echo "export VAULT_CA=~/vault.crt"
echo "export VAULT_TOKEN=${VAULT_TOKEN}"
echo "*************************"
echo "*************************"
echo "Run with PXB"
echo "*************************"
echo "docker cp vault:/opt/vault/tls/tls.crt ~/vault.crt"
echo "VAULT_URL=https://${SERVER_IP}:8200 VAULT_CACERT=\${HOME}/vault.crt VAULT_CA=\${HOME}/vault.crt VAULT_TOKEN=${VAULT_TOKEN} ./run.sh"
echo "*************************"

wait

