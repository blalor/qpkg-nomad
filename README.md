## enabling ACLs

[reference](https://www.nomadproject.io/guides/security/acl.html)

as `admin` on the NAS:

1. `cd $( getcfg Nomad Install_Path -f /etc/config/qpkg.conf  )`
2. `nomad acl bootstrap` and record output
3. ensure working: `NOMAD_TOKEN=<Secret ID> nomad node status -self`
4. generate token for init script: `NOMAD_TOKEN=<Secret ID> ./generate-init-script-token.sh`
5. ensure working: `NOMAD_TOKEN=$( cat startup-shutdown-token ) nomad node status -self`
5. `unset NOMAD_TOKEN; ./nomad.sh restart` to ensure everything _really_ works
