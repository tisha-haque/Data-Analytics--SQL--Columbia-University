/*  QUESTION 1 
 * --------------------
 * (5 points) Provide the SQL statement that returns from the table 'plyrs', the club,
 *  number_of_players, and total_goals_scored (sum of gls) for every club.
 *  Order the results by total_goals_scored (hi to lo) and then 
 * number_of_players (lo to hi).*/
 
  
 select club, count(plyr_nm) as number_of_players, sum(gls) as total_goals_scored
 from plyrs
 group by club
 order by sum(gls) desc, count(plyr_nm) asc
 
  /* QUESTION 2 (10 points)
 * --------------------
 * Provide the SQL statement that returns from the table 'plyrs', the
 * primary_postion (pos1), avg_height, and avg_weight for all the primary positions (pos1).
 * Order the results by the number of players occupying that position as
 * the primary position (lo to hi).
 */
 
 select pos1, avg(ht) as avg_height, avg(wt) as avg_weight, count (pos1)
 from plyrs
 group by pos1
 order by count (pos1) asc
 
 
 /*test */
 
 select pos1
 from plyrs
 group by pos1
 order by count (pos1) asc
 
/*
 * QUESTION 3 (15 points)
 * --------------------
 *
 * Provide the SQL statement that returns from the table 'plyrs', the club
 * and the pk_pct of all qualifying players from the given club.
 * To qualify as a player, he must have attempted at least two penalty
 * kicks during the season. Do not display the club if it has no qualifying
 * players.
 *
 *   pk_pct = sum of pk / sum of pka (round to 2 dp)
 *
 * Order the results by pk_pct (hi to lo) and then by club (A to Z).
 */
 
 
 select club,sum(pk),sum(pka),round ((sum(pk)/sum(pka)) :: decimal, 2) as pk_pct
 from plyrs
 where pka >= 2
 group by club
 order by pk_pct desc, club asc
 
 
 /*
 * QUESTION 4 (15 points)
 * --------------------
 *
 * Provide the SQL statement that returns from the table 'plyrs'
 * the year_of_birth and minp_matp for all players with dob's within
 * the given year. Each player must also have been issued at least 
 * 5 yellow cards (crdy). Order the results by year_of_birth (lo to hi).
 *
 *   minp_matp = total minp / total matp (round to 1 dp)
 */

 
 select date_part('year', dob) as year_of_birth, round(cast(sum(minp)/sum(matp) as numeric), 2) as minp_matp
 from plyrs
 where crdy >= 5
 group by date_part('year', dob)
 order by year_of_birth asc
 
 
  select date_part('year', dob) as year_of_birth, sum(minp)/sum(matp) as minp_matp
 from plyrs
 where crdy >= 5
 group by date_part('year', dob)
 order by minp_matp asc
 
 
 
 /*
 * QUESTION 5 (15 points)
 * --------------------
 *
 * Provide the SQL statement that returns from the table 'sched',
 * the week, home, away, score (formatted as gls_h - gls_a) for the 
 * fixtures with the combined goals (gls_h + gls_a) greater than the
 * average combined goals for all fixtures.
 *
 * For example, let's say the average combined goals for all fixtures
 * is 3.0. The final output should look something like:
 *
 *   week      home       away     score
 *   ----   --------- ------------ -----
 *   1      Fulham    Arsenal      0 - 3
 */

 
 select fix_wk as the_week,club_h as home,club_a as away, ((gls_h) || ' - ' || (gls_a)) as score
 from sched
 where ((gls_h)+(gls_a)) > (select avg(gls_h+gls_a) from sched)
 
 
 
 
/*
 * QUESTION 6 (20 points)
 * --------------------
 *
 * Provide the SQL statement that returns from the table 'clubs'
 * the ten stadiums that are closest in distance to the centroid
 * of all the stadiums. The centroid is the location of the average
 * latitude and longitude of all the stadiums. The distance between 
 * two stadiums is calculated as:
 *
 *   distance = sqrt((lat1 - lat2)^2 + (lng1 - lng2)^2)
 *
 *		where stadium1 has coordinates (lat1, lng1)
 *          stadium2 has coordinates (lat2, lng2)
 *
 * Include stadium and dist_from_centroid in the final output
 * with the results ordered by the dist_from_centroid (lo to hi).
 */

-- START ANSWER --

 select stdm,  
 sqrt((lat - (select avg(lat) from clubs))^2 + (lng - (select avg(lng) from clubs) )^2) as distance
 from clubs 
 group by stdm, lat, lng
 order by distance asc
 limit 10


-- END ANSWER --

-------------------------------------------------------------------------------

/*
 * QUESTION 7 (20 points)
 * --------------------
 *
 * Provide the SQL statement that will produce the league standings
 * for the 2020-2021 EPL season. The output must contain the columns:
 *
 *   Club, Pts
 *
 *   where Club = name of club
 *         Pts = total points for the season (= 3 * Wins + Draws)
 *
 *  The table must be ordered by pts (hi to lo) and then by club (Z to A).
 */

-- START ANSWER --

 
select d.club, sum (pts) points
from (

select a.club, 3*n pts
from  

(				
select club_h as club, count (*) n
from sched
where gls_h > gls_a
group by club_h
) a


union

select b.club, n pts 
from
(
select club_h as club, count (*) n
from sched
where gls_h = gls_a
group by club_h
)b

union

select c.club, 3*n pts
from 
(
select club_h as club, count (*) n
from sched
where gls_h < gls_a
group by club_h
) c

union

select z.club, n pts
from 
(
select club_h as club, count (*) n
from sched
where gls_h = gls_a
group by club_h
) z)  d
 
group by d.club
 
 
 
 
 
 
 
 
select x.club, x.wins , x.draws from
((select wt.club as club, count(wt.club) as wins from (
select club_h as club,gls_h,gls_a from sched
where gls_h > gls_a 
union
select club_a as club, gls_h, gls_a from sched
where gls_a > gls_h) w
group by club) wt
inner join 
(select dt.club as club, count(dt.club) as draws  from (
select club_h as club,gls_h,gls_a from sched
where gls_h = gls_a 
union
select club_a as club, gls_h, gls_a from sched
where gls_a = gls_h) d
group by club) dt
on wt.club = dt.club) x
group by x.club 

select club, count(club) as draws  from (
select club_h as club,gls_h,gls_a from sched
where gls_h = gls_a 
union
select club_a as club, gls_h, gls_a from sched
where gls_a = gls_h) d
group by club



select club_h from sched
where gls_h = gls_a 
union
select club_a from sched
where gls_a = gls_h

-- END ANSWER --
 

