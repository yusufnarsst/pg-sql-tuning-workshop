export PGPASSWORD="demo";psql  -eq -h  db-dev.buybase.com -U demo -d workshop <<EOF

SET max_parallel_workers_per_gather = 0;

create schema IF NOT EXISTS $1; 

drop table if exists paging_table;

create table paging_table AS 
SELECT 
  * 
FROM 
  generate_series(1, 10000000) id, 
  generate_series(1, 1) status;

update paging_table set status=0 where id%2=0;

create index index_id on paging_table(id);

vacuum analyze paging_table;

explain (analyze,buffers) 
SELECT 
  count(id)
FROM 
  paging_table 
WHERE id between 1 AND 100
group by id
order by id%5;

explain (analyze,buffers) 
SELECT 
  count(id)
FROM 
  paging_table 
WHERE id between 1 AND 1000
group by id
order by id%5;

explain (analyze,buffers) 
SELECT 
  count(id)
FROM 
  paging_table 
WHERE id between 1 AND 10000
group by id
order by id%5;


explain (analyze,buffers) 
SELECT 
  count(id)
FROM 
  paging_table 
WHERE id between 1 AND 60000
group by id
order by id%5;


explain (analyze,buffers) 
SELECT 
  count(id)
FROM 
  paging_table 
WHERE id between 1 AND 70000
group by id
order by id%5;



explain (analyze,buffers) 
SELECT 
  count(id)
FROM 
  paging_table 
WHERE id between 1 AND 1000000
group by id
order by id%5;

select status, count(*) from paging_table group by status;

drop table paging_table;

EOF

