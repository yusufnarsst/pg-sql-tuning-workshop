export PGPASSWORD=${PGPASSWORD};psql -eqt -h  ${DBHOST} -U ${DBUSER}  -d ${DBNAME} <<EOF

SET max_parallel_workers_per_gather = 0;

\echo '----------------------------------------------------------create schema'
create schema IF NOT EXISTS $1; 

\echo '----------------------------------------------------------create table'
create table demo1 AS 
SELECT 
  * 
FROM 
  generate_series(1, 1000000) id, 
  generate_series(1, 1) status;

\echo '----------------------------------------------------------vacuum'
vacuum analyze demo1;
    
\echo '----------------------------------------------------------query 1'
explain (analyze,buffers) 
SELECT 
  * 
FROM 
  demo1 
WHERE 
  id BETWEEN 100000
  AND 100100;

\echo '----------------------------------------------------------query 2'
explain (analyze,buffers) 
SELECT 
  * 
FROM 
  demo1 
WHERE 
  id BETWEEN 1 
  AND 100;


select status, count(*) from demo1 group by status;


\echo '----------------------------------------------------------drop table'
drop 
  table demo1;

EOF

