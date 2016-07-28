#!/bin/bash

set -e

TARGET_NODE="$1"

if [[ -z $TARGET_NODE ]]; then
    echo "Target node not specified"
    exit 1
fi

(
IFS=$'\n'
for line in $(curl -XGET -s http://172.31.37.220:9200/_cat/shards | fgrep UNASSIGNED | head -n100 ); do
    echo $line
    
    index=$(echo $line | awk '{print $1}')
    shard=$(echo $line | awk '{print $2}')

    if [[ -z $shard ]]; then
        echo could not parse shard from line, index: $index
        continue
    fi

    echo reallocating index $index: shard $shard to node $TARGET_NODE
    curl -XPOST -s 'http://172.31.37.220:9200/_cluster/reroute' -d "{
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
