USE checkito;

SHOW INDEXES FROM composite;


-- x = 123456, y = 'A'
SELECT * FROM composite WHERE x = 123456 AND y = 'A';
EXPLAIN SELECT * FROM composite WHERE x = 123456 AND y = 'A';

-- x = 654321, y >= 'B'
SELECT * FROM composite WHERE x = 654321 AND y >= 'B';
EXPLAIN SELECT * FROM composite WHERE x = 654321 AND y >= 'B';

-- x = 111111, y = 'C'
SELECT * FROM composite WHERE x > 111111 AND y = 'C';
EXPLAIN SELECT * FROM composite WHERE x > 111111 AND y = 'C';


ALTER TABLE composite ALTER INDEX idx_y_x VISIBLE;

-- try same query with y, x index
SELECT * FROM composite WHERE x > 111111 AND y = 'C';
EXPLAIN SELECT * FROM composite WHERE x > 111111 AND y = 'C';

ALTER TABLE composite ALTER INDEX idx_y_x INVISIBLE;


-- x > 333333, y < 'E'
SELECT * FROM composite WHERE x > 333333 AND y < 'E';
EXPLAIN SELECT * FROM composite WHERE x > 333333 AND y < 'E';

-- x = 123456
SELECT * FROM composite WHERE x = 123456;
EXPLAIN SELECT * FROM composite WHERE x = 123456;

-- y = 'M'
SELECT * FROM composite WHERE y = 'M';
EXPLAIN SELECT * FROM composite WHERE y = 'M';