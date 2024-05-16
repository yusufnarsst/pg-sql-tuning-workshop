export PGPASSWORD="demo";psql -eq -h  db-dev.buybase.com -U demo -d workshop <<EOF

SET max_parallel_workers_per_gather = 0;

create schema IF NOT EXISTS $1; 

create table tablo3 AS 
SELECT 
  * 
FROM 
  generate_series(1, 1000000) id, 
  generate_series(1, 1) status;

update tablo3 set status=0 where id < 1000;

create index index_status on tablo3(status);

vacuum analyze tablo3;

select status, count(*) from tablo3 group by status;

explain (analyze,buffers) 
SELECT 
  count(id)
FROM 
  tablo3 
WHERE status=0;

explain (analyze,buffers) 
SELECT 
  count(id)
FROM 
  tablo3 
WHERE status=1;

explain (analyze,buffers) 
/*+ IndexScan(tablo3 index_status) */
SELECT 
  count(id)
FROM 
  tablo3 
WHERE status=1;

 
drop table tablo3;

EOF

