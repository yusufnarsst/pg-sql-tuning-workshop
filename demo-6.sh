export PGPASSWORD="demo";psql -eq -h  db-dev.buybase.com -U demo -d workshop <<EOF

SET max_parallel_workers_per_gather = 0;

create schema IF NOT EXISTS $1; 

drop table if exists tablo5;
drop table if exists tablo6;

create table tablo5 AS 
SELECT 
  *
FROM 
  generate_series(1, 1000000) id, 
  generate_series(1, 1) status;

update tablo5 set status=0 where id%2=0;

create index index_status on tablo5(status);

vacuum analyze tablo5;


create table tablo6 as select * from tablo5 order by id;

create index index_status_tablo6 on tablo6(status);

vacuum analyze tablo6;

explain (analyze,buffers) 
/*+ IndexScan(tablo6 index_status_tablo6) */
SELECT 
  count(id)
FROM 
  tablo6 
WHERE status=0;

explain (analyze,buffers) 
/*+ SeqScan(tablo6) */
SELECT 
  count(id)
FROM 
  tablo6 
WHERE status=1;


explain (analyze,buffers) 
/*+  Set(random_page_cost 10.0)  */
SELECT 
  avg(id)
FROM 
  tablo6 
WHERE status=0;

select status, count(*) from tablo6 group by status;

drop table if exists tablo5;
drop table if exists tablo6;

EOF

# 

#/*+
#     SeqScan(t1)
#     IndexScan(t2 t2_pkey)
#    
#  Set(random_page_cost 4.0) */

# SELECT id, 
# substr(md5(random()::text), 0, 20) AS author, 
# (random() * 100)::integer AS likes, 
# md5(random()::text) AS content, 
# '2007-02-01'::timestamp + (id * '1 hour'::interval) AS posted 
# FROM 
#     generate_series(1,10000) AS id
# 