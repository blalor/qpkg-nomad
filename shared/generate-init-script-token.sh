#!/bin/bash
set -e -u -o pipefail

basedir="$( readlink -f "$( dirname "${0}" )" )"
declare -r basedir

declare -r token_file="${basedir}/startup-shutdown-token"
declare -r policy_file="${basedir}/policy-startup-shutdown.hcl"

nomad acl policy apply -description "init script operations" startup-shutdown "${policy_file}"

nomad acl token create -name="startup-shutdown" -policy="startup-shutdown" \
    | awk -F= '/Secret ID/ {gsub(" ", "", $2); print $2}' \
    > "${token_file}"

chmod 400 "${token_file}"
