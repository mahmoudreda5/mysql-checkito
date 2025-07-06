USE checkito;


-- show table size and data
SELECT COUNT(*) FROM composite;
SELECT * FROM composite LIMIT 20;


-- show table indexes
SHOW INDEXES FROM composite;


ALTER TABLE composite ALTER INDEX idx_x_y_z VISIBLE;

-- no file sort
EXPLAIN SELECT * FROM composite WHERE x = 123456 ORDER BY y;
EXPLAIN SELECT * FROM composite WHERE x = 654321 ORDER BY y, z;
EXPLAIN SELECT * FROM composite WHERE x = 123456 AND y = 'A' ORDER BY z;
EXPLAIN SELECT * FROM composite WHERE x = 123456 AND y = 'A' AND z >= 'a7a7a7a7' ORDER BY y, z;


-- file sort
EXPLAIN SELECT * FROM composite WHERE x = 654321 ORDER BY y DESC, z ASC;
EXPLAIN SELECT * FROM composite WHERE x >= 123456 ORDER BY y;
EXPLAIN SELECT * FROM composite WHERE x = 123456 ORDER BY z;
EXPLAIN SELECT * FROM composite WHERE x = 123456 AND y >= 'A' ORDER BY z;
ALTER TABLE composite ALTER INDEX idx_x_y_z INVISIBLE;


-- pipelined order by
ALTER TABLE composite ALTER INDEX idx_y_x VISIBLE;
EXPLAIN ANALYZE SELECT * FROM composite WHERE y = 'A' ORDER BY x LIMIT 20;
SELECT COUNT(*) FROM composite WHERE y >= 'M' ORDER BY x;
EXPLAIN ANALYZE SELECT * FROM composite FORCE INDEX (idx_y_x) WHERE y >= 'M' ORDER BY x LIMIT 20;
ALTER TABLE composite ALTER INDEX idx_y_x VISIBLE;
