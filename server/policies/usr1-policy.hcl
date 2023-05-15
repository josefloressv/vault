path "kv/data/usr1/*" {
  capabilities = ["create", "update", "read", "delete"]
}
path "kv/delete/usr1/*" {
  capabilities = ["update"]
}
path "kv/metadata/usr1/*" {
  capabilities = ["list", "read", "delete"]
}
path "kv/destroy/usr1/*" {
  capabilities = ["update"]
}

# Additional access for UI
path "kv/metadata" {
  capabilities = ["list"]
}
