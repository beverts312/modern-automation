#!/bin/bash

openssl genrsa -out ${1}KEY.pem 2048
openssl req -subj "/CN=${1}" -new -key ${1}KEY.pem -out ${1}.csr  
openssl x509 -req -days 3650 -in ${1}.csr -CA ca.pem -CAkey CAkey.pem -CAcreateserial -out ${1}CRT.pem -extensions v3_req -extfile openssl.conf 
openssl rsa -in ${1}KEY.pem -out ${1}KEY.pem
