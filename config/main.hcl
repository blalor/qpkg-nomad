disable_update_check = true
log_json = true

acl {
  enabled = true
}

server {
  enabled = true
  
  ## single node "cluster"
  bootstrap_expect = 1
}

client {
  enabled = true
  
  chroot_env {
    ## defaults from https://www.nomadproject.io/docs/drivers/exec.html#chroot
    "/bin"            = "/bin"
    "/etc"            = "/etc"
    "/lib"            = "/lib"
    "/lib32"          = "/lib32"
    "/lib64"          = "/lib64"
    "/run/resolvconf" = "/run/resolvconf"
    "/sbin"           = "/sbin"
    "/usr"            = "/usr"
    
    ## QNAP-specific, because symlink hell
    "/mnt/HDA_ROOT/.config" = "/mnt/HDA_ROOT/.config"
  }  
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}
