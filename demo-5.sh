export PGPASSWORD="demo";psql -eq -h  db-dev.buybase.com -U demo -d workshop <<EOF

SET max_parallel_workers_per_gather = 0;

create schema IF NOT EXISTS $1; 

drop table if exists tablo5;

create table tablo5 AS 
SELECT 
  * 
FROM 
  generate_series(1, 1000000) id, 
  generate_series(1, 1) status;

update tablo5 set status=0 where id%2=0;

create index index_status on tablo5(status);

vacuum analyze tablo5;

explain (analyze,buffers) 
/*+ IndexScan(tablo5 index_status) */
SELECT 
  count(id)
FROM 
  tablo5 
WHERE status=0;

explain (analyze,buffers) 
/*+ SeqScan(tablo5) */
SELECT 
  count(id)
FROM 
  tablo5 
WHERE status=1;

select status, count(*) from tablo5 group by status;


drop table if exists tablo5;

EOF

# 

#/*+
#     SeqScan(t1)
#     IndexScan(t2 t2_pkey)
#    */