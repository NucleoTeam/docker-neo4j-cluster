#!/bin/bash

DIRECTORY="executed"

#set -x
if [ ! -d "$DIRECTORY" ]; then
        # Check of env variable. Complains+Help if missing
        if [ -z "$SERVER_ID" ]; then
          echo >&2 "--------------------------------------------------------------------------------"
          echo >&2 "- Missing mandatory SERVER_ID ( for example : docker run -e SERVER_ID=2 .... ) -"
          echo >&2 "--------------------------------------------------------------------------------"
          exit 1
        fi

        # Customize config
        echo "==> Setting server IP config"
        CONFIG_FILE=/var/lib/neo4j/conf/neo4j.conf
        SERVER_IP=$(ip route get 8.8.8.8 | awk 'NR==1{print $NF}')

        sed -i 's/SERVER_ID/'$SERVER_ID'/' $CONFIG_FILE
        sed -i 's/SERVER_IP/'$SERVER_IP'/' $CONFIG_FILE

        echo "==> Global settings"
        if [ "$SERVER_ID" = "1" ]; then
          # All this node to init the cluster all alone (initial_hosts=127.0.0.1)
          sed -i '/^ha.allow_init_cluster/s/false/true/' $CONFIG_FILE
        fi

        OIFS=$IFS
        if [ ! -z "$CLUSTER_NODES" ]; then
          IFS=','
          for i in $CLUSTER_NODES
          do
            sed -i '/^ha.initial_hosts/s/$/'${i%%_*}':5001,/' $CONFIG_FILE
          done
          sed -i '/^ha.initial_hosts/s/,$//' $CONFIG_FILE
        fi
        IFS=$OIFS

        echo "==> Server settings"
        sed -i 's/^#\(org.neo4j.server.database.mode=\)/\1/' /var/lib/neo4j/conf/neo4j.conf

        if [ "$REMOTE_HTTP" = "true" ]; then
          sed -i '/org.neo4j.server.webserver.address/s/^#//' /var/lib/neo4j/conf/neo4j.conf
        fi

        if [ "$REMOTE_SHELL" = "true" ]; then
          sed -i '/remote_shell_enabled/s/^#//' $CONFIG_FILE
        fi

        # Review config (for docker logs)

        echo "==> Settings review"
        echo
        (
        echo " --- $(hostname) ---"
        echo "Graph settings :"
        grep --color -rE "allow_init_cluster|server_id|cluster_server|initial_hosts|\.server=|webserver\.address|database\.mode" /var/lib/neo4j/
        echo
        echo "Network settings :"
        ip addr | awk '/inet /{print $2}'
        ) | awk '{print "   review> "$0}'
        echo
        mkdir $DIRECTORY
fi
echo "==> Starting Neo4J server (with supervisord)"
echo
/var/lib/neo4j/bin/neo4j console
