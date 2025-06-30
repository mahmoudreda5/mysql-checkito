USE checkito;

SHOW INDEXES FROM distro;

-- fool optimizer?, not really...
EXPLAIN SELECT * FROM distro WHERE a > 0;

-- selectivity is 1 / 10000, bad index
EXPLAIN SELECT * FROM distro WHERE b = 1;