#!/bin/bash

if [ -z "$1" ]
  then
    echo "No arguments supplied! Supply the certificate folder"
    exit
fi

cert_dir=$1
ca_cert_file=$cert_dir/ca_cert.pem
ca_key_file=$cert_dir/ca_key.pem

server_cert_file=$cert_dir/server_cert.pem
server_key_file=$cert_dir/server_key.pem
server_cert_signfile=$cert_dir/server_cert_sign.pem


#remvoe the existing files
rm -rf $server_cert_file $server_key_file $server_cert_signfile

# generate server certificate files
openssl genrsa  -out $server_key_file 4096
openssl req -new -key $server_key_file  -out $server_cert_signfile -subj "/C=IN/ST=KA/L=Bangalore/O=Test/OU=Server/CN=localhost"
openssl x509 -req -days 365  -in $server_cert_signfile -out $server_cert_file -CA $ca_cert_file -CAkey $ca_key_file  -set_serial 01
chmod 666 $server_cert_file $server_key_file $server_cert_signfile
