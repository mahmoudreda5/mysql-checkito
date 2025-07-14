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


-- join with no indexes, not really there is still an index (pk)
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


-- Hash join
EXPLAIN FORMAT=TREE SELECT /*+ HASH_JOIN(users employees) */ * FROM users 
INNER JOIN employees ON users.age = employees.age where users.name LIKE 'mah%' AND employees.age < 100000;


-- join order

ALTER TABLE users ALTER INDEX idx_age VISIBLE;
ALTER TABLE employees ALTER INDEX idx_age VISIBLE;

-- normally smaller table is the outer table
EXPLAIN format=tree SELECT * FROM users INNER JOIN employees ON users.age = employees.age WHERE users.age < 30;
EXPLAIN format=tree SELECT * FROM users INNER JOIN employees ON users.age = employees.age WHERE employees.age < 30;

-- join order changes based on filtering
ALTER TABLE accounts ALTER INDEX idx_user_id VISIBLE;
ALTER TABLE accounts ALTER INDEX idx_balance VISIBLE;
EXPLAIN SELECT * FROM users INNER JOIN accounts ON users.id = accounts.user_id WHERE accounts.balance < 1000;
EXPLAIN SELECT * FROM users INNER JOIN accounts ON users.id = accounts.user_id WHERE users.age < 20;
EXPLAIN SELECT * FROM users INNER JOIN accounts ON users.id = accounts.user_id WHERE users.age < 20 AND accounts.balance < 1000;


-- join order will change based on order by
EXPLAIN SELECT * FROM users
INNER JOIN accounts ON users.id = accounts.user_id
WHERE users.age < 20 AND accounts.balance < 10000 ORDER BY users.id;

EXPLAIN ANALYZE SELECT * FROM users
INNER JOIN accounts ON users.id = accounts.user_id
WHERE users.age < 20 AND accounts.balance < 10000 ORDER BY users.id;

-- again optimizer is not choosing the most optimal plan!
EXPLAIN ANALYZE SELECT * FROM users
STRAIGHT_JOIN accounts ON users.id = accounts.user_id
WHERE users.age < 20 AND accounts.balance < 10000 ORDER BY users.id;

-- pipelined order by
EXPLAIN SELECT * FROM users
INNER JOIN accounts ON users.id = accounts.user_id
WHERE users.age < 20 AND accounts.balance < 10000 ORDER BY users.id limit 20;
