USE empdb;
RENAME TABLE bmw_global_sales_2018_2025 TO bmwsale;
select * from bmwsale;
---Aggregation & Grouping
---Q1. Find the total revenue and total units sold for each Region and year
SELECT 
    Year,Region,
    SUM(Revenue_EUR) AS Total_Revenue,
    SUM(Units_Sold) AS Total_Units_Sold
FROM bmwsale
GROUP BY Year,Region
ORDER BY Year,Total_Revenue DESC;



---Q2. Find the average selling price (Avg_Price_EUR) per Model across all regions, sorted from highest to lowest.
select Region,model,
Avg(Avg_Price_EUR)as avg_price
from bmwsale
group by Region,model
order by avg_price DESC;

---Q3. Which Region-Model combination generated the highest total revenue?
select Region,model,
SUM(Revenue_EUR)as highest_revenue
from bmwsale
group by Region,model
order by highest_revenue DESC
LIMIT 3 OFFSET 0;

---Window Functions
Q4. For each Region, rank the models by total revenue (highest = rank 1) using RANK() or DENSE_RANK().
SELECT 
    Region,
    Model,
    SUM(Revenue_EUR) AS total_revenue,
    RANK() OVER (PARTITION BY Region ORDER BY SUM(Revenue_EUR) DESC) AS revenue_rank
FROM bmwsale
GROUP BY Region, Model
ORDER BY Region, revenue_rank




Q5. Calculate the month-over-month change in Units_Sold for each Model within a Region using LAG().
with sales as ( 
select Region,Model,Year,Month,Units_Sold,
lag(Units_Sold) over(PARTITION BY Region,Model order by Year,Month) as prev_month_unit_sold
 FROM bmwsale)
 select Region,Model,Year,Month,Units_Sold,prev_month_unit_sold,
(Units_Sold-prev_month_unit_sold) as mom_change, 
concat(round(100.0*(Units_Sold-prev_month_unit_sold)/nullif(prev_month_unit_sold,0),2),"%")as pect_momcahnge
from sales
order by Region,Model,Year,Month
			 
                    




Q6. Find the running total (cumulative revenue) for each Region ordered by Month, using a window function.
select Region,model,Year,Month,Revenue_EUR,
SUM(Revenue_EUR)over(PARTITION BY Region order by year,month) as runnin_revenue_total
from bmwsale
order by runnin_revenue_total desc
limit 10;
---Filtering with Aggregates
--Q7. Find all Models where the average BEV_Share (across all months/regions) is greater than 0.02.
select model,round(avg(BEV_Share),2)as avg_bev
from  bmwsale
group by model
having avg(BEV_Share) >0.02
order by avg_bev desc;

 ---Sales Performance & Trends
---Q8. Which Model sold the most units overall? 
select Model,
sum(Units_Sold)as total_unit_Sold
from bmwsale
group by Model
order by total_unit_Sold desc;
select Units_Sold from  bmwsale;

---Q9 Which Region generates the highest total revenue?
select Region,sum(Revenue_EUR) as total_revenue
from bmwsale
group by Region
order by  total_revenue desc;
select Units_Sold from  bmwsale;


---Q10. Year-over-year growth in total revenue (across all regions/models
select year,sum(Revenue_EUR)as yealy_revenue_EUR
from bmwsale
group by Year 
order by Year;
--- Regional Comparison



----Q11. Which Region-Model combo is the strongest performer (by revenue
select Units_Sold from  bmwsale;

select Region,Model,sum(Revenue_EUR)as region_model_revenue
from  bmwsale
group by Region,Model
order by region_model_revenue desc
limit 10;
 ---Average price per unit, by Region
 select Region,round(avg(Revenue_EUR),2)as avg_price_revenue
 from bmwsale
 group by Region
 order by avg_price_revenue desc;
---Q13. How has BEV_Share changed year by year
select Year,Round(avg(BEV_Share),2)as avg_bev_year
from bmwsale
group by year
order by avg_bev_year desc;
---Q14 Which Region has the highest average BEV_Share?
select Region,Round(avg(BEV_Share),2) as avg_bev_region
from bmwsale 
group by Region 
order by avg_bev_region;

---Q15. Compare average price vs total units sold, per Model
select Model,round(avg(Revenue_EUR),2)as avg_price, sum(Units_Sold)as total_unit
from bmwsale
group by model
order by avg_price desc;

---Q16. Average GDP_Growth and Fuel_Price_Index per Year
select Year,Round(avg(GDP_Growth),2)as AVG_GDP_GROWTH,round(avg(Fuel_Price_Index),2)as avg_fuel_index
from bmwsale
group by year 
order by year;


select region,sum(Revenue_EUR) as total_revenue
from bmwsale
group by region
order by total_revenue desc;

select Region, round(avg(Avg_Price_EUR), 2) as avg_price
from bmwsale
group by Region
order by avg_price desc;