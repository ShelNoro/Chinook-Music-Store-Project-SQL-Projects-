/*
OBJECTIVE QUESTIONS
*/

/* Q2.
 
With 
records as(
SELECT track_id, sum(quantity) total_sales
FROM invoice_line
Group by track_id 
order by total_sales desc),
art as
(SELECT al.album_id, a.name nome
FROM album al
LEFT Join artist a on al.artist_id =  a.artist_id
)

Select t.name Track, art.nome Artist, g.name as Genre, r.total_sales 
From track t
Left Join records r on t.track_id = r.track_id
Left Join art on t.album_id = art.album_id
Left Join genre g on t.genre_id = g.genre_id
Order by total_sales desc

*/

/* Q3.
1.
SELECT country, track.name as tracks,
sum(case when company is null then 1 else 0 end) unemployed_customers, 
count(company) employed_customers,
count(customer.customer_id) total_customers FROM customer 
left join invoice on customer.customer_id = invoice.customer_id
left join invoice_line on invoice.invoice_id = invoice_line.invoice_id
left join track on invoice_line.track_id = track.track_id
group by 1,2 
order by 5 desc


2.
SELECT city, track.name as tracks,
sum(case when company is null then 1 else 0 end) unemployed_customers, 
count(company) employed_customers,
count(customer.customer_id) total_customers FROM customer 
left join invoice on customer.customer_id = invoice.customer_id
left join invoice_line on invoice.invoice_id = invoice_line.invoice_id
left join track on invoice_line.track_id = track.track_id
group by 1,2 
order by 5 desc
*/

/* Q4.

SELECT 
billing_country country, 
billing_state state, 
billing_city city, 
sum(total) total_revenue, 
count(distinct invoice_id) no_of_invoices
FROM invoice
Group by billing_country, billing_state, billing_city
order by 4 desc, 5 desc
*/

/* Q5.

With
top_Cus as
(SELECT 
billing_country country, customer_id, sum(total) tots
From invoice
group by 1 , 2
order by 3 desc
),
Revenue as 
(SELECT 
dense_rank() over  (partition by country order by tots desc) rk,
country, customer_id, tots
From top_Cus)

Select rk, r.country, concat(c.first_name," ",c.last_name) as name, r.tots FROM Revenue r
Left join customer c on r.customer_id = c.customer_id
Where rk < 6
*/

/* Q6. 
with
ranking as(
SELECT 
track.track_id, track.name name, dense_rank() over (order by sum(quantity) desc) rk,
sum(quantity) total_sales
FROM invoice_line
Left join track on invoice_line.track_id = track.track_id
group by track_id
order by sum(quantity) desc
 ),
 ranking2 as
 (
 SELECT concat(c.first_name," ",c.last_name) as customer_name, r.track_id,  r.name, r.rk , dense_rank() over (partition by c.customer_id order by rk) rk2 FROM customer c
 left join invoice i on c.customer_id = i.customer_id
 left join invoice_line il on i.invoice_id = il.invoice_id
 left join ranking r on il.track_id =  r.track_id
 order by customer_name asc, rk asc
)

Select customer_name, track_id, name track_name FROM ranking2
Where rk2 < 2
*/
/* Q7.
1.
Select il.track_id, count(distinct i.customer_id) customers, count(i.invoice_date) purchase_days
From invoice i 
Left join invoice_line il on i.invoice_id = il.invoice_id
Group by 1
order by count(distinct i.invoice_date) desc

2.
Select customer_id, count(distinct invoice_date) no_of_purchases_made, count(distinct il.track_id) no_of_tracks_purchased, sum(il.quantity) total_amount_of_items ,round(avg(total),2) average_amount_spent
From invoice i 
Left join invoice_line il on i.invoice_id = il.invoice_id
group by customer_id
order by count(distinct invoice_date) desc

3. 
with
ranking as (
SELECT 
track.track_id, track.name name, dense_rank() over (order by sum(quantity) desc) rk,
sum(quantity) total_sales
FROM invoice_line
Left join track on invoice_line.track_id = track.track_id
group by track_id
order by sum(quantity) desc),
 ranking2 as
(SELECT Year(i.invoice_date), Month(invoice_date), r.track_id,  r.name, r.rk, count(il.track_id)
 FROM invoice i
 left join invoice_line il on i.invoice_id = il.invoice_id
 left join ranking r on il.track_id =  r.track_id
 group by 1,2,3,4,5
 order by 6 desc, 1, 2, 5)

Select *  FROM ranking2
*/

/*Q8. 
with year_wise as(
Select year(invoice_date) yr, 
Lag(count(distinct customer_id), 1, 59) OVER (
	ORDER BY count(distinct customer_id)) prev_count,
count(distinct customer_id) curr_count
From invoice
group by 1)

Select 
round((59-curr_count)/59*100,2) "churn_rate%"
FROM year_wise
where yr = "2020"

*/

/*Q9. 

with year_wise as(
Select year(invoice_date) yr, 
Lag(count(distinct customer_id), 1, 59) OVER (
	ORDER BY count(distinct customer_id) 
) prev_count,
count(distinct customer_id) curr_count
From invoice
group by 1
)

Select yr "year", 
round((59-curr_count)/prev_count*100) churn_rate
FROM year_wise
*/

/* Q10. 

with
cus as (
Select concat(c.first_name," ",c.last_name) customer_name, count(distinct g.name) genre_count
From customer c
left join invoice i on  c.customer_id = i.customer_id
left join invoice_line il on i.invoice_id = il.invoice_id
left  join track t on il.track_id = t.track_id
left join genre g on t.genre_id = g.genre_id
group by 1)

Select * FROM cus
Where genre_count > 2
*/

/*Q11.

SELECT  
dense_rank() over (order by sum(il.quantity) desc) ranking,
g.name nam, sum(il.quantity) quantity_sold
FROM invoice_line il
left join track t on il.track_id = t.track_id
left join genre g on t.genre_id = g.genre_id
left join invoice i on il.invoice_id = i.invoice_id
left join album al on t.album_id = al.album_id
left join artist a on al.artist_id = a.artist_id
Where i.billing_country = "USA"
group by 2
*/

/* Q12. 

1.
with
recent as (
Select c.customer_id cusid, concat(c.first_name," ",c.last_name) cusname
From customer c
left join invoice i on  c.customer_id = i.customer_id
Where invoice_date Between "2020-09-01" and "2020-12-31"
group by 1
order by 1)

Select concat(c2.first_name," ",c2.last_name) customer_name
From customer c2
where customer_id not in (select cusid from recent)

2. 
with
recent as (
Select c.customer_id cusid, concat(c.first_name," ",c.last_name) cusname
From customer c
left join invoice i on  c.customer_id = i.customer_id
Where invoice_date Between "2020-10-01" and "2020-12-31"
group by 1
order by 1)

Select concat(c2.first_name," ",c2.last_name) customer_name,
count(distinct i.invoice_date) no_of_bussiness_days,
count(distinct i.invoice_id) no_of_purchases,
count(il.track_id) no_of_items_purchased,
sum(total) avg_revenue_generated
FROM invoice i
RIGHT JOIN  CUSTOMER c2 on c2.customer_id = i.customer_id
left join invoice_line il on i.invoice_id = il.invoice_id
where c2.customer_id not in (select cusid from recent)
group by 1
*/

