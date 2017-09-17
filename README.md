# ekino/neo4j-cluster

[![Circle CI](https://circleci.com/gh/ekino/docker-neo4j-cluster.svg?style=svg)](https://circleci.com/gh/ekino/docker-neo4j-cluster)

## Description

Get a Neo4J cluster in no time.

## Licensing

This repo uses Neo4J Enterprise, installed following the official and publicly
available page http://debian.neo4j.org/.

You **must** have a license to use Neo4J Enterprise, and as a consequence to use
this repo.

For more informations :
- Licenses :  http://neo4j.com/subscriptions/
- Contact : http://neo4j.com/contact-us/

## TL;DR

If you are on linux :
```bash
# start a neo4j cluster w/ 3 nodes
curl -sSL https://raw.githubusercontent.com/ekino/docker-neo4j-cluster/master/helper.sh | bash -s run:neomaster,neoreadslave,neobackup
```

## Cluster Creation

### Prerequisites

Clone the repo :
```bash
git clone https://github.com/NucleoTeam/neo4j-cluster-rancher.git
cd neo4j-cluster-rancher
```
Rancher CLI 1.6.3+
Atleast 2 servers in cluster

### Cluster initialisation (auto)

```bash
./build.sh neo4j-cluster http://127.0.0.1:8080/ <access> <key>
```
