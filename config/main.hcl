disable_update_check = true
log_json = true

server {
  enabled = true
  
  ## single node "cluster"
  bootstrap_expect = 1
}

client {
  enabled = true
}


# acl {
#   enabled = true
  
  /*
  Accessor ID  = 34dc7af7-c0f0-d4dd-653b-690225209d37
  Secret ID    = 52db7644-f51e-30b7-076a-fdb51bfe2724
  Name         = Bootstrap Token
  Type         = management
  Global       = true
  Policies     = n/a
  Create Time  = 2019-07-12 01:32:56.619701075 +0000 UTC
  Create Index = 32
  Modify Index = 32
  */
# }
