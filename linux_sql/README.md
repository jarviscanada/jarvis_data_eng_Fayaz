# Linux Cluster Monitoring Agent
This project is under development. Since this project follows the GitFlow, the final work will be merged to the master branch after Team Code Team.

## Introduction
(about 150-200 words)
Cluster Monitor Agent is an internal tool that monitors the cluster resources. It helps the infrastructure team to record the hardware specifications of each noe and monitor node resource usages (e.g. CPU/Memory)

## Architecture and Design
1) Draw a cluster diagram with three Linux hosts, a DB, and agents 
![](cluster_diagram.png)
2) Describe tables - There will be two tables: one for recording hardware specificications for each node and one for recording resource usage for each node
3) Describe scripts - Two main scripts: one to collect host hardware info and store it in a database and and one to collect current host usage and store it in a database

## Usage
1) how to init database and tables - start psql instance. This creates database. With ddl.sql two tables are created. 
2) 'host_info.sh' usage - script that collects hardware specs. This is run only once at setup.
3) 'host_usage.sh' usage- script that collects usage data. This is run every minute autmatically using crontab
4) crontab setup  * * * * * (for every minute)

## Improvements 
Write at least three things you want to improve 
1) handle hardware update 
2) optimize resource usage
3) improve future resource resource planning

