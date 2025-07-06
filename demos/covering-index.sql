USE checkito;


-- show table size and data
SELECT COUNT(*) FROM composite;
SELECT * FROM composite LIMIT 20;


-- show table indexes
SHOW INDEXES FROM composite;


-- does covering index broke the leftmost prefix rule? not really, why?
EXPLAIN SELECT x, y FROM composite WHERE y = 'M';

EXPLAIN SELECT id, x, y FROM composite WHERE x > 111111 AND y = 'C';
EXPLAIN ANALYZE SELECT id, x, y FROM composite WHERE x > 111111 AND y = 'C';
EXPLAIN SELECT id, x, y FROM composite WHERE x > 333333 AND y < 'E';
EXPLAIN ANALYZE SELECT id, x, y FROM composite WHERE x > 333333 AND y < 'E';


ALTER TABLE composite ALTER INDEX idx_x_y_z VISIBLE;
EXPLAIN SELECT * FROM composite WHERE x > 111111 AND y = 'C';
EXPLAIN ANALYZE SELECT * FROM composite WHERE x > 111111 AND y = 'C';
EXPLAIN SELECT * FROM composite WHERE x > 333333 AND y < 'E';
EXPLAIN ANALYZE SELECT * FROM composite WHERE x > 333333 AND y < 'E';
ALTER TABLE composite ALTER INDEX idx_x_y_z INVISIBLE;