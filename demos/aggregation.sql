USE checkito;


-- show table size and data
SELECT COUNT(*) FROM composite;
SELECT * FROM composite LIMIT 20;


-- show table indexes
SHOW INDEXES FROM composite;

-- sort based aggregation
ALTER TABLE composite ALTER INDEX idx_x_y_z VISIBLE;
EXPLAIN SELECT COUNT(*) FROM composite WHERE x = 123456 GROUP BY y;
EXPLAIN ANALYZE SELECT COUNT(*) FROM composite WHERE x = 123456 GROUP BY y;
EXPLAIN SELECT COUNT(*) FROM composite WHERE x = 123456 GROUP BY y, z;

-- hash based aggregation
EXPLAIN SELECT COUNT(*) FROM composite WHERE x = 123456 GROUP BY z;
EXPLAIN ANALYZE SELECT COUNT(*) FROM composite WHERE x = 123456 GROUP BY z;
EXPLAIN SELECT COUNT(*) FROM composite WHERE x >= 123456 GROUP BY y;
ALTER TABLE composite ALTER INDEX idx_x_y_z INVISIBLE;

