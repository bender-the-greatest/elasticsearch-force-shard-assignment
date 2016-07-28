# elasticsearch-force-shard-assignment
Bash script to force allocation of Elasticsearch shards to a specific node.

Sometimes ES takes a really long time to assign unassigned shards in the case of a rolling restart or in other scenarios. Use this script to speed up the process.

Usage
=====

```
./force-assign.sh es-master data-node

Example:

./force-assign.sh master0.elastic.domain.tld datanode1

```
