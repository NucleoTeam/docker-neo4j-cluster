#!/bin/bash
echo "==> Setting server IP config"
CONFIG_FILE=/var/lib/neo4j/conf/neo4j.conf
SERVER_IP=$(ip route get 8.8.8.8 | awk 'NR==1{print $NF}')

/var/lib/neo4j/bin/neo4j console
