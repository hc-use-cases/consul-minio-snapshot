client_addr        = "127.0.0.1"
bind_addr          = "{{ GetInterfaceIP \"enp0s8\" }}"
data_dir           = "/opt/consul"
datacenter         = "east"
log_level          = "DEBUG"
server             = false
enable_syslog      = true
retry_join         = ["192.168.178.31", "192.168.178.32", "192.168.178.33"]
