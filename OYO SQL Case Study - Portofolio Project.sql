CREATE DATABASE Oyo_Hotel_Portofolio_Project

/* Nombre d'hôtels dans le dataset */

select count(distinct([hotel_id]))
from [dbo].[Oyo Hotels]

/* Nombre de villes dans le dataset */

select count(distinct([City]))
from [dbo].[City Hotels]

/* Nombre d'hôtels par ville */

select [City], count(distinct([hotel_id])) as Number_of_Hotels
from [dbo].[City Hotels]
group by ([City])
order by 2 desc

/* Création des colonnes : price, number_of_nights, rate */

alter table [dbo].[Oyo Hotels] 
add number_of_nights int

update [dbo].[Oyo Hotels]
set number_of_nights = DATEDIFF(dd,[check_in],[check_out])


alter table [dbo].[Oyo Hotels] 
add price float

update [dbo].[Oyo Hotels]
set price = [amount]-[discount]

alter table [dbo].[Oyo Hotels] 
add number_of_nights int 

alter table [dbo].[Oyo Hotels] 
add rate float

update [dbo].[Oyo Hotels]
set rate =  ROUND(IIF(([no_of_rooms] =1) , [price]/[number_of_nights] , [price]/[number_of_nights]/[no_of_rooms]),2)

/* Room rate moyen par ville */

select round(avg(rate),2)  as Avg_room_rate_by_city, city 
from[dbo].[Oyo Hotels] o
join [dbo].[City Hotels] c
on o.[hotel_id]= c.[Hotel_id]
group by city
order by 1 desc

/* Total des bookings du mois de Janvier, Février et Mars */

select city, count([booking_id]) no_of_booking_Jan_Feb_Mar
from [dbo].[Oyo Hotels] o
join [dbo].[City Hotels] c on o.[hotel_id]=c.[Hotel_id]
where [date_of_booking] like '2017-01-%%' or [date_of_booking] like  '2017-02-%%' or [date_of_booking] like  '2017-03-%%'
group by city 

/* Total des bookings du mois de Janvier, Février et Mars, triés par mois */

select count([booking_id]), [City], month([date_of_booking]) 
from [dbo].[Oyo Hotels] o
join [dbo].[City Hotels] c on o.[hotel_id]=c.[Hotel_id]
where month([date_of_booking]) between 1 and 3
group by month([date_of_booking]), [City]

/* Taux d'annulation par ville */

alter table [dbo].[Oyo Hotels]
add cancelled_booking int 

update [dbo].[Oyo Hotels]
set cancelled_booking = iif([status]= 'cancelled' , 1, 0) 

select city,  (convert(float, SUM([cancelled_booking]))/count([booking_id]))*100
from [dbo].[Oyo Hotels] o
join [dbo].[City Hotels] c on o.[hotel_id]=c.[Hotel_id] 
group by city
order by 2 desc


/* Nombre de jours de différence entre la réservation et le check-in */

alter table [dbo].[Oyo Hotels]
add date_diff int 

update [dbo].[Oyo Hotels]
set date_diff =  datediff(DD,[date_of_booking],[check_in])


select  count(*) ,date_diff
from [dbo].[Oyo Hotels]
group by date_diff
order by date_diff asc 

