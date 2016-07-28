#!/bin/bash

# SET THESE BEFORE RUNNING OR SET ENVVARS EXTERNALLY
[[ -z $ES_MASTER]] && ES_MASTER="IP_OR_DNS_NAME"
[[ -z $ES_PORT ]] && ES_PORT="9200" # Port that ES_MASTER is listening on
[[ -z $AT_A_TIME ]] && AT_A_TIME=100 # The number of unassigned shards to allocate per run

set -e

TARGET_NODE="$1"

if [[ -z $TARGET_NODE ]]; then
    echo "Target node not specified"
    exit 1
fi

(
IFS=$'\n'
for line in $(curl -XGET -s "http://$ES_MASTER:$ES_PORT/_cat/shards" | fgrep UNASSIGNED | head -n$AT_A_TIME ); do
    index=$(echo $line | awk '{print $1}')
    shard=$(echo $line | awk '{print $2}')

    if [[ -z $shard ]]; then
        echo could not parse shard from line, index: $index
        continue
    fi

    echo reallocating index $index: shard $shard to node $TARGET_NODE
    curl -XPOST -s "http://$ES_MASTER:$ES_PORT/_cluster/reroute" -d "{
        \"commands\" : [ {
              \"allocate\" : {
                  \"index\" : \"$index\", 
                  \"shard\" : $shard, 
                  \"node\" : \"$TARGET_NODE\", 
                  \"allow_primary\" : \"true\"
              }
            }
        ]
    }"
    sleep 5
done
)
