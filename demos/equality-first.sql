USE checkito;


-- show table size and data
SELECT COUNT(*) FROM composite;
SELECT * FROM composite LIMIT 20;


-- show table indexes
SHOW INDEXES FROM composite;


ALTER TABLE composite ALTER INDEX idx_x_y_z VISIBLE;

-- x, y and z
SELECT * FROM composite FORCE INDEX (idx_x_y_z) WHERE x = 654321 AND y = 'G' AND z = 'k1l2m3n4o5';
EXPLAIN FORMAT=JSON SELECT * FROM composite FORCE INDEX (idx_x_y_z) WHERE x = 654321 AND y = 'G' AND z = 'k1l2m3n4o5';

-- x, y only
SELECT * FROM composite FORCE INDEX (idx_x_y_z) WHERE x = 654321 AND y >= 'B' AND z = 'k1l2m3n4o5';
EXPLAIN FORMAT=JSON SELECT * FROM composite FORCE INDEX (idx_x_y_z) WHERE x = 654321 AND y >= 'B' AND z = 'k1l2m3n4o5';

SELECT * FROM composite FORCE INDEX (idx_x_y_z) WHERE x >= 654321 AND y = 'G' AND z = 'k1l2m3n4o5';
EXPLAIN FORMAT=JSON SELECT * FROM composite FORCE INDEX (idx_x_y_z) WHERE x >= 654321 AND y = 'G' AND z = 'k1l2m3n4o5';