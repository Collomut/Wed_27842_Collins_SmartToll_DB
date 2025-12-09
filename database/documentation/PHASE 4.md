# 🛣️ Smart Toll & Traffic Monitoring System  
**Project Owner:** Mutinda Collins Mumo  
**ID Number:** 27842  
**Institution:** AUCA (Adventist University of Central Africa)  
**PDB Name:** WED_27842_Collins_smarttoll_db  
**Course:** PL/SQL  

---

## Phase IV: Database Setup & Configuration  

### 📌 Overview
This phase establishes the physical database infrastructure required to host the Smart Toll System. It involves creating an isolated **Oracle 19c Pluggable Database (PDB)** to ensure portability and security, along with dedicated storage structures (Tablespaces) and user roles.

---

### 🎯 Objectives
1.  **Isolation:** Create a dedicated PDB (`WED_27842_Collins_smarttoll_db`) to separate project data from the root container.
2.  **Storage Management:** Define specific tablespaces for Data, Indexes, and Temporary operations to optimize performance.
3.  **Security:** Create distinct users for Administration (`toll_admin`) and Schema Ownership (`toll_owner`) to enforce the principle of least privilege.

---

### ✔️ 1. PDB Configuration
* **PDB Name:** `WED_27842_Collins_smarttoll_db`
* **Admin User:** `admin`
* **File Location:** `C:/USERS/HELLO/DOWNLOADS/ORADATA/ORCL/WED_27842_Collins_smarttoll_db/`

### ✔️ 2. Tablespace Architecture
| Tablespace | File Name | Initial Size | Purpose |
| :--- | :--- | :--- | :--- |
| **`toll_data`** | `toll_data01.dbf` | 300 MB | Stores core business tables (Vehicles, Logs, etc.) |
| **`toll_index`** | `toll_index01.dbf` | 150 MB | Stores B-Tree indexes for fast search |
| **`toll_temp`** | `toll_temp01.dbf` | 100 MB | Handles sorting and complex join operations |

### ✔️ 3. User Roles & Privileges
| User | Role | Default Tablespace | Privileges |
| :--- | :--- | :--- | :--- |
| **`toll_admin`** | Database Administrator | `toll_data` | `DBA`, `CONNECT`, `RESOURCE` |
| **`toll_owner`** | Application Owner | `toll_data` | `CREATE TABLE`, `CREATE VIEW`, `CREATE PROCEDURE`, `CREATE TRIGGER` |

---

## 💻 SQL Implementation Scripts

### **01_create_pdb.sql**
*Script to initialize the database environment.*

```sql
-- 1. Create the Pluggable Database
CREATE PLUGGABLE DATABASE WED_27842_Collins_smarttoll_db
ADMIN USER admin IDENTIFIED BY Collins
FILE_NAME_CONVERT = (
  'C:/USERS/HELLO/DOWNLOADS/ORADATA/ORCL/PDBSEED/',
  'C:/USERS/HELLO/DOWNLOADS/ORADATA/ORCL/WED_27842_Collins_smarttoll_db/'
);

-- 2. Open and Save State
ALTER PLUGGABLE DATABASE WED_27842_Collins_smarttoll_db OPEN READ WRITE;
ALTER PLUGGABLE DATABASE WED_27842_Collins_smarttoll_db SAVE STATE;

-- 3. Switch Container
ALTER SESSION SET CONTAINER = WED_27842_Collins_smarttoll_db;

-- 4. Create Tablespaces
-- Main Data Storage
CREATE TABLESPACE toll_data
DATAFILE 'C:/USERS/HELLO/DOWNLOADS/ORADATA/ORCL/WED_27842_Collins_smarttoll_db/toll_data01.dbf'
SIZE 300M AUTOEXTEND ON NEXT 50M MAXSIZE UNLIMITED;

-- Index Storage
CREATE TABLESPACE toll_index
DATAFILE 'C:/USERS/HELLO/DOWNLOADS/ORADATA/ORCL/WED_27842_Collins_smarttoll_db/toll_index01.dbf'
SIZE 150M AUTOEXTEND ON NEXT 30M MAXSIZE UNLIMITED;

-- Temporary Storage
CREATE TEMPORARY TABLESPACE toll_temp
TEMPFILE 'C:/USERS/HELLO/DOWNLOADS/ORADATA/ORCL/WED_27842_Collins_smarttoll_db/toll_temp01.dbf'
SIZE 100M AUTOEXTEND ON NEXT 20M MAXSIZE UNLIMITED;

-- 5. Create Users
-- Admin User
CREATE USER toll_admin IDENTIFIED BY collins
DEFAULT TABLESPACE toll_data
TEMPORARY TABLESPACE toll_temp
QUOTA UNLIMITED ON toll_data;

GRANT CONNECT, RESOURCE, DBA TO toll_admin;

-- Schema Owner
CREATE USER toll_owner IDENTIFIED BY collins
DEFAULT TABLESPACE toll_data
TEMPORARY TABLESPACE toll_temp
QUOTA UNLIMITED ON toll_data;

GRANT CONNECT, RESOURCE, CREATE TABLE, CREATE VIEW, 
      CREATE SEQUENCE, CREATE PROCEDURE, CREATE TRIGGER TO toll_owner;