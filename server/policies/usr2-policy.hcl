path "kv/data/usr2/*" {
  capabilities = ["create", "update", "read", "delete"]
}
path "kv/delete/usr2/*" {
  capabilities = ["update"]
}
path "kv/metadata/usr2/*" {
  capabilities = ["list", "read", "delete"]
}
path "kv/destroy/usr2/*" {
  capabilities = ["update"]
}

# Additional access for UI
path "kv/metadata" {
  capabilities = ["list"]
}
