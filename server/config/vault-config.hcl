listener "tcp" {
 address = "0.0.0.0:8200"
 tls_disable = 1
}
storage "file" {
  path = "/Users/joseflores/git/vault/file"
}
disable_mlock = true
api_addr = "http://localhost:8200"
ui=true
