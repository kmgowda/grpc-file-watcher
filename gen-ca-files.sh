#!/bin/bash

if [ -z "$1" ]
  then
    echo "No arguments supplied! Supply the certificate folder"
    exit
fi

cert_dir=$1
ca_cert_file=$cert_dir/ca_cert.pem
ca_key_file=$cert_dir/ca_key.pem

#remvoe the existing files
rm -rf $ca_key_file $ca_cert_file $ca_cert_sign_file
openssl req -x509 -newkey rsa:4096 -keyout $ca_key_file -out $ca_cert_file -days 365 -nodes  -subj "/C=IN/ST=KA/L=Bangalore/O=Test/OU=Test/CN=Root CA"
chmod 666 $ca_key_file $ca_cert_file $ca_cert_sign_file


