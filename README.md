# AWS Immersion Day with HashiCorp Vault

## Vault
Vault is a tool for securely accessing secrets. A secret is anything that you want to tightly control access to, such as API keys, passwords, or certificates. Vault provides a unified interface to any secret, while providing tight access control and recording a detailed audit log.

Vault tightly controls access to secrets by authenticating against trusted sources of identity such as Active Directory, LDAP, Kubernetes, CloudFoundry, and cloud platforms. Vault enables fine grained authorization of which users and applications are permitted access to secrets.

### Install
https://developer.hashicorp.com/vault/downloads

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/vault
```

### The Vault CLI
```bash
vault version
vault secret -h
vault read -h
vault server -h
```
#### Start the server in Dev mode
https://developer.hashicorp.com/vault/docs/concepts/dev-server
```bash
vault server -dev -dev-listen-address=0.0.0.0:8200 -dev-root-token-id=root
vault server -dev -dev-root-token-id="root"
```

Validate from UI\
http://0.0.0.0:8200
Log into the Vault UI with Method set to Token and Token set to root.

### Your First Secret
https://developer.hashicorp.com/vault/docs/secrets/kv/kv-v2
```bash
export VAULT_ADDR='http://0.0.0.0:8200'
vault kv put secret/my-first-secret age=xx
```
You can also create from the UI\
http://0.0.0.0:8200

```bash
# get secret
vault kv get secret/my-first-secret
vault secrets list
```

### The Vault API
https://developer.hashicorp.com/vault/api-docs

```bash
# Check health server
curl http://localhost:8200/v1/sys/health | jq

# Retrieve secrets, authentication by default token
curl --header "X-Vault-Token: root" http://localhost:8200/v1/secret/data/my-first-secret | jq
```
### Run a Production Server
https://developer.hashicorp.com/vault/docs/configuration
https://developer.hashicorp.com/vault/docs/commands/operator/init
https://developer.hashicorp.com/vault/docs/concepts/seal

```bash
vault server -config=./server/config/vault-config.hcl

# in another tab
export VAULT_ADDR='http://0.0.0.0:8200'
vault operator init -key-shares=1 -key-threshold=1
# save the unseal key 1 and the initial root token
```
Unseal Vault
```bash
vault operator unseal
vault status
```
You can also create from the UI and login with the new root token\
http://0.0.0.0:8200

Note: this server doesn't have configured any secrets engine, let's create on next step

### Use the KV V2 Secrets Engine
```bash
export VAULT_TOKEN=<root_token>
# or add in your profile
# If Alpine linux
echo "export VAULT_TOKEN=$VAULT_TOKEN" >> /root/.profile

vault secrets enable -version=2 kv
```

new secret
```bash
vault kv put kv/a-secret value=1234
```
### Use the Userpass Auth Method
```bash
vault auth enable userpass
vault write auth/userpass/users/<name> password=<pwd>

#You can also login with the Vault CLI:
vault login -method=userpass username=<name> password=<pwd>
```
### Use Vault Policies
```bash
# Create the policies on server side
vault policy write usr1 ./server/policies/usr1-policy.hcl
vault policy write usr2 ./server/policies/usr2-policy.hcl

# Assign the policies to users
vault write auth/userpass/users/usr1/policies policies=usr1
vault write auth/userpass/users/usr2/policies policies=usr2
```

```bash
vault token capabilities kv/usr1
```

```bash
# with usr1
vault login -method=userpass username=usr1 password=usr1
export VAULT_TOKEN=<usr1_token>

vault kv put kv/usr1/age age=40
vault kv get kv/usr1/age

vault kv put kv/<user>/weight weight=150
```