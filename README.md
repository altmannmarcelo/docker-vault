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
