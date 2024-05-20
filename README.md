# pg-sql-tuning-workshop

PostgreSQL Tuning

* Altyapı
* PostgreSQL Konfigurasyonu
* SQL Tuning


## Altyapı
    * Disk, CPU, Memory, Network

## Process architecture
![](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*ysek1HEB8TpoWVxSVXmOHw@2x.jpeg)

## Memory alanları

### shared_buffers ve file system cache

![](https://distributedsystemsauthority.com/wp-content/uploads/2019/10/Slide3-1024x768.jpg)

### work_mem

![](https://severalnines.com/sites/default/files/blog/node_5287/image1.png)

SET work_mem TO '16MB';


## SQL Tuning
    * Minimum execution süresi
    * Minimum shared hit

### EXPLAIN
    * İstatisk bazlı metricler
    * vacuum analyze 

### EXPLAIN ANALYZE
    * Gerçek metricler

#### DB parametreleri

export DBUSER=
export DBNAME=
export DBHOST=
export PGPASSWORD=

#### Demo 1: 1st access vs 2nd access, shared_hit vs disk read, sequential scan

#### Demo 2: work_mem ve temp kullanımı, index-only-scan

#### Demo 3: index only scan vs index scan

#### Demo 4: column selectivity, index scan vs full-table-scan

#### Demo 5: hint kullanarak plan analizi

#### Demo 6: random_page_cost etkisi




