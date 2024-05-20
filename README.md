# pg-sql-tuning-workshop

PostgreSQL Tuning

* Altyapı
* PostgreSQL Konfigurasyonu
* SQL Tuning


## Altyapı
    * Disk, CPU, Memory, Network

## Memory alanları


    * shared_buffers
    * filesystem cache    
    * work_mem


![](https://distributedsystemsauthority.com/wp-content/uploads/2019/10/Slide3-1024x768.jpg)
![](https://severalnines.com/sites/default/files/blog/node_5287/image1.png)


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

#### Demo 2: work_mem ve temp kullanımı

#### Demo 3: index only scan vs index scan

#### Demo 4: index scan vs full-table-scan

#### Demo 5: hint kullanarak plan analizi

#### Demo 6: hint kullanarak plan analizi




