
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Slow query performance in PostgreSQL
---

This incident type generally refers to situations where queries in a PostgreSQL database are taking longer than expected to execute. This can lead to slow application performance and a poor user experience. It may require a deep dive into the database schema and query execution plans to diagnose and optimize the slow queries. Common solutions may include indexing, rewriting the query, or tuning the database configuration.

### Parameters
```shell
export DATABASE_NAME="PLACEHOLDER"

export TABLE_NAME="PLACEHOLDER"

export IDLE="PLACEHOLDER"

export QUERY="PLACEHOLDER"

export VERSION="PLACEHOLDER"

export COLUMN_NAME="PLACEHOLDER"
```

## Debug

### Check current connections to the database
```shell
sudo -u postgres psql -c "SELECT * FROM pg_stat_activity;"
```

### Check the size of the database
```shell
sudo -u postgres psql -c "SELECT pg_size_pretty(pg_database_size('${DATABASE_NAME}'));"
```

### Check the size of individual tables
```shell
sudo -u postgres psql -c "SELECT pg_size_pretty(pg_total_relation_size('${TABLE_NAME}'));"
```

### Check for long-running queries
```shell
sudo -u postgres psql -c "SELECT pid, now() - query_start AS duration, query FROM pg_stat_activity WHERE query != '${IDLE}' AND now() - query_start > INTERVAL '5 minutes' ORDER BY duration DESC;"
```

### Explain a specific query to see its execution plan
```shell
sudo -u postgres psql -c "EXPLAIN ANALYZE ${QUERY};"
```

### Check the slow query log to identify frequently executed slow queries
```shell
sudo grep -i "duration" /var/log/postgresql/postgresql-${VERSION}-main.log | grep -v "duration: 0." | sort -u
```

## Repair

### Lack of proper indexing: If a large amount of data is being queried without proper indexing, the database engine may have to perform a lot of disk I/O to find the requested data. This can slow down query execution time significantly.
```shell
bash

#!/bin/bash



# Set variables

DB_NAME=${DATABASE_NAME}

TABLE_NAME=${TABLE_NAME}

COLUMN_NAME=${COLUMN_NAME}



# Check if indexing exists on column

INDEX_EXISTS=$(psql -U postgres -d $DB_NAME -c "\d+ $TABLE_NAME" | grep -o "$COLUMN_NAME" | wc -l)



# If indexing does not exist, create an index

if [ "$INDEX_EXISTS" -eq "0" ]; then

  psql -U postgres -d $DB_NAME -c "CREATE INDEX idx_$TABLE_NAME\_$COLUMN_NAME ON $TABLE_NAME ($COLUMN_NAME);"

  echo "Index created successfully."

else

  echo "Index already exists."

fi


```