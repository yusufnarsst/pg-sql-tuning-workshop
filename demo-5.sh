export PGPASSWORD=${PGPASSWORD};psql -eqt -h  ${DBHOST} -U ${DBUSER}  -d ${DBNAME} <<EOF

SET max_parallel_workers_per_gather = 0;

\echo '----------------------------------------------------------create schema'

create schema IF NOT EXISTS $1; 


\echo '----------------------------------------------------------create table'

drop table if exists tablo5;


create table tablo5 AS 
SELECT 
  * 
FROM 
  generate_series(1, 1000000) id, 
  generate_series(1, 1) status;


\echo '----------------------------------------------------------set status'

update tablo5 set status=0 where id%2=0;


\echo '----------------------------------------------------------create index'

create index index_status on tablo5(status);

\echo '----------------------------------------------------------analyze'

vacuum analyze tablo5;

\echo '----------------------------------------------------------query 1'

explain (analyze,buffers) 
/*+ IndexScan(tablo5 index_status) */
SELECT 
  count(id)
FROM 
  tablo5 
WHERE status=0;


\echo '----------------------------------------------------------query 2'

explain (analyze,buffers) 
/*+ SeqScan(tablo5) */
SELECT 
  count(id)
FROM 
  tablo5 
WHERE status=1;

select status, count(*) from tablo5 group by status;

\echo '----------------------------------------------------------drop table'

drop table if exists tablo5;

EOF

# 

#/*+
#     SeqScan(t1)
#     IndexScan(t2 t2_pkey)
#    */