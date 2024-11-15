/*
SUBJECTIVE QUESTIONS
*/


/*Q1.  

Select dense_rank() over (order by sum(il.quantity) desc) ranking,
g.name nam, al.title ,sum(il.quantity) quantity_sold
FROM invoice_line il
left join track t on il.track_id = t.track_id
left join genre g on t.genre_id = g.genre_id
left join invoice i on il.invoice_id = i.invoice_id
left join album al on t.album_id = al.album_id
left join artist a on al.artist_id = a.artist_id
Where i.billing_country = "USA" and year(i.invoice_date) = 2020
group by 2, 3
limit 5
*/

/*Q2. 

Select dense_rank() over (order by sum(il.quantity) desc) ranking,
g.name nam,sum(il.quantity) quantity_sold
FROM invoice_line il
left join track t on il.track_id = t.track_id
left join genre g on t.genre_id = g.genre_id
left join invoice i on il.invoice_id = i.invoice_id
left join album al on t.album_id = al.album_id
left join artist a on al.artist_id = a.artist_id
Where i.billing_country not in ("USA")
group by 2 
*/

/*Q3. 
with analysis as(
Select c.customer_id cusid, concat(c.first_name," ",c.last_name) cusname, count(distinct year(i.invoice_date)) active_years,
count(distinct year(i.invoice_date)) times_bought, sum(il.quantity) total_quantity, sum(i.total) total_amount_spent
From customer c
left join invoice i on  c.customer_id = i.customer_id
left join invoice_line il on  i.invoice_id = il.invoice_id
group by 1,2
order by 3)

Select active_years, count(cusid) customers, sum(times_bought) no_of_times_bought, sum(total_quantity) total_quantity_bought, round(avg(total_amount_spent)) average_amount_spent FROM analysis
group by 1
*/

/*Q4. 
with 
genre_sales as
(SELECT  g.name nam, i.billing_country country, a.name artist, al.title
FROM invoice_line il
left join track t on il.track_id = t.track_id
left join genre g on t.genre_id = g.genre_id
left join invoice i on il.invoice_id = i.invoice_id
left join album al on t.album_id = al.album_id
left join artist a on al.artist_id = a.artist_id
group by 1,2,3,4
)


Select i.customer_id id, i.invoice_id,
count(il.invoice_line_id) count
FROM invoice i
left join invoice_line il on i.invoice_id = il.invoice_id
group by 1,2
order by 1
*/

/*Q5.
1. 
select
billing_country country,
count(customer_id) no_of_customers,
count(distinct invoice_date) no_of_bussiness_days,
count(distinct invoice.invoice_id) no_of_purchases,
count(distinct il.track_id) no_of_items_purchased,
sum(total) avg_revenue_generated
FROM invoice
left join invoice_line il on invoice.invoice_id = il.invoice_id
group by 1
order by 6 desc

2. 
select
billing_country country,
billing_city city,
count(customer_id) no_of_customers,
count(distinct invoice_date) no_of_bussiness_days,
count(distinct invoice.invoice_id) no_of_purchases,
count(distinct il.track_id) no_of_items_purchased,
sum(total) avg_revenue_generated
FROM invoice
left join invoice_line il on invoice.invoice_id = il.invoice_id
group by 1,2
order by 6 desc
*/

/* Q6. 
with
customer_data
as
(select
dense_rank() over (partition by billing_country order by sum(total) desc) as ranking,
billing_country country,
year(invoice_date) bussiness_year,
count(customer_id) no_of_customers,
count(distinct invoice_date) no_of_bussiness_days,
count(distinct invoice.invoice_id) no_of_purchases,
count(distinct il.track_id) no_of_items_purchased,
sum(total) avg_revenue_generated
FROM invoice
left join invoice_line il on invoice.invoice_id = il.invoice_id
group by 2,3
order by 2, 6 desc
)

Select * FROM customer_data
where bussiness_year = "2020"
order by ranking
*/

/*Q7
1.
with
recent as (
Select c.customer_id cusid, concat(c.first_name," ",c.last_name) cusname
From customer c
left join invoice i on  c.customer_id = i.customer_id
Where invoice_date Between "2020-10-01" and "2020-12-31"
group by 1
order by 1)

SELECT customer_id customer, min(date_format(invoice_date,"%Y-%M")) initial_purchase_date, max(date_format(invoice_date,"%Y-%M")) final_purchase_date, 
count(distinct MONTH(invoice_date)) active_months, count(distinct t.album_id) no_of_albums, count(distinct il.track_id) no_of_tracks_purchased, 
count(distinct g.name) genre_name, count(distinct a.name) artists
FROM invoice i
left join invoice_line il on i.invoice_id = il.invoice_id
left join track t on il.track_id = t.track_id
left join genre g on t.genre_id = g.genre_id
left join album al on t.album_id = al.album_id
left join artist a on al.artist_id = a.artist_id
where customer_id not in (select cusid from recent)
group by 1 
order by 1

2.
with
recent as (
Select c.customer_id cusid, concat(c.first_name," ",c.last_name) cusname
From customer c
left join invoice i on  c.customer_id = i.customer_id
Where invoice_date Between "2020-10-01" and "2020-12-31"
group by 1
order by 1)

SELECT customer_id customer, min(date_format(invoice_date,"%Y-%M")) initial_purchase_date, max(date_format(invoice_date,"%Y-%M")) final_purchase_date, 
count(distinct MONTH(invoice_date)) active_months, count(distinct t.album_id) no_of_albums, count(distinct il.track_id) no_of_tracks_purchased, 
g.name genre_name, a.name artists
FROM invoice i
left join invoice_line il on i.invoice_id = il.invoice_id
left join track t on il.track_id = t.track_id
left join genre g on t.genre_id = g.genre_id
left join album al on t.album_id = al.album_id
left join artist a on al.artist_id = a.artist_id
where customer_id not in (select cusid from recent)
group by 1,7,8
order by 8, 1

3.
with
recent as (
Select c.customer_id cusid, concat(c.first_name," ",c.last_name) cusname
From customer c
left join invoice i on  c.customer_id = i.customer_id
Where invoice_date Between "2020-10-01" and "2020-12-31"
group by 1
order by 1)

Select g.name genre, a.name artist, count(distinct customer_id) total_no_of_customer_who_have_purchased , count(distinct MONTH(invoice_date)) total_months_bought,
count(distinct t.album_id) no_of_albums, count(distinct il.track_id) no_of_tracks_purchased
FROM invoice i
left join invoice_line il on i.invoice_id = il.invoice_id
left join track t on il.track_id = t.track_id
left join genre g on t.genre_id = g.genre_id
left join album al on t.album_id = al.album_id
left join artist a on al.artist_id = a.artist_id
where customer_id not in (select cusid from recent)
group by 1, 2
order by 4 desc, 3 desc, 6 desc

*/

/*Q11. 
with
customer_data as (
Select
billing_country country,
count(customer_id) no_of_customers,
count(distinct invoice_date) no_of_bussiness_days,
count(distinct invoice.invoice_id) no_of_tracks_purchases,
count(distinct il.track_id) no_of_items_purchased,
sum(total) avg_revenue_generated
FROM invoice
left join invoice_line il on invoice.invoice_id = il.invoice_id
group by 1
order by 1, 6 desc
)

Select * FROM customer_data
*/


