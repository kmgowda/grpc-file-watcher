# grpc-secure-helloworld

The GRPC greeter server and client implementation with TLS certificates.
The File watcher implementation for TLS Reload is also implemented

## how to build?

1. export MY_INSTALL_DIR=<path where GRPC is installed>
   1. in case , if you need details on how to build GRPC , refer here:[How to build GRPC](#How to build GRPC) 

2. goto folder cpp

3. mkdir -p cmake/build

4. pushd cmake/build

5. cmake -DCMAKE_PREFIX_PATH=$MY_INSTALL_DIR ../..

6. make -j

you will find the executables secure_greeter_server and secure_greeter_client in the folder cmake/build


## how to run/test?

1. got to folder cmake/build

2. Run the executable : secure_greeter_server -ca <CA file path> -cert <Certificate path> -key <key file>

```
        example:
        
    ./secure_greeter_server -ca /Users/kmg/projects/grpc/examples/cpp/helloworld/certificates/ca.pem -cert /Users/kmg/projects/grpc/examples/cpp/helloworld/certificates/cert.pem -key /Users/kmg/projects/grpc/examples/cpp/helloworld/certificates/key.pem
```

   or you can execute with file water TLS reload executable as follows

```
example:

    ./secure_greeter_tls_server -ca ./certs/ca_cert.pem -cert ./certs/server_cert.pem  -key ./certs/server_key.pem
```


3. in the other shell window : secure_greeter_client -ca <CA file path> -cert <Certificate path> -key <key file>
    1. for client, you set the server ip , using -target option too.
    
    ```
   example:
   ./secure_greeter_client -ca /Users/kmg/projects/grpc/examples/cpp/helloworld/certificates/ca.pem -cert /Users/kmg/projects/grpc/examples/cpp/helloworld/certificates/cert.pem -key /Users/kmg/projects/grpc/examples/cpp/helloworld/certificates/key.pem

    ```

## how to generate certificates ?

follow this link: https://github.com/grpc/grpc/issues/9593 for useful openssl command to generate the certificates.
and secure server/client example codes.

here the same script snippet

```
#!/bin/bash

# Generate valid CA
openssl genrsa -passout pass:1234 -des3 -out ca.key 4096
openssl req -passin pass:1234 -new -x509 -days 365 -key ca.key -out ca.crt -subj  "/C=IN/ST=KA/L=Bangalore/O=Test/OU=Test/CN=Root CA"

# Generate valid Server Key/Cert
openssl genrsa -passout pass:1234 -des3 -out server.key 4096
openssl req -passin pass:1234 -new -key server.key -out server.csr -subj  "/C=IN/ST=KA/L=Bangalore/O=Test/OU=Server/CN=localhost"
openssl x509 -req -passin pass:1234 -days 365 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt

# Remove passphrase from the Server Key
openssl rsa -passin pass:1234 -in server.key -out server.key

# Generate valid Client Key/Cert
openssl genrsa -passout pass:1234 -des3 -out client.key 4096
openssl req -passin pass:1234 -new -key client.key -out client.csr -subj  "/C=IN/ST=KA/L=Bangalore/O=Test/OU=Client/CN=localhost"
openssl x509 -passin pass:1234 -req -days 365 -in client.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out client.crt

# Remove passphrase from Client Key
openssl rsa -passin pass:1234 -in client.key -out client.key

```
 
you can execute the scripts [gen-ca-files.sh](gen-ca-files.sh) to generate the CA files and [gen-tls-server-files](gen-tls-server-files.sh) to generate the server key and certifidates.
The scripts [gen-tls-client-files.sh](gen-tls-client-files.sh) can be used to generate the certificates for client side.

### Common SSL errors
The common  SSL errors  from  secure and insecure client/server are  SSL routines:OPENSSL_internal:WRONG_VERSION_NUMBER) and from the bad use of certificates for grpc (SSL routines:OPENSSL_internal:CERTIFICATE_VERIFY_FAILED).
The above certificates generated with above open commands resolves these command SSL errors. 


### How to build GRPC
refer to this page : https://grpc.io/docs/languages/cpp/quickstart/ for the detailed steps

...
1. export MY_INSTALL_DIR=$HOME/.local
2. git clone --recurse-submodules -b v1.50.0 --depth 1 --shallow-submodules https://github.com/grpc/grpc
3. $ cd grpc
   
   $ mkdir -p cmake/build
   
   $ pushd cmake/build
   
   $ cmake -DgRPC_INSTALL=ON \
   -DgRPC_BUILD_TESTS=OFF \
   -DCMAKE_INSTALL_PREFIX=$MY_INSTALL_DIR \
   ../..
   
   $ make -j 4
   
   $ make install
   
   $ popd

The step2 generate the executables of grpc in $MY_INSTALL_DIR
...
