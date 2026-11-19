--Creating Database 

CREATE DATABASE OnlineBookStore;

--Creating Tables

DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
		Book_ID	SERIAL	PRIMARY KEY,
		Title	VARCHAR(100),
		Author	VARCHAR(50),
		Genre	VARCHAR(50),
		Published_Year	INT,	
		Price	NUMERIC(10,2),
		Stock	INT
);

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers(
		Customer_ID	SERIAL 	PRIMARY KEY,
		Name	VARCHAR(50),
		Email	VARCHAR(100),
		Phone	NUMERIC(20),
		City	VARCHAR	(50),
		Country	VARCHAR(50)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
		Order_ID	SERIAL	PRIMARY KEY,
		Customer_ID	INT	REFERENCES Customers(Customer_ID),
		Book_ID	INT	REFERENCES Books(Book_ID),
		Order_Date	DATE,
		Quantity	INT,
		Total_Amount NUMERIC(10,2)	
		
);


SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

--Importing data into books_table

COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'C:\Users\Public\Downloads\books.csv'
CSV HEADER;

--Importing data into Customers_table

COPY Customers(Customer_ID, Name, Email, Phone, City, Country)
FROM 'C:\Users\Public\Downloads\customers.csv'
CSV HEADER;

--Importing data into Orders_table

COPY Orders(Order_ID,Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'C:/Users/Public/Downloads/OrderS.csv'
CSV HEADER;



-- RETRIEVE ALL BOOKS IN FICTION GENRE

SELECT * FROM Books
WHERE genre='Fiction';

--FIND BOOKS PUBLISHED AFTER THE YEAR 1950

SELECT * FROM Books
WHERE published_year>1950;

--List all customers from canada

SELECT * FROM Customers
WHERE Country='Canada';

--Show orders placed in november 2023

SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';


--Retrieve all the total stocks of books available

SELECT SUM(stock) AS total_stock
FROM Books;

-- find the details of the most expensive book

SELECT * FROM Books ORDER BY price DESC LIMIT 1;

--show all customers who ordered more than 1 quantity of a book

SELECT * FROM Orders
WHERE quantity>1;

-- RETRIEVE ALL ORDERS WHOSE TOTAL AMOUNT EXCEEDS 20$?

SELECT * FROM Orders
WHERE total_amount>20;


--LIST ALL GENRE AVAILABLE IN THE BOOKS TABLE


SELECT DISTINCT genre FROM Books;

-- Find the book with the lowest stock available

SELECT * FROM Books ORDER BY stock ASC LIMIT 1;

--Calculate the total revenue generated from all orders

SELECT SUM(total_amount) AS revenue FROM Orders;




--Retreive the total no of books sold from each genre

SELECT * FROM Orders;

SELECT b.genre, SUM(o.quantity) AS total_books_sold
FROM Orders o
JOIN Books b ON o.Book_id = b.Book_id
GROUP BY b.genre ORDER BY total_books_sold DESC;

-- Which is the top most selling genre

SELECT b.Genre, SUM(o.Quantity) AS Books_Sold
FROM Orders o
JOIN Books b ON b.Book_ID = o.Book_ID
GROUP BY b.Genre
ORDER BY Books_Sold DESC
LIMIT 1;



--Find the average price of books sold in the 'fantasy genre'

SELECT AVG(price) AS average_price
FROM Books
WHERE genre = 'Fantasy';


-- List customers who have atleast placed 2 orders?

SELECT o.customer_id, c.name, COUNT(o.order_id) AS order_count
FROM Orders o
JOIN Customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT  (order_id)>=2;


-- Find the most frequently ordered book?

SELECT o.book_id, b.title, b.author, COUNT(o.order_id) AS Order_count
FROM Orders o
JOIN books b ON o.book_id = b.book_id
GROUP BY o.book_id, b.title, b.author
ORDER BY  Order_count DESC LIMIT 1;

--Show Top 3 most expensive book of 'fantasy' genre?

SELECT * FROM Books
WHERE genre = 'Fantasy'
ORDER BY price DESC lIMIT 3;

-- RETRIEVE TOTAL QUANTITY OF BOOKS SOLD BY EACH AUTHOR

SELECT b.author, SUM(o.quantity) AS total_books_sold
FROM Orders o 
JOIN Books b ON b.book_id = o.book_id
GROUP BY b.author;

-- list the cities where customers have spent over 30$ are located?

SELECT DISTINCT c.city
FROM Orders o JOIN Customers c ON o.customer_id = c.customer_id
WHERE o.total_amount > 30;

-- Who is the top customer by spend

SELECT c.Name, SUM(o.Total_Amount) AS Total_Spent
FROM Orders o
JOIN Customers c ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Name
ORDER BY Total_Spent DESC
LIMIT 1;

--Calculate the stock remaining after fulfilling all the orders

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity), 0) AS Order_quantity, 
		b.stock - COALESCE(SUM(o.quantity), 0) AS remaining_stock
FROM Books b
LEFT JOIN orders o ON o.book_id = b.book_id
GROUP BY b.book_id, b.stock
ORDER BY remaining_stock DESC;


















