## Prerequisites

### Install `terraform`

#### Install the `tfenv` terraform version manager

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

#### Use `tfenv` to install `terraform`

Install the latest version of `terraform`

```sh
tfenv install latest
```

Make it available in the current directory

```sh
tfenv use latest
```

### Generate a client certificate

```sh
openssl req \
    -subj '/CN=myclientcertificate/O=HashiCorp, Inc./ST=CA/C=US' \
    -new -newkey rsa:4096 \
    -sha256 -days 730 \
    -nodes -x509 \
    -keyout client.key \
    -out client.crt
```

See: https://discuss.hashicorp.com/t/azure-service-principal-client-certificate-error/32037?msclkid=9351d13bd12411ec96deb763dd60b7af
```sh
openssl pkcs12 \
    -certpbe PBE-SHA1-3DES \
    -keypbe PBE-SHA1-3DES \
    -export -macalg sha1 \
    -password pass:"<PASSWORD>" \
    -out client.pfx \
    -inkey client.key \
    -in client.crt
```

### Install the Azure CLI

```sh
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

### Create a service principle

```sh
az ad sp create-for-rbac --name terraform --cert @/path/to/cert
```

Add Microsoft Graph application permission Application.ReadWrite.All (Read and write all applications).

```sh
az ad app permission add --id <APP_ID> --api 00000003-0000-0000-c000-000000000000 --api-permissions 1bfefb4e-e0b5-418b-a88f-73c46d2cc8e9=Role
```

Grant admin consent

```sh
az ad app permission admin-consent --id <APP_ID>
```

## Initialise terraform repo

```sh
terraform init
```