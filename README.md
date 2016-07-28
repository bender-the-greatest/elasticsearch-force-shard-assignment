# elasticsearch-force-shard-assignment
Bash script to force allocation of Elasticsearch shards to a specific node.

Sometimes ES takes a really long time to assign unassigned shards in the case of a rolling restart or in other scenarios. Use this script to speed up the process.

Usage
=====

```
./force-assign.sh data-node

Example:

# This will allocate all shards to data node one
./force-assign.sh datanode1

```

Environment Variables
=====================
You can either hardcode these or set them before running the script.

* ES_MASTER: IP address or DNS name of the Elasticsearch master node to use.
* ES_PORT: Port that the ES_MASTER is listening on.
* AT_A_TIME: Defaults to 100. This is set because you may not want all unassigned shards to go onto one node. If you *really* want to, set this to a number higher than the unallocated shards in the cluster.'

The data node is not configured as an envvar because this value is sure to change the most often.
