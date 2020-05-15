--Go to host_agent database
\c host_agent

-- HOST INFO TABLE
-- DDL
CREATE TABLE IF NOT EXISTS PUBLIC.host_info
  (
     id               SERIAL    NOT NULL,
     hostname         VARCHAR   UNIQUE NOT NULL,
     cpu_number       INTEGER   NOT NULL,
     cpu_architecture VARCHAR   NOT NULL,
     cpu_model        VARCHAR   NOT NULL,
     cpu_mhz          NUMERIC   NOT NULL,
     L2_cache         INTEGER   NOT NULL,
     total_mem        INTEGER   NOT NULL,
     timestamp      TIMESTAMP NOT NULL,
     PRIMARY KEY (id)
  );

-- DML
-- INSERT statement sample values into host_info table
INSERT INTO host_info (id, hostname,cpu_number,cpu_architecture,cpu_model,cpu_mhz,L2_cache,total_mem,timestamp)
    values(1,'pry-framework-236416.internal',1,'x86_64','Intel(R) Xeon(R) CPU @ 2.30GHz',2300.000,256,601324,'2019-05-29 17:49:53');

-- HOST USAGE TABLE
-- DDL
CREATE TABLE PUBLIC.host_usage
  (
     timestamp    TIMESTAMP NOT NULL,
     host_id        SERIAL    NOT NULL,
     memory_free    INTEGER   NOT NULL,
     cpu_idle       INTEGER   NOT NULL,
     cpu_kernel     INTEGER   NOT NULL,
     disk_io        INTEGER   NOT NULL,
     disk_available INTEGER   NOT NULL,
     FOREIGN KEY (host_id) REFERENCES host_info(id)
  );

-- DML
-- INSERT statement sample values into host_usage table
INSERT INTO host_usage (timestamp, host_id,memory_free,cpu_idle,cpu_kernel,disk_io,disk_available)
    values('2019-05-29 16:53:28',1,256,95,0,0,31220);