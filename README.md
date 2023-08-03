
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Postgresql high rate statement timeout incident.
---

This incident type refers to a scenario where there is a high rate of statement timeouts in a Postgresql database instance. This can lead to degraded performance and potentially impact the availability of the database. It is important to quickly identify and address the underlying cause of the timeouts to ensure the stability of the system.

### Parameters
```shell
# Environment Variables

export NEW_TIMEOUT_VALUE="PLACEHOLDER"

export DATABASE_PORT="PLACEHOLDER"

export DATABASE_USER="PLACEHOLDER"

export DATABASE_PASSWORD="PLACEHOLDER"

export DATABASE_HOST="PLACEHOLDER"

export DATABASE_NAME="PLACEHOLDER"
```

## Debug

### Verify that the Postgresql service is running
```shell
systemctl status postgresql.service
```

### Check the Postgresql logs for errors
```shell
journalctl -u postgresql.service --no-pager -n 50
```

### Check the Postgresql configuration for any settings that may be causing the timeouts
```shell
grep -v '^$\|^\s*\#'  /etc/postgresql/main/postgresql.conf | grep -iE 'statement_timeout|idle_in_transaction_session_timeout'
```

### Check the system resource usage to see if the server is overloaded
```shell
top
```

### Check the network connectivity between the application and database server
```shell
ping ${DATABASE_HOST}
```

### Check the disk usage of the database server
```shell
df -h
```

## Repair

### Define the variables
```shell
PG_CONFIG_FILE="/etc/postgresql/main/postgresql.conf"

TIMEOUT_VALUE="${NEW_TIMEOUT_VALUE}"
```

### Backup the original configuration file
```shell
cp $PG_CONFIG_FILE $PG_CONFIG_FILE.bak
```

### Update the timeout value in the configuration file
```shell
sed -i "s/statement_timeout = .*/statement_timeout = $TIMEOUT_VALUE/g" $PG_CONFIG_FILE
```

### Restart the Postgresql service to apply the changes
```shell
service postgresql restart
```

### Optimize the queries being executed in the database to reduce the load and prevent timeouts.
```shell
bash

#!/bin/bash



# Define the database connection parameters

DB_HOST=${DATABASE_HOST}

DB_PORT=${DATABASE_PORT}

DB_NAME=${DATABASE_NAME}

DB_USER=${DATABASE_USER}

DB_PASSWORD=${DATABASE_PASSWORD}



# Define the query to optimize

QUERY="PLACEHOLDER"



# Run the optimization command

PGOPTIONS="-c statement_timeout=0" psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "EXPLAIN ANALYZE $QUERY" > /dev/null


```