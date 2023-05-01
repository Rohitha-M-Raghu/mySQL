/*
 * PROPERTIES OF TRANSACTION - ACID
 * 1. Atomicity
 * 2. Consistency
 * 3. Isolation
 * 4. Durability
 * 
 * Atomicity: This property ensures that all statements or operations within the transaction unit must be executed successfully.
 * Otherwise, if any operation is failed, the whole transaction will be aborted, and it goes rolled back into their previous state.
 * 	-> COMMIT statement.
 *  -> ROLL BACK statement.
 *  -> Auto-commit setting.
 *  -> Operational data from the INFORMATION_SCHEMA tables.
 * 
 * Consistency: This property ensures that the database changes state only when a transaction will be committed successfully.
 * It is also responsible for protecting data from crashes. Features :
 *  -> InnoDB doublewrite buffer
 *  -> InnoDB crash recovery
 * 
 * Isolation: This property guarantees that each operation in the transaction unit operated independently.
 * It also ensures that statements are transparent to each other. Features :
 *  -> SET ISOLATION LEVEL statement
 *  -> Auto-commit setting
 *  -> The low-level details of InnoDB locking
 * 
 * Durability: This property guarantees that the result of committed transactions persists permanently even if the system crashes 
 * or failed. Features :
 *  -> Write buffer in a storage device
 *  -> Battery-backed cache in a storage device
 *  -> Configuration option innodb_file_per_table
 *  -> Configuration option innodb_flush_log_at_trx_commit
 *  -> Configuration option sync_binlog
 * 
 * MySQL Transaction Statements
 * ----------------------------
 *  -> START TRANSACTION
 *  -> COMMIT
 *  -> ROLLBACK
 *  -> SET autocommit
 * 
 *     SET autocommit = 0;  
 *   OR,  
 *   SET autocommit = OFF;
 * 
 * We are using 2 tables to understand transactions - Employees and Orders
 */

CREATE DATABASE Day8;

USE Day8;

CREATE TABLE Employees
(
	emp_id 		int PRIMARY KEY,
	emp_name 	varchar(255) NOT NULL,
	emp_age 	int,
	city 		varchar(255),
	income 		float
);

INSERT INTO Employees 
VALUES (101, 'Peter', 32, 'NewYork', 200000),
		(102, 'Mark', 32, 'California', 300000),
		(103, 'Donald', 40, 'Arizona', 1000000),
		(104, 'Obama', 35, 'Florida', 5000000),
		(105, 'Linklon', 32, 'Georgia', 250000),
		(106, 'Kane', 45, 'Alaska', 450000),
		(107, 'Adam', 35, 'California', 5000000),
		(108, 'Macculam', 40, 'Florida', 350000),
		(109, 'Brayan', 32, 'Alaska', 400000),
		(110, 'Stephen', 40, 'Arizona', 600000)
;

CREATE TABLE Orders 
(
	Order_id int PRIMARY KEY AUTO_INCREMENT,
	Product_name varchar(255),
	Order_Num int UNIQUE KEY NOT NULL,
	Order_Date date 
);
INSERT INTO Orders 
	(Product_name,
	 Order_Num,
	 Order_Date
	 )
VALUES  ('Laptop', 5544, '2020-02-01'),
		('Mouse', 3322, '2020-02-11'),
		('Desktop', 2135, '2020-02-11'),
		('Mobile', 3432, '2020-02-22'),
		('Anti-virus', 5648, '2020-03-10')
;

SELECT * FROM Employees e ;

SELECT * FROM Orders o ;

# COMMIT EXAMPLE
START TRANSACTION;

USE Day8;

SELECT MAX(income) AS max_income
FROM Employees;

INSERT INTO 
	Employees 
VALUES 
	(111, 'Alexander', 45, 'California', 700000);

INSERT INTO Orders (
	Product_name,
	 Order_Num,
	 Order_Date
	) 
VALUES 
	('Printer', 5654, '2020-01-10');

COMMIT;

START TRANSACTION;

DELETE FROM Orders ;

SELECT * FROM Orders o ;

ROLLBACk;

/*
 *     SAVEPOINT savepoint_name  
 *     ROLLBACK TO [SAVEPOINT] savepoint_name  
 *     RELEASE SAVEPOINT savepoint_name  
 *
 */

# Example of Savepoint

START TRANSACTION;

SELECT * FROM Orders o ;

COMMIT;

DELETE FROM Orders WHERE Order_id = 6;

COMMIT;

SELECT * FROM Orders o ;

START TRANSACTION;

SELECT * FROM Orders o ;

INSERT INTO Orders (
	Product_name,
	 Order_Num,
	 Order_Date
	) 
VALUES 
	('Printer', 5654, '2020-01-10');

SAVEPOINT my_savepoint;

INSERT INTO Orders (
	Product_name,
	 Order_Num,
	 Order_Date
	) 
VALUES 
	('Ink', 5894, '2020-03-10');

ROLLBACK TO SAVEPOINT my_savepoint;

INSERT INTO Orders (
	Product_name,
	 Order_Num,
	 Order_Date
	) 
VALUES 
	('Speaker', 6065, '2020-02-18');

COMMIT;

SELECT * FROM Orders o ;

DELETE FROM Orders WHERE Order_id = 7 OR Order_id = 9;

# Example of release savepoint

START TRANSACTION;

INSERT INTO Orders (
	Product_name,
	 Order_Num,
	 Order_Date
	) 
VALUES 
	('Ink', 5894, '2020-03-10');

SAVEPOINT my_savepoint;

SELECT * FROM Orders o ;

UPDATE Orders SET Product_name = 'Scanner' WHERE Order_id = 4;

RELEASE SAVEPOINT my_savepoint;

COMMIT;

SELECT * FROM Orders o ;

SET AUTOCOMMIT = 1;

