# SQL (Postgres) notları

## Genel komut listesi 

| Command |	Description | Example |
| ------- | ----------- | ------- |
| `\c $dbname` | Connect to database $dbname. |	`\c blog_development` |
| `\d` | Describe available relations	| |
| `\d $name ` |	Describe relation $name	| `\d users` |
| `\?` |	List of console commands and options	| |
| `\h` |	List of available SQL syntax Help topics	| |
| `\h $topic` |	SQL syntax Help on syntax for $topic |	`\h INSERT` |
| `\q` |	Quit	| |


## Sık lazım olabilecekler

- WSL start

`sudo service postgresql start`

- Connect to postgre

`sudo -u postgres psql` 

- Herhangi bir schema üzerindeki tabloları göstermek için

`\dt *.*`

- Yalnızca bir schema üzerindeki tabloları göstermek için

`\dt airline.*` yalnızca airline schema'sı üzerindeki tabloları gösterir

- Database değiştir/bağlan

`\c $db_name`

- Schema oluşturma

`CREATE SCHEMA $name`

- Schema silme 

`DROP SCHEMA $name`

- Kolon silme 

```
ALTER TABLE $table_name
DROP COLUMN $column_name
```

- Kolon adı değiştirme

```
ALTER TABLE table_name 
RENAME COLUMN column_name TO new_column_name;
``` 

- Kolon default değer belirleme

```
ALTER TABLE products ALTER COLUMN price SET DEFAULT 7.77;
```

- Tablo içeriğini silmek

`TRUNCATE TABLE table_name;`

- Auto increment karışılığı olarak veri tipi olarak `SERIAL` kullanılır.

```
CREATE TABLE books (
  id              SERIAL PRIMARY KEY, -- Örnek
  ...
);
```

- Bütün tabloları silmek

```
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
```

- TypeORM-model-gernarator kullanımı

```
typeorm-model-generator -h localhost -d postgres -p 5432 -u postgres -x secretPass -s public -e postgres
```