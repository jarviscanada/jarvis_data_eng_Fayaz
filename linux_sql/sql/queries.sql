-- GET CPU number, id and total_mem, Group by CPU number, Order total_mem
SELECT max(cpu_number) OVER (
    PARTITION BY cpu_number
    ORDER BY total_mem DESC)
    AS cpu_number,
    id,
    total_mem
    from host_info;

--CREATE FUNCTION that rounds timestamp to 5 minute intervals
CREATE FUNCTION round_minutes(TIMESTAMP WITHOUT TIME ZONE, integer)
RETURNS TIMESTAMP WITHOUT TIME ZONE AS $$
  SELECT
     date_trunc('hour', $1)
     +  cast(($2::varchar||' min') as interval)
     * round(
     (date_part('minute',$1)::float + date_part('second',$1)/ 60.)::float
     / $2::float
      )
$$ LANGUAGE SQL IMMUTABLE;

--Add interval_time column to host_usage table
ALTER Table host_usage
    ADD COLUMN IF NOT EXISTS interval_time timestamp;

--Input rounded interval values into interval_time column in host_usage
UPDATE host_usage
    SET interval_time = round_minutes(timestamp, 5);

--Get Average used memory in percentage over 5 mins interval for each host
SELECT  host_id,
        (select hostname from host_info where id = host_id) as host,
        interval_time,
        --AVG memory usage= (mem_total-mem_free)/mem_total * 100
        (AVG(((select total_mem from host_info where id = host_id)-memory_free::decimal)/(select total_mem from host_info where id = host_id))*100)::integer as used_mem_percentege
        from host_usage
        group by
               host_id,
               host,
               interval_time;