#!/bin/bash

if [ -z "$1" ]
  then
    echo "No arguments supplied! Supply the certificate folder"
    exit
fi

cert_dir=$1
ca_cert_file=$cert_dir/ca_cert.pem
ca_key_file=$cert_dir/ca_key.pem

client_cert_file=$cert_dir/client_cert.pem
client_key_file=$cert_dir/client_key.pem
client_cert_signfile=$cert_dir/client_cert_sign.pem

#remvoe the existing files
rm -rf $client_cert_file $client_key_file $client_cert_signfile

# generate server certificate files
openssl genrsa  -out $client_key_file 4096
openssl req -new -key $client_key_file  -out $client_cert_signfile -subj "/C=IN/ST=KA/L=Bangalore/O=Test/OU=Client/CN=localhost"
openssl x509 -req -days 365  -in $client_cert_signfile -out $client_cert_file -CA $ca_cert_file -CAkey $ca_key_file  -set_serial 01
chmod 666 $client_cert_file $client_key_file $client_cert_signfile
