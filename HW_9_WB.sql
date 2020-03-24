-- Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости 
-- от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро",
-- с 12:00 до 18:00 функция должна
-- возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", 
-- с 00:00 до 6:00 — "Доброй ночи".
use example;
DELIMITER //

DROP FUNCTION IF EXISTS get_time//
CREATE FUNCTION get_time ()
RETURNS TEXT  NO SQL
BEGIN
 DECLARE f_t INT;
 SET f_t = HOUR(NOW());
	IF ( f_t BETWEEN 06 and 12) THEN
	RETURN 'Доброе утро';
    ELSEIF (f_t BETWEEN 13 and 18) THEN
	RETURN 'Добрый день';
	ELSEIF (f_t BETWEEN 19 and 23) THEN
	RETURN 'Добрый вечер';
    ELSEIF (f_t BETWEEN 0 and 5) THEN
	RETURN 'Доброй ночи';
  END IF;
END//

SELECT get_time()//

-- В таблице products есть два текстовых поля: name с названием товара и description с его описанием. Допустимо присутствие обоих полей или одно из них. Ситуация,
--  когда оба поля принимают неопределенное значение NULL
--  неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо 
-- отменить операцию.
use shop//
select * FROM products//
CREATE TRIGGER PROD_DESC BEFORE INSERT ON products
FOR EACH ROW
BEGIN
  IF NEW.name IS NULL AND NEW.description IS NULL THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ALLES CAPUT!!!';
  END IF;
END//

CREATE TRIGGER PROD_DESC_A BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
  IF NEW.name IS NULL AND NEW.description IS NULL THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ALLES CAPUT!!!';
  END IF;
END//
DROP TRIGGER PROD_DESC//

insert INTO products (name, description) VALUES ('hhhh', 'yyyy')//
insert INTO products (name, description) VALUES (NULL, NULL)//
