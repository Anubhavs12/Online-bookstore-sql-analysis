# Online Bookstore Analysis using SQL

## Overview

SQL analysis of an online bookstore database (PostgreSQL) with 3 related tables and 1,500 records. The project answers 20 business questions on sales, customers, and inventory.

## Dataset

|Table|Rows|Columns|
|-|-|-|
|Books|500|Book\_ID, Title, Author, Genre, Published\_Year, Price, Stock|
|Customers|500|Customer\_ID, Name, Email, Phone, City, Country|
|Orders|500|Order\_ID, Customer\_ID, Book\_ID, Order\_Date, Quantity, Total\_Amount|

## Skills Used

Database design (primary and foreign keys), CSV import with COPY, JOINs (INNER and LEFT), GROUP BY / HAVING, aggregate functions, ORDER BY / LIMIT, date filtering, COALESCE

## Key Insights

* Total revenue: **$70,422.59**
* Top-selling genre: **Science Fiction**
* Top customer by spend: \[Stacey Ross 775.28]
* Lowest-stock book: \[Down-sized demand-driven structure 1 stock]

## How to Run

1. Create the database and tables using the script.
2. Update the CSV file paths in the `COPY` commands to match your machine.
3. Run the queries in order.

\---

## Questions and Queries

### Basic Queries

**1. Retrieve all books in the Fiction genre**

```sql
SELECT \* FROM Books WHERE genre = 'Fiction';
```

*Result:* \[66]



**2. Find books published after 1950**

```sql
SELECT \* FROM Books WHERE published\_year > 1950;
```

*Result:* \[280]



**3. List all customers from Canada**

```sql
SELECT \* FROM Customers WHERE country = 'Canada';
```

*Result:* \[ 11]



**4. Show orders placed in November 2023**

```sql
SELECT \* FROM Orders
WHERE order\_date BETWEEN '2023-11-01' AND '2023-11-30';
```

*Result:* \[14]



**5. Total stock of books available**

```sql
SELECT SUM(stock) AS total\_stock FROM Books;
```

*Result:* \[25146 Books available in stock]



**6. Details of the most expensive book**

```sql
SELECT \* FROM Books ORDER BY price DESC LIMIT 1;
```

*Result:* \[ 'Persistent interactive project' By Keith Gray]



**7. Customers who ordered more than 1 quantity of a book**

```sql
SELECT DISTINCT c.customer\_id, c.name
FROM Orders o
JOIN Customers c ON c.customer\_id = o.customer\_id
WHERE o.quantity > 1;
```

*Result:* \[463 Customers ordered more than 1 book]



**8. Orders whose total amount exceeds $20**

```sql
SELECT \* FROM Orders WHERE total\_amount > 20;
```

*Result:* \[ 475 Orders whose total exceeds 20$]



**9. List all genres in the Books table**

```sql
SELECT DISTINCT genre FROM Books;
```

*Result:* \[7 Genres]



**10. Book with the lowest stock**

```sql
SELECT \* FROM Books ORDER BY stock ASC LIMIT 1;
```

*Result:* \['Down-sized demand-driven structure' By Bryan Clark]

**11. Total revenue from all orders**

```sql
SELECT SUM(total\_amount) AS revenue FROM Orders;
```

*Result:* 70,422.59



### Advanced Queries



**12. Total books sold per genre**

```sql
SELECT b.genre, SUM(o.quantity) AS total\_books\_sold
FROM Orders o
JOIN Books b ON o.book\_id = b.book\_id
GROUP BY b.genre;
```

*Result:* Science Fiction is the top-selling genre. \[531]



**13. Average price of fantasy books sold**

```sql
SELECT AVG(b.price) AS average\_price
FROM Orders o
JOIN Books b ON b.book\_id = o.book\_id
WHERE b.genre = 'Fantasy';
```

*Result:* \[Average price 28.28]



**14. Customers with at least 2 orders**

```sql
SELECT o.customer\_id, c.name, COUNT(o.order\_id) AS order\_count
FROM Orders o
JOIN Customers c ON o.customer\_id = c.customer\_id
GROUP BY o.customer\_id, c.name
HAVING COUNT(o.order\_id) >= 2;
```

*Result:* \[130 Customers who placed atleast 2 orders]



**15. Most frequently ordered book**

```sql
SELECT o.book\_id, b.title, COUNT(o.order\_id) AS order\_count
FROM Orders o
JOIN Books b ON o.book\_id = b.book\_id
GROUP BY o.book\_id, b.title
ORDER BY order\_count DESC
LIMIT 1;
```

*Result:* \['User-friendly coherent project' By Denise Ruiz]



**16. Top 3 most expensive Fantasy books**

```sql
SELECT \* FROM Books
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3;
```

*Result:* \["Cross-platform optimal contingency" "Virtual hybrid database" "Cross-platform encompassing migration"]



**17. Total quantity of books sold by each author**

```sql
SELECT b.author, SUM(o.quantity) AS total\_books\_sold
FROM Orders o
JOIN Books b ON b.book\_id = o.book\_id
GROUP BY b.author;
```

*Result:* \[Denise Ruiz 34]



**18. Cities where customers spent over $30 on an order**

```sql
SELECT DISTINCT c.city
FROM Orders o
JOIN Customers c ON o.customer\_id = c.customer\_id
WHERE o.total\_amount > 30;
```

*Result:* 248 Cities



**19. Customer who spent the most**

```sql
SELECT c.customer\_id, c.name, SUM(o.total\_amount) AS total\_spent
FROM Orders o
JOIN Customers c ON c.customer\_id = o.customer\_id
GROUP BY c.customer\_id, c.name
ORDER BY total\_spent DESC
LIMIT 1;
```

*Result:* \["Stacey Ross" 775.28]



**20. Stock remaining after fulfilling all orders**

```sql
SELECT b.book\_id, b.title, b.stock,
       COALESCE(SUM(o.quantity), 0) AS order\_quantity,
       b.stock - COALESCE(SUM(o.quantity), 0) AS remaining\_stock
FROM Books b
LEFT JOIN Orders o ON o.book\_id = b.book\_id
GROUP BY b.book\_id, b.title, b.stock;
```

*Result:* \[29 Books ran out of stock]



