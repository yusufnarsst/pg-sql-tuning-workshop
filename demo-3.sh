export PGPASSWORD=${PGPASSWORD};psql -eqt -h  ${DBHOST} -U ${DBUSER}  -d ${DBNAME} <<EOF

SET max_parallel_workers_per_gather = 0;

\echo '----------------------------------------------------------create schema'
create schema IF NOT EXISTS $1; 

drop table if exists demo3;

\echo '----------------------------------------------------------create table'
create table demo3 AS 
SELECT 
  * 
FROM 
  generate_series(1, 1000000) id, 
  generate_series(1, 1) status;

\echo '----------------------------------------------------------set status'

update demo3 set status=0 where id%2=0;

\echo '----------------------------------------------------------create index'

create index index_id on demo3(id);

\echo '----------------------------------------------------------analyze table'

vacuum analyze demo3;

\echo '----------------------------------------------------------query 1'

explain (analyze,buffers) 
SELECT 
  min(id), count(id), avg(id)
FROM 
  demo3 
WHERE id between 1 AND 1000;

 
\echo '----------------------------------------------------------query 2'

explain (analyze,buffers) 
SELECT 
  status, count(status)
FROM 
  demo3 
WHERE id between 1 AND 1000
group by status;
 

\echo '----------------------------------------------------------drop table'

drop table demo3;

EOF

