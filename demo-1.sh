export PGPASSWORD="demo";psql -eq -h  db-dev.buybase.com -U demo -d workshop <<EOF

SET max_parallel_workers_per_gather = 0;

create schema IF NOT EXISTS $1; 

create table demo1 AS 
SELECT 
  * 
FROM 
  generate_series(1, 1000000) id, 
  generate_series(1, 1) status;

vacuum analyze demo1;
       
explain (analyze,buffers) 
SELECT 
  * 
FROM 
  demo1 
WHERE 
  id BETWEEN 100000
  AND 100100;

explain (analyze,buffers) 
SELECT 
  * 
FROM 
  demo1 
WHERE 
  id BETWEEN 1 
  AND 100;

select status, count(*) from demo1 group by status;



drop 
  table demo1;

EOF

