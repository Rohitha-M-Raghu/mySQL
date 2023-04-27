/*
Day 6
 Set operations
	UNION
	UNION ALL
	INTERSECT
	EXCEPT
- SubQueries 
	Sub-queries with the SELECT Statement
	Sub-queries with the INSERT Statement
	Sub-queries with the DELETE Statement
	Sub-queries with the UPDATE Statement
	Nested Queries
*/

CREATE DATABASE Day6Database;

USE Day6DataBase;

CREATE TABLE Customers (
    CustomerID 		INT PRIMARY KEY,
    CustomerName 	VARCHAR(255) NOT NULL,
    ContactName 	VARCHAR(255),
    Country 		VARCHAR(255)
);

CREATE TABLE Suppliers (
    SupplierID 		INT PRIMARY KEY,
    SupplierName 	VARCHAR(255) NOT NULL,
    ContactName 	VARCHAR(255),
    Country 		VARCHAR(255)
);

-- INSERTING VALUES INTO TABLES

INSERT INTO 
	Customers
VALUES
	(1, 'Alfreds', 'Maria', 'Germany'),
	(2, 'Ana Trujillo', 'Ana', 'Mexico'),
	(3, 'Antonio', 'Antonio', 'Mexico'),
	(4, 'Around the Horn', 'Thomas', 'UK'),
	(5, 'Berglunds', 'Christina', 'Swedan'),
	(6, 'Blauer See', 'Hanna', 'Germany'),
	(7, 'Blondel père et fils', 'Frédérique', 'France' ),
	(8, 'Bólido Comidas preparadas', 'Martin', 'Spain'),
	(9, 'Bon app', 'Laurence', 'France'),
	(10, 'Bottom-Dollar Markets', 'Elizabeth', 'Canada')
;

INSERT INTO
	 Suppliers 
VALUES
	(1, 'Exotic Liquids', 'Charlotte', 'UK'),
	(2, 'New Orleans Cajun Delights', 'Shelley', 'USA'),
	(3, 'Grandma Kellys Homestead', 'Regina', 'USA'),
	(4, 'Tokyo Traders', 'Yoshi', 'Japan'),
	(5, 'Cooperativa de Quesos Las Cabras', 'Antonio', 'Spain'),
	(6, 'Mayumis', 'Mayumi', 'Japan'),
	(7, 'Pavlova, Ltd.', 'Ian', 'Australia'),
	(8, 'Specialty Biscuits, Ltd.', 'Peter', 'UK'),
	(9, 'PB Knäckebröd AB', 'Lars', 'Swedan'),
	(10, 'Refrescos Americanas LTDA', 'Carlos', 'Brazil')
;

-- Displaying the tables - Customers and Suppliers

SELECT * FROM Customers;
SELECT * FROM Suppliers;
-- Example for UNION
SELECT 
	CustomerName 
FROM 
	Customers
UNION
	SELECT 
		SupplierName 
	FROM 
		Suppliers;

-- Example of UNION ALL
SELECT 
	Country 
FROM 
	Customers
UNION ALL
	SELECT 
		Country 
	FROM 
		Suppliers;

-- Example of INTERSECTION
SELECT 
	Country 
FROM 
	Customers
INTERSECT
	SELECT 
		Country 
	FROM 
		Suppliers;
	
-- Example of EXCEPT
SELECT 
	Country 
FROM 
	Customers
EXCEPT
	SELECT 
		Country 
	FROM 
		Suppliers;

-- Creating a new table
CREATE TABLE Orders
(
	OrderID 	INT PRIMARY KEY,
	CustomerID 	INT,
	OrderDate 	DATE,
	FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);

INSERT INTO
	Orders
VALUES
	(1, 3, '2022-01-01'),
	(2, 4, '2022-01-02'),
	(3, 2, '2022-01-03'),
	(4, 2, '2022-01-04'),
	(5, 3, '2022-01-05'),
	(6, 4, '2022-01-06'),
	(7, 7, '2022-01-07'),
	(8, 7, '2022-01-08'),
	(9, 9, '2022-01-09'),
	(10, 10, '2022-01-10')
;

SELECT * FROM Orders ;

-- Different Types of join
-- INNER JOIN
SELECT 
	Customers.CustomerName, Orders.OrderDate
FROM 
	Customers
		INNER JOIN 
	Orders 
			ON Customers.CustomerID = Orders.CustomerID;

/*
This query will return a result set that contains only the customer names and order dates where 
there is a match between the CustomerID field in the Customers table and the CustomerID field in the Orders table.
*/

-- LEFT JOIN 
SELECT 
	Customers.CustomerName, Orders.OrderDate
FROM 
	Customers
		LEFT JOIN 
	Orders 
		ON Customers.CustomerID = Orders.CustomerID;
/*
 This query will return a result set that contains all customer names and order dates, even if there is no match 
 between the CustomerID field in the Customers table and the CustomerID field in the Orders table. If there is no match, 
 the OrderDate field will be NULL.
 */
-- RIGHT JOIN
SELECT 
	Customers.CustomerName, Orders.OrderDate
FROM 
	Customers
		RIGHT JOIN 
	Orders 
		ON Customers.CustomerID = Orders.CustomerID;

/*
 * This query will return a result set that contains all order dates and customer names, even if there is no match 
 * between the CustomerID field in the Orders table and the CustomerID field in the Customers table. If there is no match, 
 * the CustomerName field will be NULL.
*/

-- FULL OUTER JOIN 
SELECT 
	Customers.CustomerName, Orders.OrderDate
FROM 
	Customers
		FULL OUTER JOIN 
	Orders 
		ON 
	Customers.CustomerID = Orders.CustomerID;

-- didn't work
SELECT 
	Customers.CustomerName, Orders.OrderDate
FROM 
	Customers
		LEFT JOIN 
	Orders ON Customers.CustomerID = Orders.CustomerID
UNION
SELECT 
	Customers.CustomerName, Orders.OrderDate
FROM 
	Customers
		RIGHT JOIN 
	Orders ON Customers.CustomerID = Orders.CustomerID;
-- SUB-QUERIES
-- Sub-queries with the SELECT Statement:

SELECT 
	CustomerName, ContactName, Country
FROM 
	Customers
WHERE 
	Country IN (SELECT 
					Country 
				FROM 
					Suppliers
				);

-- Sub-queries with the INSERT Statement:
INSERT INTO 
	Orders 
(	
	OrderID,
	CustomerID, 
	OrderDate
)
VALUES (11,
		(SELECT 
			CustomerID 
		FROM 
			Customers 
		WHERE 
			CustomerName = 'Alfreds'), 
		'2022-01-01');

		
-- Sub-queries with the DELETE Statement:
DELETE FROM 
	Customers
WHERE 
	CustomerID IN (SELECT 
						CustomerID 
					FROM 
						Orders 
					WHERE OrderDate < '2022-01-01'
				);

-- Sub-queries with the UPDATE Statement:
UPDATE 
	Customers
SET 
	Country = (SELECT 
					Country 
				FROM 
					Suppliers 
				WHERE SupplierName = 'Exotic Liquids'
				)
WHERE CustomerID = 1;

-- Nested Queries
SELECT 
	CustomerName, ContactName, Country
FROM 
	Customers
WHERE 
	Country IN (SELECT 
					Country FROM (
                      SELECT 
                      	  Country, COUNT(*) as count
                      FROM 
                      	  Customers
                      GROUP BY 
                      	  Country
                      HAVING 
                      	  COUNT(*) > 1
                  ) AS duplicate_countries
                 );
/*
 * This query uses a nested subquery to find all countries that appear more than once in the Customers table, 
 * and then returns all customer names, contact names, and countries from the Customers table where the country is one 
 * of the duplicated countries. The nested subquery itself is a grouped query that counts the number of customers in each country, 
 * and then filters the results to only include countries with a count greater than 1.
