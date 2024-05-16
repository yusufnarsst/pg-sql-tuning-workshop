export PGPASSWORD="demo";psql  -eq -h  db-dev.buybase.com -U demo -d workshop <<EOF

SET max_parallel_workers_per_gather = 0;

create schema IF NOT EXISTS $1; 

drop table if exists tablo1;

create table tablo1 AS 
SELECT 
  * 
FROM 
  generate_series(1, 1000000) id, 
  generate_series(1, 1) status;

update tablo1 set status=0 where id%2=0;

create index index_id on tablo1(id);

vacuum analyze tablo1;

explain (analyze,buffers) 
SELECT 
  min(id), count(id), avg(id)
FROM 
  tablo1 
WHERE id between 1 AND 1000;

 

explain (analyze,buffers) 
SELECT 
  status, count(status)
FROM 
  tablo1 
WHERE id between 1 AND 1000
group by status;
 
 
select status, count(*) from tablo1 group by status;

drop table tablo1;

EOF

