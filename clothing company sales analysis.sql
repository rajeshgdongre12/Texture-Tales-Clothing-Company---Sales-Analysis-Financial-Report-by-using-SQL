create database texture_tales;
use texture_tales;

select * from product_details;
select * from product_hierarchy;
select * from product_prices;
select * from sales;

--Q1 What was the total quantity sold for all products?
select p.product_name,sum(s.qty) as 'total_qty_sold' from product_details as p
inner join sales as s
on p.product_id=s.prod_id
group by p.product_name
order by total_qty_sold desc;

--Q2.What is the total generated revenue for all products before discounts?
select sum(qty*price) as 'total_revenue_before_discount'
from sales;

--Q3.What was the total discount amount for all products?
select sum(price*qty*discount)/100 as 'total_discount' from sales;

--Q4.How many unique transactions were there?
select count(distinct txn_id) as 'total unique transaction'
from sales;

--Q5.What are the average unique products purchased in each transaction?
with cte_transaction_products as (
select txn_id,
count(distinct prod_id) as product_count
from sales
group by txn_id
)
select
round(avg(product_count),2) as avg_unique_products
from cte_transaction_products;

--Q6.What is the average discount value per transaction?
with cte_txn_discount as(
select txn_id,
sum(price*qty*discount)/100 as 'total_discount'
from sales
group by txn_id
)
select round(avg(total_discount),2) as 'avg total discount'
from cte_txn_discount;

--Q7.What is the average revenue for member transactions and non-member transactions?
with total_revenue as(
select member,txn_id,
sum(qty*price) as 'total_price'
from sales
group by member,txn_id
)
select member,
round(avg(total_price),2) as 'avg_revenue'
from total_revenue
group by member;

--Q8.What are the top 3 products by total revenue before discount?
select top 3 details.product_name,sum(sales.qty * sales.price) as nodis_revenue
from sales as sales
INNER JOIN product_details as details
on sales.prod_id = details.product_id
group by details.product_name
order by nodis_revenue desc

--Q9.What are the total quantity, revenue and discount for each segment?
select distinct p.segment_name,sum(s.qty) as 'totak_qty',sum(s.qty*s.price) as 'total_revenue',
sum(s.qty*s.price*s.discount)/100 as 'total_discount'
from sales as s
inner join product_details as p
on p.product_id=s.prod_id
group by p.segment_name;

--Q10.What is the top selling product for each segment?
select p.segment_name,p.product_name,sum(s.qty) as 'selling_product'
from product_details as p
inner join sales as s
on p.product_id=s.prod_id
group by p.segment_name,p.product_name
order by selling_product desc;

--Q11.What are the total quantity, revenue and discount for each category?
select distinct p.category_name,sum(s.qty) as 'totak_qty',sum(s.qty*s.price) as 'total_revenue',
sum(s.qty*s.price*s.discount)/100 as 'total_discount'
from sales as s
inner join product_details as p
on p.product_id=s.prod_id
group by p.category_name;

--Q12.What is the top selling product for each category?
select p.category_name,p.product_name,sum(s.qty) as 'selling_product'
from product_details as p
inner join sales as s
on p.product_id=s.prod_id
group by p.category_name,p.product_name
order by selling_product desc;









