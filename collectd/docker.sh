#!/bin/sh

 HOSTNAME="${COLLECTD_HOSTNAME:-localhost}"
 INTERVAL="${COLLECTD_INTERVAL:-60}"
 IFS='
'

postData() {
    echo "PUTVAL \"$HOSTNAME/exec-docker-$2/gauge-$1\" interval=$INTERVAL N:$3"
}

collectStats() {
    for x in `docker stats --no-stream`
    do
        CONTAINER=$(echo $x | awk '{print $2}')
        postData $CONTAINER cpu $(echo $x | awk '{print $3}')
        postData $CONTAINER memory $(echo $x | awk '{print $7}')
    done
}

while sleep "$INTERVAL"; do
    collectStats
done