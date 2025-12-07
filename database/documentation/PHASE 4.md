# 🛣️ Smart Toll and Traffic Monitoring System – Phase IV
**Student:** Mutinda Collins Mumo  
**ID:** 27842  
**PDB Name:** WED_27842_Collins_smarttoll_db  
**Course:** PL/SQL  
**Institution:** Adventist University of Central Africa (AUCA)

---

## 📌 Project Overview
The Smart Toll and Traffic Monitoring System improves highway toll operations by:  

- Automating vehicle data entry  
- Reducing human error  
- Enforcing fine payments  
- Generating real-time reports  
- Supporting future IoT integrations (RFID, radar cameras)

---

## 🎯 Objectives
This phase focuses on the **setup of an Oracle Pluggable Database (PDB)**, including tablespaces, users, and SQL scripts.

### ✔️ 1. PDB Creation
A new pluggable database:  
**`WED_27842_Collins_smarttoll_db`**  

**Files created at:**  
C:/USERS/HELLO/DOWNLOADS/ORADATA/ORCL/PDBSEED/
C:/USERS/HELLO/DOWNLOADS/ORADATA/ORCL/WED_27842_Collins_smarttoll_db/


---

### ✔️ 2. Tablespaces
| Tablespace | Purpose | File |
|-----------|---------|------|
| `toll_data` | Main data storage | toll_data01.dbf |
| `toll_index` | Index storage | toll_index01.dbf |
| `toll_temp` | Temporary operations | toll_temp01.dbf |

---

### ✔️ 3. Users Created
| User | Purpose | Tablespace |
|------|---------|------------|
| `toll_admin` | Database admin | toll_data |
| `toll_owner` | Schema owner for project tables | toll_data |

---

## 💻 SQL Scripts

### **01_create_pdb.sql**
```sql
-- Create and open the PDB
CREATE PLUGGABLE DATABASE WED_27842_Collins_smarttoll_db
ADMIN USER admin IDENTIFIED BY Collins
FILE_NAME_CONVERT = (
 'C:/USERS/HELLO/DOWNLOADS/ORADATA/ORCL/PDBSEED/',
 'C:/USERS/HELLO/DOWNLOADS/ORADATA/ORCL/WED_27842_Collins_smarttoll_db/'
);

ALTER PLUGGABLE DATABASE WED_27842_Collins_smarttoll_db OPEN READ WRITE;
ALTER PLUGGABLE DATABASE WED_27842_Collins_smarttoll_db SAVE STATE;

ALTER SESSION SET CONTAINER = WED_27842_Collins_smarttoll_db;

-- Main data tablespace
CREATE TABLESPACE toll_data
DATAFILE 'C:/USERS/HELLO/DOWNLOADS/ORADATA/ORCL/WED_27842_Collins_smarttoll_db/toll_data01.dbf'
SIZE 300M AUTOEXTEND ON NEXT 50M MAXSIZE UNLIMITED;

-- Index tablespace
CREATE TABLESPACE toll_index
DATAFILE 'C:/USERS/HELLO/DOWNLOADS/ORADATA/ORCL/WED_27842_Collins_smarttoll_db/toll_index01.dbf'
SIZE 150M AUTOEXTEND ON NEXT 30M MAXSIZE UNLIMITED;

-- Temporary tablespace
CREATE TEMPORARY TABLESPACE toll_temp
TEMPFILE 'C:/USERS/HELLO/DOWNLOADS/ORADATA/ORCL/WED_27842_Collins_smarttoll_db/toll_temp01.dbf'
SIZE 100M AUTOEXTEND ON NEXT 20M MAXSIZE UNLIMITED;

ALTER SESSION SET CONTAINER = WED_27842_Collins_smarttoll_db;

-- Create admin user
CREATE USER toll_admin IDENTIFIED BY collins
DEFAULT TABLESPACE toll_data
TEMPORARY TABLESPACE toll_temp
QUOTA UNLIMITED ON toll_data;

GRANT CONNECT, RESOURCE, DBA TO toll_admin;

-- Create schema owner
CREATE USER toll_owner IDENTIFIED BY collins
DEFAULT TABLESPACE toll_data
TEMPORARY TABLESPACE toll_temp
QUOTA UNLIMITED ON toll_data;

GRANT CONNECT, RESOURCE, CREATE TABLE, CREATE VIEW,
      CREATE SEQUENCE, CREATE PROCEDURE, CREATE TRIGGER TO toll_owner;

-- Verify PDB status
SELECT NAME, OPEN_MODE 
FROM V$PDBS
WHERE NAME = 'WED_27842_COLLINS_SMARTTOLL_DB';

-- Verify tablespaces
SELECT TABLESPACE_NAME, STATUS, CONTENTS
FROM DBA_TABLESPACES
WHERE TABLESPACE_NAME IN ('TOLL_DATA','TOLL_INDEX','TOLL_TEMP');

-- Verify users
SELECT USERNAME, ACCOUNT_STATUS, DEFAULT_TABLESPACE
FROM DBA_USERS
WHERE USERNAME IN ('TOLL_ADMIN','TOLL_OWNER');

-- Verify data files
SELECT FILE_NAME, TABLESPACE_NAME, BYTES/1024/1024 AS MB, AUTOEXTENSIBLE
FROM DBA_DATA_FILES
WHERE TABLESPACE_NAME IN ('TOLL_DATA','TOLL_INDEX');
