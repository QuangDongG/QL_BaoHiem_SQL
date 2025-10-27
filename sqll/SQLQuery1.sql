<<<<<<< HEAD
CREATE DATABASE QL_BaoHiem
ON 
(
    NAME = 'QL_BaoHiem_data',
    FILENAME = 'C:\DataBH\QL_BaoHiem_data.mdf',
    SIZE = 500KB,
    MAXSIZE = 15MB,
    FILEGROWTH = 500KB
)
LOG ON 
(
    NAME = 'QL_BaoHiem_log',
    FILENAME = 'C:\DataBH\QL_BaoHiem_log.ldf',
    SIZE = 500KB,
    MAXSIZE = 7MB,
    FILEGROWTH = 500KB
=======
CREATE DATABASE QL_BaoHiem
ON 
(
    NAME = 'QL_BaoHiem_data',
    FILENAME = 'C:\DataBH\QL_BaoHiem_data.mdf',
    SIZE = 500KB,
    MAXSIZE = 15MB,
    FILEGROWTH = 500KB
)
LOG ON 
(
    NAME = 'QL_BaoHiem_log',
    FILENAME = 'C:\DataBH\QL_BaoHiem_log.ldf',
    SIZE = 500KB,
    MAXSIZE = 7MB,
    FILEGROWTH = 500KB
>>>>>>> 59c5acf48653319ce8c913c2014f62e09ddfb835
);