USE checkito;


-- show table size and data
SELECT COUNT(*) FROM users;
SELECT * FROM users LIMIT 20;

SELECT COUNT(*) FROM employees;
SELECT * FROM employees LIMIT 20;

SELECT COUNT(*) FROM accounts;
SELECT * FROM accounts LIMIT 20;


-- show table indexes
SHOW INDEXES FROM users;
SHOW INDEXES FROM accounts;


-- join wth no indexes, not really there is still an index (pk)
SELECT * FROM users INNER JOIN accounts ON users.id = accounts.user_id;
EXPLAIN SELECT * FROM users INNER JOIN accounts ON users.id = accounts.user_id;
EXPLAIN FORMAT=JSON SELECT * FROM users INNER JOIN accounts ON users.id = accounts.user_id;


-- join with really no indexes
-- explain and explain json showing full nested loop join but explain tree showing hash join
EXPLAIN SELECT * FROM users INNER JOIN employees ON users.age = employees.age;
EXPLAIN FORMAT=JSON SELECT * FROM users INNER JOIN employees ON users.age = employees.age;

EXPLAIN FORMAT=TREE SELECT * FROM users INNER JOIN employees ON users.age = employees.age;



-- age has no relation with account balance but for demonstration purposes because users, accounts are large but still hash join is used
EXPLAIN SELECT * FROM users INNER JOIN accounts ON users.age = accounts.balance;
EXPLAIN FORMAT=JSON SELECT * FROM users INNER JOIN accounts ON users.age = accounts.balance;
EXPLAIN FORMAT=TREE SELECT * FROM users INNER JOIN accounts ON users.age = accounts.balance;


-- activate one index
ALTER TABLE users ALTER INDEX idx_age VISIBLE;
EXPLAIN SELECT * FROM users INNER JOIN employees ON users.age = employees.age;
EXPLAIN FORMAT=JSON SELECT * FROM users INNER JOIN employees ON users.age = employees.age;
ALTER TABLE users ALTER INDEX idx_age INVISIBLE;


-- activate the other index
ALTER TABLE employees ALTER INDEX idx_age VISIBLE;
EXPLAIN SELECT * FROM users INNER JOIN employees ON users.age = employees.age;
EXPLAIN FORMAT=JSON SELECT * FROM users INNER JOIN employees ON users.age = employees.age;
ALTER TABLE employees ALTER INDEX idx_age INVISIBLE;


-- activate both indexes
ALTER TABLE users ALTER INDEX idx_age VISIBLE;
ALTER TABLE employees ALTER INDEX idx_age VISIBLE;
EXPLAIN SELECT * FROM users INNER JOIN employees ON users.age = employees.age;
EXPLAIN FORMAT=JSON SELECT * FROM users INNER JOIN employees ON users.age = employees.age;
EXPLAIN FORMAT=TREE SELECT * FROM users INNER JOIN employees ON users.age = employees.age;
EXPLAIN ANALYZE SELECT * FROM users INNER JOIN employees ON users.age = employees.age;
ALTER TABLE users ALTER INDEX idx_age INVISIBLE;
ALTER TABLE employees ALTER INDEX idx_age INVISIBLE;