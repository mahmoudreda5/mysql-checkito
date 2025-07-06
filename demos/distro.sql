USE checkito;

-- show table size and data
SELECT COUNT(*) FROM distro;
SELECT * FROM distro LIMIT 20;


-- show table indexes
SHOW INDEXES FROM distro;

-- 'a' column selectivity
SELECT COUNT(DISTINCT a) / COUNT(*) FROM distro;


-- choose a threshold for the 'a' column
SET @threshold = (SELECT MIN(a) FROM (SELECT a FROM distro ORDER BY a DESC LIMIT 20000) AS t);
SELECT @threshold;


-- fool optimizer?, not really...
EXPLAIN SELECT * FROM distro WHERE a > @threshold;
EXPLAIN ANALYZE SELECT * FROM distro WHERE a > @threshold;
EXPLAIN ANALYZE SELECT * FROM distro force index (idx_a) WHERE a > @threshold;


-- 'b' column selectivity
SELECT COUNT(DISTINCT b) / COUNT(*) FROM distro;

-- wrong optimizer decision, use terminal to see the difference
EXPLAIN SELECT * FROM distro WHERE b = 1;
EXPLAIN ANALYZE SELECT * FROM distro WHERE b = 1;

EXPLAIN SELECT * FROM distro ignore index (idx_b) WHERE b = 1;
EXPLAIN ANALYZE SELECT * FROM distro ignore index (idx_b) WHERE b = 1;

EXPLAIN SELECT * FROM distro WHERE b = 0;
EXPLAIN ANALYZE SELECT * FROM distro WHERE b = 0;
SELECT * FROM distro WHERE b = 0;