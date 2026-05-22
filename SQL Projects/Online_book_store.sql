create database OnlineBookStore

-- create table

drop table if exists Book;

create table if not exists book(
BookID serial primary key,
Title varchar (100),
Author varchar (100),
Genre varchar (50),
published_year int,
price numeric (10,2),
stock int
);

select*from Book;

drop table if exists customers;
create table if not exists customers(
 Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

select*from customers;

drop table if exists orders;
create table if not exists orders(
 Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    BookID INT REFERENCES Book(BookID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);
select*from orders;
-- Retrieve all books in the "Fiction" genre?

select * from book where genre='Fiction';

--Find books published after the year 1950?

select*from book where published_year>1950;


--List all customers from the Canada?
select *from customers where country = 'Canada';

--Show orders placed in November 2023?

select * from orders where order_date between '2023-11-1' and '2023-11-30' ;

--Retrieve the total stock of books available?
select sum(stock) as total_stock from book;
--find the details of the most expensive books?

select *from book order by price desc limit 1;

--  Show all customers who ordered more than 1 quantity of a book:
select* from orders where quantity > 1;

-- Retrieve all orders where the total amount exceeds $20:
select*from orders where total_amount >20;

-- List all genres available in the Books table:
select distinct genre from book; 
--Find the book with the lowest stock:

select*from book order by stock asc limit 1;

-- 11) Calculate the total revenue generated from all orders:

select sum (total_amount) as Total_revenue from orders;

-- advance queries



-- Retrieve the total number of books sold for each genre?

select b.genre,sum(O.quantity) as Total_Books_Sold
from orders o
join book b on o.BookID=b.BookID
group by genre;


--Find the average price of books in the "Fantasy" genre:

select Avg(price) as Average_Price
 from book 
 where genre = 'Fantasy';

 --List customers who have placed at least 2 orders:



 select Customer_ID,count(Order_ID) as Order_Count
from orders

group by Customer_ID
having count(Order_ID)>=2;


 select o.Customer_ID,c.Name,count(o.Order_ID) as Order_Count
from orders o
join customers c on o.Customer_ID=c.Customer_ID

group by o.Customer_ID ,c.Name
having count(Order_ID)>=2;

-- Find the most frequently ordered book:

select BookID,count(order_id) as Order_count
from orders

group by BookID
order by order_count desc;
--Show the top 3 most expensive books of 'Fantasy' Genre 

select * from book
where genre='Fantasy'
order by price desc limit 3;

--Retrieve the total quantity of books sold by each author:

select b.Author,sum(O.quantity) as Total_Books_Sold
from orders o
join book b on o.BookID=b.BookID
group by Author;

--List the cities where customers who spent over $30 are located

select distinct c.city,Total_amount
from orders o
join customers c on o.Customer_ID = c.Customer_ID

where o. Total_Amount>30;

-- Find the customer who spent the most on orders
select c.Customer_ID,c.Name,sum(Total_Amount)as Total_Spent
from orders o
join customers c on  o.Customer_ID= c.Customer_ID
group by c.Customer_ID,c.Name
order by Total_Spent desc limit 1;

--Calculate the stock remaining after fulfilling all orders
select b.BookID,b.Title,b.Stock,coalesce (sum(Quantity),0)as order_Quantity,
b.Stock-coalesce (sum(Quantity),0) as Remaing_Quantity
from book b
left join orders o on b.BookID=o.BookID
group by b.BookID order by BookID;



