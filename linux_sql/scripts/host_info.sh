#!/bin/bash

#Assign Variables to Arguments
psql_host=$1 #Create, Stop, Start
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

if [ -z "$psql_host" ] || [ -z "$psql_port" ] || [ -z "$db_name" ]|| [ -z "$psql_user" ] ||[ -z "$psql_password" ] ; then
  echo "Invalid number of arguments, Please fill arguments correctly"
  exit 1
fi

#save CPU specs to a variable
lscpu_out=`lscpu`

#Obtain hardware specs
hostname=$(hostname -f)
cpu_number=$(echo "$lscpu_out"  | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$lscpu_out"  | egrep "^Architecture:" | awk '{print $2}' | xargs)
cpu_model=$(echo "$lscpu_out"  | egrep "^Model name:" | awk '{print $3,$4,$5,$6,$7}' | xargs)
cpu_mhz=$(echo "$lscpu_out"  | egrep "^CPU MHz:" | awk '{print $3}' | xargs)
l2_cache=$(echo "$lscpu_out"  | egrep "^L2 cache:" | awk '{print $3//[!0-9]/}' | xargs)
total_mem=$(echo "$(cat /proc/meminfo)"  | egrep "^MemTotal:" | awk '{print $2}' | xargs)
timestamp=`vmstat -t | awk '{getline; getline; print $18,$19}'`

#Set Insert Statement for host_info table in host_agent
insert_stmt="INSERT INTO host_info (hostname,cpu_number,cpu_architecture,cpu_model,cpu_mhz,L2_cache,total_mem,timestamp) VALUES ('$hostname',$cpu_number,'$cpu_architecture','$cpu_model',$cpu_mhz,$l2_cache,$total_mem,'$timestamp');"

#Login to PSQL instance and Insert values into host_info table
export PGPASSWORD=$psql_password
psql -h "$psql_host" -p "$psql_port" -d "$db_name" -U "$psql_user" -c "$insert_stmt"

exit 0