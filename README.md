# Vault docker container

## What is this container ?

This container was created to enable *integration testing* against vault.


For convenience, the following commands are available in the container :

## How to use this container

### Docker Hub image
I start the container using the following command:


```
docker run -d --security-opt seccomp=unconfined --cap-add=NET_ADMIN --rm -p 8200:8200 --name vault altmannmarcelo/vault:latest
```


### Building local image

Build a local image using the Dockerfile

```
docker build .

. . .
Successfully built 5f1fd412b0e4

```

Then start the container passing the hash id from previous command

```
docker run -d --security-opt seccomp=unconfined --cap-add=NET_ADMIN --rm -p 8200:8200 --name vault 5f1fd412b0e4
```

Alternatively, you can pass `-t your_user/image_name#tag` parameter to build command and use that as image ID:

```
docker build -t altmannmarcelo/vault:latest .
docker run -d --security-opt seccomp=unconfined --cap-add=NET_ADMIN --rm -p 8200:8200 --name vaultaltmannmarcelo/vault:latest
```

In order to use vault, you will have to copy the crt certificate:


```
docker cp vault:/opt/vault/tls/tls.crt ~/vault.crt
```

You can extract vault token by inspecting the logs:

```
docker logs vault

Key                  Value
---                  -----
token                hvs.nNElbwOEVXPaFQShq8yXUXB5
token_accessor       wivewunP8QexkpWtiSwlGRTh
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]
2023-01-25T15:56:39.100Z [INFO]  core: successful mount: namespace="" path=secret/ type=kv
Success! Enabled the kv-v2 secrets engine at: secret/
2023-01-25T15:56:39.110Z [INFO]  secrets.kv.kv_862b6a3c: collecting keys to upgrade
2023-01-25T15:56:39.110Z [INFO]  secrets.kv.kv_862b6a3c: done collecting keys: num_keys=1
2023-01-25T15:56:39.110Z [INFO]  secrets.kv.kv_862b6a3c: upgrading keys finished
*************************
Remote Config
*************************
docker cp vault:/opt/vault/tls/tls.crt ~/vault.crt
export VAULT_ADDR=https://127.0.0.1:8200
export VAULT_CACERT=~/vault.crt
export VAULT_CA=~/vault.crt
export VAULT_TOKEN=hvs.nNElbwOEVXPaFQShq8yXUXB5
*************************
*************************
Run with PXB
*************************
docker cp vault:/opt/vault/tls/tls.crt ~/vault.crt
VAULT_URL=https://127.0.0.1:8200 VAULT_CACERT=${HOME}/vault.crt VAULT_CA=${HOME}/vault.crt VAULT_TOKEN=hvs.nNElbwOEVXPaFQShq8yXUXB5 ./run.sh
*************************

```
