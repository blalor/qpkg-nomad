#!/bin/bash
set -e -u -o pipefail

CONF=/etc/config/qpkg.conf
export QPKG_NAME="Nomad"

QPKG_ROOT=$( /sbin/getcfg $QPKG_NAME Install_Path -f ${CONF} )
#APACHE_ROOT=$( /sbin/getcfg SHARE_DEF defWeb -d Qweb -f /etc/config/def_share.info )

declare -r NOMAD="${QPKG_ROOT}/nomad"
declare -r DATA_DIR="${QPKG_ROOT}/data-dir"
declare -r PID_FILE="${QPKG_ROOT}/nomad.pid"
declare -r LOG_FILE="${QPKG_ROOT}/nomad.log"
declare -r CONFIG_FILE="${QPKG_ROOT}/main.hcl"
declare -r ELIGIBILITY_FLAG="${QPKG_ROOT}/make-eligible-on-start"

cd "${QPKG_ROOT}"

case "$1" in
    start)
        ENABLED=$( /sbin/getcfg $QPKG_NAME Enable -u -d FALSE -f $CONF )
        if [ "$ENABLED" != "TRUE" ]; then
            echo "$QPKG_NAME is disabled."
            exit 1
        fi
        
        ln -s "${NOMAD}" /usr/bin/nomad
        
        if [ ! -d "${DATA_DIR}" ]; then
            mkdir "${DATA_DIR}"
        fi
        
        "${NOMAD}" agent -config="${CONFIG_FILE}" -data-dir="${DATA_DIR}" >> "${LOG_FILE}" &
        echo -n $! > "${PID_FILE}"
        
        if [ -e "${ELIGIBILITY_FLAG}" ]; then
            ## node marked ineligible on shutdown; re-enable
            while ! "${NOMAD}" node status -self >/dev/null ; do
                sleep 3
                "${NOMAD}" node eligibility -enable -self
                rm -f "${ELIGIBILITY_FLAG}"
            done
        fi
    ;;

    stop)
        if [ -e "${PID_FILE}" ]; then
            "${NOMAD}" node drain -enable -yes -self || true
            touch "${ELIGIBILITY_FLAG}"
            kill "$( cat "${PID_FILE}" )"
        fi
        
        rm -f /usr/bin/nomad "${PID_FILE}"
    ;;

    restart)
        $0 stop
        $0 start
    ;;

    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
esac

exit 0
