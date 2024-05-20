export PGPASSWORD=${PGPASSWORD};psql -eqt -h  ${DBHOST} -U ${DBUSER}  -d ${DBNAME} <<EOF

SET max_parallel_workers_per_gather = 0;

\echo '----------------------------------------------------------SET work_mem (default:4M)'
SET work_mem TO '4MB';

\echo '----------------------------------------------------------create schema'
create schema IF NOT EXISTS $1; 

drop table if exists demo2;

\echo '----------------------------------------------------------create table'
create table demo2 AS 
SELECT 
  * 
FROM 
  generate_series(1, 10000000) id, 
  generate_series(1, 1) status;


\echo '----------------------------------------------------------set status'
update demo2 set status=0 where id%2=0;


\echo '----------------------------------------------------------create index'
create index index_id on demo2(id);


\echo '----------------------------------------------------------vacuum'
vacuum analyze demo2;


\echo '----------------------------------------------------------query 1-100'
explain (analyze,buffers) 
SELECT 
  count(id)
FROM 
  demo2 
WHERE id between 1 AND 100
group by id
order by id%5;


\echo '----------------------------------------------------------query 1-1000'
explain (analyze,buffers) 
SELECT 
  count(id)
FROM 
  demo2 
WHERE id between 1 AND 1000
group by id
order by id%5;


\echo '----------------------------------------------------------query 1-10000'
explain (analyze,buffers) 
SELECT 
  count(id)
FROM 
  demo2 
WHERE id between 1 AND 10000
group by id
order by id%5;

\echo '----------------------------------------------------------query 1-60000'
explain (analyze,buffers) 
SELECT 
  count(id)
FROM 
  demo2 
WHERE id between 1 AND 60000
group by id
order by id%5;

\echo '----------------------------------------------------------query 1-70000'
explain (analyze,buffers) 
SELECT 
  count(id)
FROM 
  demo2 
WHERE id between 1 AND 70000
group by id
order by id%5;


\echo '----------------------------------------------------------query 1-1000000'
explain (analyze,buffers) 
SELECT 
  count(id)
FROM 
  demo2 
WHERE id between 1 AND 1000000
group by id
order by id%5;

select status, count(*) from demo2 group by status;

\echo '----------------------------------------------------------drop table'
drop table demo2;

EOF

