## Install `terraform`

Clone the `tfenv` git clone repo

```sh
git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
```

Add `tfenv`to your path

```sh
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
```

Source your bash profile to active it

```sh
source ~/.bash_profile 
```

Confirm the installation

```sh
tfenv --version
# tfenv 3.0.0
```

Install the latest version of `terraform`

```sh
tfenv install latest
```

```sh
tfenv use latest
```

## Install the Azure CLI

```sh
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

## Authentication

```sh
az login
```

### Generating a client certificate

```sh
openssl req -subj '/CN=myclientcertificate/O=HashiCorp, Inc./ST=CA/C=US' \
    -new -newkey rsa:4096 -sha256 -days 730 -nodes -x509 -keyout client.key -out client.crt
```


See: https://discuss.hashicorp.com/t/azure-service-principal-client-certificate-error/32037?msclkid=9351d13bd12411ec96deb763dd60b7af
```sh
openssl pkcs12 -certpbe PBE-SHA1-3DES -keypbe PBE-SHA1-3DES -export -macalg sha1 -password pass:"Pa55w0rd123" -out client.pfx -inkey client.key -in client.crt
```

## Initialise terraform repo

```sh
terraform init
```