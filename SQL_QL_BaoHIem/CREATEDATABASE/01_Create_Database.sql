<<<<<<< HEAD
--Chạy 1 trong 2 lệnh dưới để tạo database QL_BaoHiem
-- Cách 1
CREATE DATABASE QL_BaoHiem;
USE QL_BaoHiem
-- Cách 2: Tùy chỉnh đường dẫn lưu file dữ liệu và log
CREATE DATABASE QL_BaoHiem
ON 
(
    NAME = 'QL_BaoHiem_data',
    FILENAME = 'C:\QL_BaoHiem_data.mdf',
    SIZE = 500KB,
    MAXSIZE = 15MB,
    FILEGROWTH = 500KB
)
LOG ON 
(
    NAME = 'QL_BaoHiem_log',
    FILENAME = 'C:\QL_BaoHiem_log.ldf',
    SIZE = 500KB,
    MAXSIZE = 7MB,
    FILEGROWTH = 500KB
=======
--Chạy 1 trong 2 lệnh dưới để tạo database QL_BaoHiem
-- Cách 1
CREATE DATABASE QL_BaoHiem;

-- Cách 2: Tùy chỉnh đường dẫn lưu file dữ liệu và log
CREATE DATABASE QL_BaoHiem
ON 
(
    NAME = 'QL_BaoHiem_data',
    FILENAME = 'C:\QL_BaoHiem_data.mdf',
    SIZE = 500KB,
    MAXSIZE = 15MB,
    FILEGROWTH = 500KB
)
LOG ON 
(
    NAME = 'QL_BaoHiem_log',
    FILENAME = 'C:\QL_BaoHiem_log.ldf',
    SIZE = 500KB,
    MAXSIZE = 7MB,
    FILEGROWTH = 500KB
>>>>>>> 59c5acf48653319ce8c913c2014f62e09ddfb835
);