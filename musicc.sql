create database musics;
use musics;

# Who is the senior most employee based on job title?
select * from employee
ORDER BY levels desc
LIMIT 1;


# Which country have the most invoices?
select billing_country,count(*) as total_count from invoice 
group by billing_country
order by 2 desc;


# What are top 3 values of total invoice

select total from invoice 
order by total desc
limit 3; 


# Which city has the best customers.
#Write a query that returns one city that has highest sum of invoice totals.Return both city name and sum  of invoice totals

select SUM(total) as invoice_total,billing_city
from invoice
group by billing_city
order by invoice_total desc;


# Write a query to return email,firstname,last_name and genre of all rock music listeners.
#Return your list ordered alphabetically by email starting with A





select DISTINCT email,first_name,last_name
FROM customer
JOIN invoice ON customer.customer_id=invoice.customer_id
JOIN invoice_line ON invoice.invoice_id=invoice_line.invoice_id
WHERE track_id IN( SELECT track_id FROM track 
JOIN genre ON track.genre_id=genre.genre_id
WHERE genre.name LIKE 'Rock'
)
ORDER BY email;

# Write a query that return the artist name and total track count of top 10 rock brands

select artist.artist_id,artist.name,count(artist.artist_id) as no_of_songs
FROM track
JOIN album ON album.album_id=track.album_id
JOIN artist ON artist.artist_id=album.artist_id
JOIN genre ON genre.genre_id=track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY no_of_songs DESC
LIMIT 10

#Return all the tracknames that have a song length longer than the average song length
#Return the Name and milliseconds for each track .Order by the song length with the longest songs listed first

select name,milliseconds from
track where milliseconds>
(select avg(milliseconds) as avg_track_length
from track)
order by milliseconds desc

# Find how much amount spent by each customer on artists ?Write a query to return customername ,artistname and total_spent

with best_selling_artist AS
(
  select artist.artist_id as artist_id,artist.name AS artist_name,
SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
FROM invoice_line
JOIN track ON track.track_id=invoice_line.track_id
JOIN album ON album.album_id=track.album_id
JOIN artist ON artist.artist_id=album.artist_id
GROUP BY 1
ORDER BY 3 DESC
LIMIT 1
)
SELECT c.customer_id,c.first_name,c.last_name,bsa.artist_name,
SUM(il.unit_price*il.quantity) AS amount_spent 
FROM invoice i
JOIN customer c ON c.customer_id=i.customer_id
JOIN invoice_line ON il.invoice_id=i.invoice_id
JOIN track t ON t.track_id=il.track_id
JOIN album alb ON alb.album_id=t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id=alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;



#  We want to find out most popular genre on each country.We determine the most popular genre
#as the genre with highest a,ount of purchases.Write a query that returns each country along with 
#the top genre.For countries where the maximum no.of purchases is shared return all genres

with popular_genre AS
(
SELECT COUNT(invoice_line.quantity) AS purchases,customer.country,genre.name,genre.genre_id,
ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity)DESC) AS RowNo
FROM invoice_line
JOIN invoice ON invoice.invoice_id=invoice_line.invoice_id
JOIN customer ON customer.customer_id=invoice.customer_id
JOIN track ON track.track_id=invoice_line.track_id
JOIN genre ON genre.genre_id=track.genre_id
GROUP BY 2,3,4
ORDER BY 2 ASC,1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1





