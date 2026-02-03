#SQL Retail Sales Analysis - P1
create database sql_project_1;

use sql_project_1;

create table retail_sales(
	transactions_id int	primary key,
	sale_date date,
	sale_time time,
	customer_id int,
	gender varchar(10),
	age int,
	category varchar(10),
	quantiy int,
	price_per_unit float,
	cogs float,
	total_sale float
);

show tables;

select * 
from retail_sales
limit 10;

SELECT 
    COUNT(*) 
FROM retail_sales;

#Data Cleaning

SELECT * FROM retail_sales
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    customer_id IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
DELETE FROM retail_sales
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
     customer_id IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

select 
	transactions_id,
	sale_date,
	sale_time,
	customer_id,
	gender,
	age,
	category,
	quantity,
	price_per_unit,
	cogs,
	total_sale,
	count(*) as duplicate_count
from retail_sales
	group by 
    transactions_id,
	sale_date,
	sale_time,
	customer_id,
	gender,
	age,
	category,
	quantity,
	price_per_unit,
	cogs,
	total_sale
    having count(*)>1;
    
create table clean_retail as
select distinct *
    from retail_sales;

truncate table retail_sales;

insert into retail_sales
select * from clean_retail;

drop table clean_retail;

#Data Exploration

select count(*)      #How many sales we have?
from retail_sales;

select count(distinct customer_id) as total_customers   #How many uniuque customers we have ?
from retail_sales;

select distinct category  #SELECT DISTINCT category FROM retail_sales
from retail_sales;

#Data Analysis & Business Key Problems & Answers

#Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
#My Analysis & Findings 

select *                           #Write a SQL query to retrieve all columns for sales made on '2022-11-05
from retail_sales
where sale_date = '2022-11-05'; 

SELECT *                          #Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
FROM Retail_sales
WHERE category = 'Clothing'
  AND quantity >= 4
  AND sale_date >= '2022-11-01'
  AND sale_date <  '2022-12-01';
		                           

select                              #Write a SQL query to calculate the total sales (total_sale) for each category.
	category,
    sum(total_sale) as total_sales
from retail_sales
group by category;

 
 select                            #Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
	round(avg(age)) as avg_age,
    category
from retail_sales
group by category
order by avg(age)desc;
    
	
    select *                        # Write a SQL query to find all transactions where the total_sale is greater than 1000.
    from retail_sales
    where
		total_sale > 1000;


select                             #Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
	category,
    gender,
	count(transactions_id) as total_transactions
from retail_sales
group by
	category,
    gender
order by
	category;
    

select                              #Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
	year,
    month,
    avg_sales
from
	(select 
		year(sale_date) as year,
		monthname(sale_date) as month,
		avg(total_sale) as avg_sales,
		rank() over(partition by year(sale_date) order by avg(total_sale)) as sales_rank
	from retail_sales
	group by 
		year(sale_date),
		monthname(sale_date)) as t1
where
	sales_rank = 1
order by 
	year,
    avg_sales desc;
    
select                             #Write a SQL query to find the top 5 customers based on the highest total sales 

	customer_id,
	sum(total_sale) as total_sales
from retail_sales
group by 
	customer_id
order by
	total_sales desc
limit 5;


select                                 #Write a SQL query to find the number of unique customers who purchased items from each category.
	count(distinct customer_id) as unique_customers,
    category
from retail_sales
group by
	category;

#with CTE(common table expresion) 
 with hourly_sales as                        #Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
 (
select *,
case
	when hour(sale_time) < 12 then 'morning'
    when hour(sale_time) between 12 and 17 then 'afternoon'
    else 'evening'
end as shift
from retail_sales
where sale_time is not null
)
select shift,
count(*) as total_orders
from hourly_sales
group by
	shift
order by
	total_orders desc;
    
#with sub query
select
	shift,
    count(*) 
from
(select
	*,
    case
		when hour(sale_time) < 12 then 'morning'
        when hour(sale_time) between 12 and 17 then 'afternoon'
        else 'evening'
        end as shift
    from retail_sales) t2
    group by 
		shift;
    
