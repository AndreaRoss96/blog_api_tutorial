#!/bin/bash
# sources:
# https://kubernetes.github.io/ingress-nginx/user-guide/tls/    --> TLS/HTTPS
# https://discuss.kubernetes.io/t/add-on-ingress/11259/2        --> microk8s enable ingress
# https://shocksolution.com/2018/12/14/creating-kubernetes-secrets-using-tls-ssl-as-an-example/

KEY_FILE = tls.key
CERT_FILE = tls.crt
HOST = "/0=try "
# Generate self-signed certificate and a provate key 
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${KEY_FILE} -out ${CERT_FILE} -subj "/CN=${HOST}/O=${HOST}"

# Create the TLS secret in the cluster
kubectl create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE}

# The resulting secret will be of type kubernetes.io/tls

# Ingress controller provide the flag --default-ssl-certificate that contains
# the default certificate to be used when accessingthe catch-all server.
microk8s enable ingress:default-ssl-certificate=default/blog-tls-secret
