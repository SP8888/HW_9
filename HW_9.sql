-- В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

use sample;
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT users VALUES (NULL, 'Alex', '1990-10-02', "20.10.2017", "20.10.2017");
INSERT users VALUES (NULL, 'Anton', '1989-10-02', "20.10.2017", "20.10.2017");
INSERT users VALUES (NULL, 'Boris', '1987-10-02', "20.10.2017", "20.10.2017");
INSERT users VALUES (NULL, 'Olga', '1995-10-02', "20.10.2017", "20.10.2017");
INSERT users VALUES (NULL, 'Violeta', '1993-10-02', "20.10.2017", "20.10.2017");

show tables;
SELECT * from users;

START TRANSACTION;
use shop;
SELECT @n := name, @d := id, @b := birthday_at,@c := created_at,@u := updated_at 
FROM users WHERE id = 1;
DELETE FROM users WHERE id = 1;
use sample;
INSERT INTO users VALUES (@d,@n,@b,@c,@u);
COMMIT;

-- Создайте представление, которое выводит название name товарной позиции из 
-- таблицы products и соответствующее название каталога name из таблицы catalogs.

use shop;
SELECT * FROM products;
SELECT * FROM catalogs;

CREATE OR REPLACE VIEW name_prod_cat (name_catalog, name_praduct ) AS SELECT 
name,
(SELECT name FROM catalogs WHERE catalog_id = catalogs.id) 
FROM products;

SELECT * FROM name_prod_cat;

-- Пусть имеется таблица с календарным полем created_at. В ней размещены разряженые календарные 
-- записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. Составьте запрос,
-- который выводит полный список дат за август, выставляя
-- в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует.

use example;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT users VALUES (NULL, 'Alex', '1990-08-12');
INSERT users VALUES (NULL, 'Anton', '1989-08-02');
INSERT users VALUES (NULL, 'Boris', '1987-08-23');
INSERT users VALUES (NULL, 'Olga', '1995-08-05');
INSERT users VALUES (NULL, 'Violeta', '1993-08-06');

DROP TABLE IF EXISTS august;
CREATE TABLE august (
  id SERIAL PRIMARY KEY,
  day_august INT );

CALL D_A;

-- немного не доделал, но почти то же самое :)

CREATE OR REPLACE VIEW DAY_TABLE AS
SELECT DISTINCT day_august, 
NOT isNULL(users.name) as flag
FROM august
LEFT join
users
ON DATE_FORMAT(created_at, '%d ') = day_august
ORDER BY day_august;


SELECT * FROM day_table ;



