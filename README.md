# MySQL Checkito

MySQL query optimization 101 hands-on playground

## 🚀 Quick Start

Make sure you have [Docker](https://www.docker.com/products/docker-desktop) installed.

### 1. Clone the repo

```bash
git clone git@github.com:mahmoudreda5/mysql-checkito.git
cd mysql-checkito
```

### 2. Run MySQL

```bash
docker-compose up -d
```

then to see created tables you can run

```bash
docker exec -it mysql-checkito mysql -u root -proot checkito

mysql> SHOW TABLES;
```

### 3. Connect to MySQL

- Host: 127.0.0.1
- Port: 3307
- User: root
- Password: root
- Database: checkito

## 📁 Project Structure

```
.
├── docker-compose.yml
├── init/
│   └── scripts to initialize database tables with populated random data
├── exercises/
│   └── hands-on scripts
└── README.md
```

## 🧼 Cleanup

```bash
docker-compose down
```
