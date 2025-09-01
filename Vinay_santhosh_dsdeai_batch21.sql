/*Retrieve data using basic SELECT statements	List the names of all customers in the database.*/
SELECT CustomerName FROM customers;
/*Apply filtering using the WHERE clause	Retrieve the names and prices of all products that cost less than $15.00*/	
SELECT ProductName FROM products WHERE Price <15;
/*Use SELECT to extract multiple fields	Display all employees’ first and last names.*/
SELECT FirstName,LastName FROM employees;
/*Filter data using a function on date values	List all orders placed in the year 1997.*/
SELECT OrderID,OrderDate FROM orders WHERE OrderDate BETWEEN "1997-01-01" AND "1997-12-31";
SELECT OrderID, OrderDate FROM Orders WHERE YEAR(OrderDate) = 1997;
/*Apply numeric filters	 List all products that have a price greater than $50.*/
SELECT ProductName,Price FROM products WHERE Price > 50;
/*Perform multi-table JOIN operations	Show the names of customers and the names of the employees who handled their orders.*/
SELECT customers.CustomerName, employees.FirstName, employees.LastName
			FROM customers 
			INNER JOIN orders
			ON customers.CustomerID= orders.CustomerID
			INNER JOIN employees
			ON orders.EmployeeID = employees.EmployeeID;
			
/*Use GROUP BY for aggregation	List each country along with the number of customers from that country.*/
SELECT customers.Country, COUNT(customers.CustomerID) AS CustomerCount
			FROM customers
			GROUP BY Country;
			
/*Group data by a foreign key relationship and apply aggregation	Find the average price of products grouped by category.*/
SELECT categories.CategoryName,AVG(products.Price) 
			AS AvgPrice
			FROM products
			INNER JOIN categories
			ON categories.CategoryID = products.CategoryID
			GROUP BY CategoryName;
			
/*Use aggregation to count records per group	Show the number of orders handled by each employee.*/
SELECT employees.EmployeeID, COUNT(orders.OrderID) AS OrderCount
			FROM orders
			INNER JOIN employees
			ON orders.EmployeeID = employees.EmployeeID
			GROUP BY  EmployeeID;
			
			
/*Filter results using values from a joined table	List the names of products supplied by "Exotic Liquid".	*/
	SELECT products.ProductName,SupplierName
			FROM products
			INNER JOIN suppliers
			ON suppliers.supplierID = products.supplierID
			WHERE SupplierName  like "%Exotic Liquid%";
			
/*Rank records using aggregation and sort	List the top 3 most ordered products (by quantity).*/
	SELECT products.ProductID, SUM(orderdetails.Quantity) AS TotalOrdered
			FROM orderdetails
			INNER JOIN products
			ON orderdetails.ProductID=products.ProductID
			GROUP BY products.ProductID
			ORDER BY TotalOrdered DESC
			LIMIT 3;
			
/*Use GROUP BY and HAVING to filter on aggregates	Find customers who have placed orders worth more than $10,000 in total.*/
	SELECT customers.CustomerName, SUM(orderdetails.Quantity*products.Price) AS TotalSpent
			FROM products
			INNER JOIN orderdetails
			ON products.ProductID = orderdetails.ProductID
			INNER JOIN orders
			ON orderdetails.OrderID = orders.OrderID
			INNER JOIN customers
			ON orders.CustomerID = customers.CustomerID
			GROUP BY customers.CustomerID
			HAVING TotalSpent > 10000;
			
			
/*Aggregate and filter at the order level	Display order IDs and total order value for orders that exceed	$2,000 in value.*/
	SELECT orderdetails.OrderID, SUM(orderdetails.Quantity*products.Price) AS OrderValue
			FROM products
			INNER JOIN orderdetails
			ON products.ProductID = orderdetails.ProductID
			GROUP BY orderdetails.OrderID
			HAVING OrderValue > 2000;
			
/*Use subqueries in HAVING clause	Find the name(s) of the customer(s) who placed the largest single order (by value).*/
	SELECT assessments.assessment_id,assessment_name,AVG(assessment_submission.score) AS Average_Score
			FROM assessments
			INNER JOIN assessment_submission
			ON assessments.assessment_id = assessment_submission.assessment_id
			GROUP BY assessments.assessment_id,assessment_name
			HAVING Average_Score = 	
			(SELECT
			MAX(Average_Score)
			FROM
			(SELECT AVG(assessment_submission.score)
			AS Average_Score,user_id
			FROM assessment_submission GROUP BY user_id)			
			 AS Final);
			
/*Identify records using NOT IN with subquery	Get a list of products that have never been ordered.*/
	SELECT products.ProductID,orderdetails.ProductID
			FROM products
			INNER JOIN orderdetails
			ON products.ProductID = orderdetails.ProductID
			WHERE products.ProductID
			NOT IN 
			(SELECT orderdetails.ProductID 
			FROM orderdetails);
