bind_addr = "0.0.0.0"
data_dir  = "{{nomad_dir}}"
datacenter = "{{nomad_env}}"

advertise {
  http = "{{privip}}"
  rpc  = "{{privip}}"
  serf = "{{privip}}"
}

server {
  enabled            = true
  bootstrap_expect   = {{nomad_ips[:-1].split(',')|count}}
  rejoin_after_leave = true
}

client {
  enabled = true
  options {
    "driver.raw_exec.enable"     = "1"
    "docker.cleanup.image"       = true
    "docker.cleanup.image.delay" = "3h"
  }
}

consul {
  address = "{{privip}}:8500"
  server_auto_join = true
  client_auto_join = true
}

enable_syslog = true
log_level     = "DEBUG"
