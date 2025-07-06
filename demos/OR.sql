USE checkito;


-- show table size and data
SELECT COUNT(*) FROM composite;
SELECT * FROM composite LIMIT 20;


-- show table indexes
SHOW INDEXES FROM composite;


-- Or-ing is a different story
SELECT * FROM composite WHERE x = 123456 OR y = 'A';
EXPLAIN SELECT * FROM composite WHERE x = 123456 OR y = 'A';


-- classic work around
ALTER TABLE composite ALTER INDEX idx_y_x VISIBLE;
SELECT * FROM composite WHERE x = 123456 UNION SELECT * FROM composite WHERE y = 'A';
EXPLAIN SELECT * FROM composite WHERE x = 123456 UNION SELECT * FROM composite WHERE y = 'A';


-- index merge
EXPLAIN SELECT * FROM composite WHERE x = 123456 OR y = 'A';
ALTER TABLE composite ALTER INDEX idx_y_x INVISIBLE;