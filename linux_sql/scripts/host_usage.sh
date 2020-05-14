#!/bin/bash

#Assign Variables to Arguments
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

if [ -z "$psql_host" ] || [ -z "$psql_port" ] || [ -z "$db_name" ]|| [ -z "$psql_user" ] ||[ -z "$psql_password" ] ; then
  echo "Invalid number of arguments, Please fill arguments correctly"
fi

#Obtain usage info
hostname=$(hostname -f)
timestamp=`vmstat -t | awk '{getline; getline; print $18,$19}'`
memory_free=$(echo "$(cat /proc/meminfo)"  | egrep "^MemFree:" | awk '{print $2}' | xargs)
cpu_idle=`vmstat -t | awk '{getline; getline; print $15}'`
cpu_kernel=`vmstat -t | awk '{getline; getline; print $14}'`
disk_io=$(echo "$(vmstat -d)"  | egrep "^sda" | awk '{print $10}' | xargs)
disk_available=$(echo "$(df -BM)"  | egrep "^/dev/sda2" | awk '{print $4//[!0-9]/}' | xargs)

#Set Insert Statement for host_usage table in host_agent
insert_stmt="INSERT INTO host_usage (timestamp, host_id,memory_free,cpu_idle,cpu_kernel,disk_io,disk_available) VALUES ('$timestamp',(SELECT id FROM host_info where hostname = '$hostname'),$memory_free,$cpu_idle,$cpu_kernel,$disk_io,$disk_available);"

#Login to PSQL instance and insert values into host_usage table
export PGPASSWORD=$psql_password
psql -h "$psql_host" -p "$psql_port" -d "$db_name" -U "$psql_user" -c "$insert_stmt"

exit 0