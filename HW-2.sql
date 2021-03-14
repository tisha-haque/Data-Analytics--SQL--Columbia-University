/**Question 1**/

select idol_name as full_name, stage_name, dob
from Idols
where grp = 'BLACKPINK'
order by dob asc

/**Question 2**/

select stage_name
from idols 
where grp = ''
order by dob desc 
limit 7

/**Question 3**/
SELECT idol_id, stage_name, idol_name, dob,grp
from idols 
where grp like '%'|| ||'%'
order by grp, idol_name asc

/**Question 4**/

select song_name, rating
from songs 
where rating >=3
order by random()
limit 15 

/**Question 5**/

select *
from songs 
where artist ilike '%ic%'
order by dor desc 
limit 20

/**Question 6**/

select artist, song_name, rating, mod (cast(rating* date_part('month', dor) as int),11) + 1 as rating2
from songs 
where mod (cast(rating* date_part('month', dor) as int),11) + 1  = 11


/**Question 7**/


select distinct song_name, artist
from plays 
where date_part('hour', dop) between 11 and 16
and date(dop) between '2020-06-20' and '2020-09-21'
and date(dop) not between '2020-09-22' and '2020-12-20'




