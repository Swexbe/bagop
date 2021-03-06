#!/bin/bash
# Makes sure we exit if flock fails.
set -e
(
    echo "****LT: WAITING FOR LOCK****"
    # Wait for lock on /var/lock/.bagop (fd 200) for 10000 seconds
    flock -x 200
    echo "****RUNNING LONG-TERM BACKUP****"
    # Do sbackup
    bagop -b -force-color=${BAGOP_COLOR:-true} -v=${BAGOP_VERBOSE:-false} -ttl=$BAGOP_LT_TTL
    echo "****RUNNING CLEAN****"
    bagop -c -force-color=${BAGOP_COLOR:-true} -v=${BAGOP_VERBOSE:-false}
    echo "****LT: LETTING GO OF LOCK****"
) 200>/var/lock/.bagop
