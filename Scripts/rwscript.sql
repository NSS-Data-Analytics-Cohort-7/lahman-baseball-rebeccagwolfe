-- 1. What range of years for baseball games played does the provided database cover? 

SELECT MIN(debut), MAX(finalgame)
FROM people;
-- "1871-05-04"	"2017-04-03". 1871 through 2017

-- 2. Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?

SELECT playerid, batting.teamid, teams.name
FROM batting
INNER JOIN teams
ON batting.teamid = teams.teamidbr

SELECT namefirst, namelast, CAST(height AS NUMERIC), g
FROM people
INNER JOIN pitching
USING (playerid)
ORDER BY height

SELECT namefirst, namelast, CAST(height AS NUMERIC), g
FROM people
INNER JOIN fielding
USING (playerid)
ORDER BY height

-- Eddie Gaedel at 43 inches tall. He played in one game and 

  
SELECT people.namefirst, people.namelast, CAST(people.height AS NUMERIC), batting.g, teams.name
FROM people
INNER JOIN batting
USING (playerid)
LEFT JOIN teams
ON batting.teamid = teams.teamidbr
ORDER BY height

-- Returns the team id of SLA, but the name is null 

SELECT CONCAT(p.namefirst,' ', p.namelast) AS name, CAST(height AS NUMERIC), a.g_all, t.teamid, t.name
FROM people AS p
INNER JOIN appearances AS a
USING (playerid)
INNER JOIN teams AS t
ON t.teamid = a.teamid
ORDER BY height

--Eddie Gaedel played 1 game for the St. Louis Browns
   
-- 3. Find all players in the database who played at Vanderbilt University. Create a list showing each playerâ€™s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?

SELECT p.namefirst, p.namelast, s.schoolname, CAST(SUM(DISTINCT(CAST(salary AS NUMERIC)))AS MONEY) AS total_salary
FROM people AS p
INNER JOIN salaries as sa
USING (playerid)
INNER JOIN collegeplaying AS c
USING (playerid)
INNER JOIN schools AS s
USING (schoolid)
WHERE s.schoolname = 'Vanderbilt University' 
GROUP BY p.namefirst, p.namelast, s.schoolname
ORDER BY total_salary DESC;

--SHows the list of vanderbilt players with their salaries using distinct

SELECT p.namefirst, p.namelast, s.schoolname, CAST(SUM(CAST(salary AS NUMERIC))AS MONEY) AS total_salary
FROM people AS p
INNER JOIN salaries as sa
USING (playerid)
INNER JOIN collegeplaying AS c
USING (playerid)
INNER JOIN schools AS s
USING (schoolid)
WHERE s.schoolname = 'Vanderbilt University' AND namefirst = 'David'
GROUP BY p.namefirst, p.namelast, s.schoolname
ORDER BY total_salary DESC;

-- David Price at $245,553,88


SELECT p.namefirst, p.namelast, s.schoolname, CAST(CAST(salary AS NUMERIC)AS MONEY) AS total_salary
FROM people AS p
INNER JOIN salaries as sa
USING (playerid)
INNER JOIN collegeplaying AS c
USING (playerid)
INNER JOIN schools AS s
USING (schoolid)
WHERE s.schoolname = 'Vanderbilt University' AND namefirst = 'David'
ORDER BY sa.salary DESC;

--Shows all the salaries that David earned. I noticed that each salary is listed three times...so then added distinc.

SELECT p.namefirst, p.namelast, s.schoolname, CAST(CAST(salary AS NUMERIC)AS MONEY) AS total_salary, c.yearid
FROM people AS p
INNER JOIN salaries as sa
USING (playerid)
INNER JOIN collegeplaying AS c
USING (playerid)
INNER JOIN schools AS s
USING (schoolid)
WHERE s.schoolname = 'Vanderbilt University' AND namefirst = 'David'
ORDER BY c.yearid DESC;

-- This shows multiple salaries for each year. 

SELECT p.namefirst, p.namelast, s.schoolname, CAST(CAST(salary AS NUMERIC)AS MONEY) AS total_salary, c.yearid
FROM people AS p
INNER JOIN salaries as sa
USING (playerid)
LEFT JOIN collegeplaying AS c
USING (playerid)
LEFT JOIN schools AS s
USING (schoolid)
WHERE s.schoolname = 'Vanderbilt University' AND namefirst = 'David'
ORDER BY c.yearid DESC;

-- Tried doing left joins intead - still gave 21 different salaries from 2005 to 2007.

SELECT p.namefirst, p.namelast, s.schoolname, CAST(CAST(salary AS NUMERIC)AS MONEY) AS total_salary, sa.yearid
FROM people AS p
INNER JOIN salaries as sa
USING (playerid)
LEFT JOIN collegeplaying AS c
USING (playerid)
LEFT JOIN schools AS s
USING (schoolid)
WHERE s.schoolname = 'Vanderbilt University' AND namefirst = 'David'
ORDER BY sa.yearid DESC;


-- Used year from salaries table. Same numbers, but years from 2010 to 2016.

SELECT *
FROM schools

SELECT *
FROM salaries

SELECT *
FROM salaries
INNER JOIN people
USING (playerid)
WHERE namefirst = 'David' AND namelast = 'Price'

SELECT *
FROM teams

SELECT CAST(CAST(SUM(salary) AS NUMERIC) AS MONEY), playerid
FROM salaries
INNER JOIN people
USING (playerid)
WHERE playerid = 'priceda01'
GROUP BY playerid
ORDER BY SUM(salary) DESC

-- $81,851,296.00 priceda01

SELECT *
FROM teams
WHERE teamid = 'TBA'

------------------------------------------------------------------
SELECT p.namefirst, p.namelast, s.schoolname, CAST(SUM(DISTINCT(CAST(salary AS NUMERIC)))AS MONEY) AS total_salary
FROM people AS p
INNER JOIN salaries as sa
USING (playerid)
INNER JOIN collegeplaying AS c
USING (playerid)
INNER JOIN schools AS s
USING (schoolid)
WHERE s.schoolname = 'Vanderbilt University'
GROUP BY p.namefirst, p.namelast, s.schoolname
ORDER BY total_salary DESC;
------------------------------------------------------------------
-- "David"	"Price"	"Vanderbilt University"	81851296



-- 4. Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.
    
    SELECT SUM(po) AS putouts,
    CASE WHEN pos = 'OF' THEN 'Outfield'
    WHEN pos = 'SS' THEN 'Infield'
    WHEN pos = '1B' THEN 'Infield'
    WHEN pos = '2B' THEN 'Infield'
    WHEN pos = '3B' THEN 'Infield'
    WHEN pos = 'P' THEN 'Battery'
    WHEN pos = 'C' THEN 'Battery' END AS position
FROM fielding
WHERE yearid = 2016
    GROUP BY position
    
-- Can also do it this way: when pos IN ('OF') THEN 'outfield'
    
-- 41424	"Battery"
-- 58934	"Infield"
-- 29560	"Outfield"
   
-- 5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?


SELECT COUNT(b.hr) AS homeruns, AVG(p.so) AS strikeouts, ((p.yearid/10)*10) AS decade, b.g
FROM batting AS b
INNER JOIN pitching AS p
USING (playerid)
WHERE ((p.yearid/10)*10) > 1920
GROUP BY b.g, decade;

SELECT ROUND(AVG(p.so),2) AS strikeouts, ((p.yearid/10)*10) AS decade, p.g
FROM batting AS b
INNER JOIN pitching AS p
USING (playerid)
WHERE ((p.yearid/10)*10) > 1920
GROUP BY p.g, decade;

SELECT ROUND(AVG(so),2) AS strikeouts, ((yearid/10)*10) AS decade, g
FROM pitching
WHERE ((yearid/10)*10) > 1920
GROUP BY g, decade;

SELECT ROUND(AVG(so),2) AS strikeouts, ((yearid/10)*10) AS decade, g, teamid, yearid
FROM teams
WHERE ((yearid/10)*10) > 1920
GROUP BY g, decade, teamid, yearid
ORDER BY yearid;


SELECT ROUND(AVG(so),2) AS average_strikeouts, g, ((yearid/10)*10) AS decade
FROM teams
GROUP BY g, decade
ORDER BY decade DESC;


SELECT (CAST(so AS NUMERIC)/CAST(g AS NUMERIC)) AS sog, teamid
FROM teams
ORDER BY teamid

SELECT (CAST(so AS NUMERIC)/CAST(g AS NUMERIC)) AS sog, teamid, yearid
FROM teams
ORDER BY teamid, yearid

two teams per game
total games from teams - 

SELECT *
FROM teams

-- WIth Rob's help, discovered there are two teams that play each game. If I'm using the teams table, the number of strikeouts per game should be doubled if we're considering both teams. 

SELECT SUM(g), teamid
FROM teams
GROUP BY teamid

SELECT ROUND(AVG((CAST(so AS NUMERIC)/CAST(g AS NUMERIC))),2)*2 AS strikeouts_per_game, ((yearid/10)*10) AS decade
FROM teams
WHERE yearid > 1920
GROUP BY decade
ORDER BY decade

SELECT ROUND(AVG((CAST(so AS NUMERIC)/CAST(g AS NUMERIC))),2) AS strikeouts_per_game, ((yearid/10)*10) AS decade
FROM teams
WHERE yearid > 1920
GROUP BY decade
ORDER BY decade

----------------------------------------------------------------------------------------------------------------
SELECT ROUND((AVG((CAST(so AS NUMERIC)/CAST(g AS NUMERIC)))*2),2) AS strikeouts_per_game, ((yearid/10)*10) AS decade
FROM teams
WHERE yearid > 1920
GROUP BY decade
ORDER BY decade
-- Final query (hopefully) for strikouts

SELECT ROUND(AVG((CAST(hr AS NUMERIC)/CAST(g AS NUMERIC))),2)*2 AS homeruns_per_game, ((yearid/10)*10) AS decade
FROM teams
WHERE yearid > 1920
GROUP BY decade
ORDER BY decade
--Homeruns. Multiplied by 2. The average increases each year. 
------------------------------------------------------------------------------------------------------------------

-- use teams table instead of batting or pitching. You don't need to join anything. Each team plays about 154 games/year. 

-- 6. Find the player who had the most success stealing bases in 2016, where __success__ is measured as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted _at least_ 20 stolen bases.


SELECT SUM(sb) AS stolen_bases, SUM(cs) AS caught_stealing, (SUM(sb) + SUM(cs)) AS total_attempts, (SUM(sb)/(SUM(sb) + SUM(cs))) AS percentage
FROM batting
WHERE yearid = 2016 
ORDER BY stolen_bases DESC


-----------------------------------------------------------------------------------------------------------------
SELECT (sb+cs) AS attempts, ROUND(CAST(sb AS NUMERIC)/(CAST(sb AS NUMERIC)+CAST(cs AS NUMERIC)), 2) AS percentage, playerid, CONCAT(namefirst,' ', namelast)
FROM batting
INNER JOIN people
USING (playerid)
WHERE yearid = 2016 AND sb <> 0 AND (sb+cs) > 20
GROUP BY playerid, sb, cs, attempts, namefirst, namelast
ORDER BY percentage DESC
------------------------------------------------------------------------------------------------------------------


-- 7.  From 1970 â€“ 2016, what is the largest number of wins for a team that did not win the world series? What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion â€“ determine why this is the case. Then redo your query, excluding the problem year. How often from 1970 â€“ 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?

SELECT W, WSWin, teamid, yearid
FROM teams
WHERE wswin = 'N' AND yearid BETWEEN 1970 AND 2016 
ORDER BY w DESC;
-- 116 wins from SEA in 2001. When I filter out the NULLS (OR wswin IS NULL), it treats my BETWEEN statement as OR. See below where it includes 1904. 

SELECT W, WSWin, teamid, yearid
FROM teams
WHERE wswin = 'N' AND yearid BETWEEN 1970 AND 2016 OR wswin IS NULL
ORDER BY w DESC;

SELECT MAX(W)
FROM teams
WHERE wswin = 'N' AND yearid BETWEEN 1970 AND 2016

SELECT MIN(W)
FROM teams
WHERE wswin = 'Y' AND yearid BETWEEN 1970 AND 2016
--Returns 63 wins

SELECT w, teamid, yearid
FROM teams
WHERE wswin = 'Y' AND yearid BETWEEN 1970 AND 2016 AND yearid <> 1981
ORDER BY w
--83 wins from SLN in 2006 (eliminating year 1981)

-- How often from 1970 â€“ 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?

WITH wins AS
(SELECT MAX(w) AS max_wins, yearid
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
GROUP BY yearid),

ws AS
(SELECT w, teamid, yearid, wswin
FROM teams
WHERE  yearid BETWEEN 1970 AND 2016 AND wswin = 'Y'
ORDER BY w DESC, yearid)

SELECT ROUND(CAST(COUNT(ws.*) AS NUMERIC)/CAST(2016-1970 AS NUMERIC)*100,0) AS percentage
FROM wins
INNER JOIN ws
ON ws.yearid = wins.yearid AND ws.w = wins.max_wins

--Can be done using CTES joining on two seperate keys OR case when statements to count

--      8. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.
     
--------------------------------------------------------------------------------------------------------------------
SELECT p.park_name, t.name, SUM(h.attendance)/SUM(h.games) AS average_attendance
FROM homegames AS h
INNER JOIN parks AS p
USING(park)
LEFT JOIN teams AS t
ON h.team = t.teamid AND p.park_name = t.park
WHERE year = 2016
GROUP BY p.park_name, t.name
HAVING SUM(games) >=10
ORDER BY SUM(h.attendance)/SUM(h.games) DESC
LIMIT 5;
-- Top 5: 
-- "Dodger Stadium"	"Los Angeles Dodgers"	45719
-- "Busch Stadium III"	"St. Louis Cardinals"	42524
-- "Rogers Centre"	    "Toronto Blue Jays"	    41877
-- "AT&T Park" 	    "San Francisco Giants"	41546
-- "Wrigley Field"	    "Chicago Cubs"	        39906

SELECT p.park_name, t.name, SUM(h.attendance)/SUM(h.games) AS average_attendance
FROM homegames AS h
INNER JOIN parks AS p
USING(park)
LEFT JOIN teams AS t
ON h.team = t.teamid AND p.park_name = t.park
WHERE year = 2016
GROUP BY p.park_name, t.name
HAVING SUM(games) >=10
ORDER BY SUM(h.attendance)/SUM(h.games)
LIMIT 5;


-- Bottom 5: gives me Tropicana Field twice if I list the team name: 

-- "Tropicana Field"	                "Tampa Bay Devil Rays"	15878
-- "Tropicana Field"	                      "Tampa Bay Rays"	15878
-- "Oakland-Alameda County Coliseum"	    "Oakland Athletics"	18784
-- "Progressive Field"                 	"Cleveland Indians"	19650
-- "Marlins Park"	                            "Miami Marlins"	21405

SELECT p.park_name, team, SUM(attendance)/SUM(games) AS average_attendance
FROM homegames 
INNER JOIN parks AS p
USING(park)
WHERE year = 2016
GROUP BY p.park_name, team
HAVING SUM(games) >=10
ORDER BY SUM(attendance)/SUM(games)
LIMIT 5;

-------------------------------------------------------------------------------------------------------------------
     
-- 9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? Give their full name and the teams that they were managing when they won the award.

---------------------------------------------------------------------------------------------------------------------
WITH national_league (playerid, lgid, awardid)  AS 
(SELECT playerid, lgid, awardid
FROM awardsmanagers
WHERE awardid = 'TSN Manager of the Year' AND lgid = 'NL'
ORDER BY playerid)

SELECT CONCAT(p.namefirst,' ', p.namelast), a.playerid, a.lgid, n.lgid, a.awardid, a.yearid, m.teamid, t.name
FROM awardsmanagers AS a
INNER JOIN national_league AS n
USING (playerid)
LEFT JOIN people AS p
USING (playerid)
LEFT JOIN managers AS m
USING (playerid, yearid)
LEFT JOIN teams AS t
USING (teamid, yearid)
WHERE a.awardid = 'TSN Manager of the Year' AND a.lgid = 'AL'
ORDER BY a.playerid
-------------------------------------------------------------------------------------------------------------------
WITH nl AS 
(SELECT a.playerid, a.lgid, a.awardid, a.yearid, m.teamid
FROM awardsmanagers AS a
INNER JOIN managers AS m
WHERE a.awardid = 'TSN Manager of the Year' AND a.lgid = 'NL'
ORDER BY a.playerid),

al AS 
(SELECT a.playerid, a.lgid, a.awardid, a.yearid, m.teamid
FROM awardsmanagers AS a
INNER JOIN managers AS m
USING (playerid, yearid)
WHERE a.awardid = 'TSN Manager of the Year' AND a.lgid = 'AL'
ORDER BY a.playerid)

SELECT CONCAT(p.namefirst,' ', p.namelast), al.playerid, al.lgid, al.awardid, al.yearid, nl.playerid, nl.lgid, nl.awardid, nl.yearid, al.teamid, nl.teamid
FROM nl
INNER JOIN al
USING (playerid)
LEFT JOIN people AS p
USING (playerid)
-----------------------------------------------------------------------------------------------


WITH nl AS 
(SELECT a.playerid, a.lgid, a.awardid, a.yearid, m.teamid
FROM awardsmanagers AS a
INNER JOIN managers AS m
USING (playerid, yearid)
WHERE a.awardid = 'TSN Manager of the Year' AND a.lgid = 'NL'
ORDER BY a.playerid),

al AS 
(SELECT a.playerid, a.lgid, a.awardid, a.yearid, m.teamid
FROM awardsmanagers AS a
INNER JOIN managers AS m
USING (playerid, yearid)
WHERE a.awardid = 'TSN Manager of the Year' AND a.lgid = 'AL'
ORDER BY a.playerid)

SELECT CONCAT(p.namefirst,' ', p.namelast), al.playerid, al.lgid, al.awardid, al.yearid, nl.playerid, nl.lgid, nl.awardid, nl.yearid, al.teamid, nl.teamid
FROM nl
INNER JOIN al
USING (playerid)
LEFT JOIN people AS p
USING (playerid)
-----------------------------------------------------------------------------------------------------------------
TRY WITH UNION

WITH nl AS 
(SELECT a.playerid, a.lgid, a.awardid, a.yearid, m.teamid
FROM awardsmanagers AS a
INNER JOIN managers AS m
USING (playerid, yearid)
WHERE a.awardid = 'TSN Manager of the Year' AND a.lgid = 'NL'
ORDER BY a.playerid),

al AS 
(SELECT a.playerid, a.lgid, a.awardid, a.yearid, m.teamid
FROM awardsmanagers AS a
INNER JOIN managers AS m
USING (playerid, yearid)
WHERE a.awardid = 'TSN Manager of the Year' AND a.lgid = 'AL'
ORDER BY a.playerid)

SELECT nl.playerid, nl.lgid, nl.awardid, nl.yearid, nl.teamid
FROM nl
UNION
SELECT al.playerid, al.lgid, al.awardid, al.yearid, al.teamid
FROM al

-- Didn't work with union for me. 

-- -- 10. Find all players who hit their career highest number of home runs in 2016. Consider only players who have played in the league for at least 10 years, and who hit at least one home run in 2016. Report the players' first and last names and the number of home runs they hit in 2016.

SELECT CONCAT(namefirst,' ', namelast), CAST(debut AS date)
FROM people
WHERE CAST(debut AS date) <= '2006-12-31'
-- players who've played for at least 10 years: 16633 players 


SELECT COUNT(DISTINCT(playerid))
FROM batting
WHERE yearid <2016
--Distinct: 18657

SELECT MAX(hr), playerid
FROM batting
WHERE yearid <2016
GROUP BY playerid
ORDER BY MAX(hr) DESC
--18657. checking to make sure the MAX function worked the way I wanted it to.

WITH homeruns1 AS
(SELECT MAX(hr) AS other_year_hr, playerid
FROM batting
WHERE yearid <2016 and hr >=1
GROUP BY playerid
ORDER BY MAX(hr) DESC), 

homeruns2 AS
(SELECT playerid, hr, yearid
FROM batting 
WHERE yearid = 2016 AND hr >=1
ORDER BY hr DESC)

SELECT playerid, hr, other_year_hr, CONCAT(namefirst,' ', namelast), CAST(debut AS date),
CASE WHEN hr >= other_year_hr THEN 'max2016' WHEN hr < other_year_hr THEN 'nomax' END AS maxhomerun
FROM homeruns1
RIGHT JOIN homeruns2
USING (playerid)
INNER JOIN people
USING (playerid)
WHERE CAST(debut AS date) <= '2006-12-31'
ORDER BY maxhomerun
--gives me 7 players
---------------------------------------------------------------------------------------------------------------------
WITH homeruns1 AS
(SELECT MAX(hr) AS other_year_hr, playerid
FROM batting
WHERE yearid <2016 and hr >=1
GROUP BY playerid
ORDER BY MAX(hr) DESC), 

homeruns2 AS
(SELECT playerid, hr, yearid
FROM batting 
WHERE yearid = 2016 AND hr >=1
ORDER BY hr DESC)

SELECT hr, CONCAT(namefirst,' ', namelast),
CASE WHEN hr >= other_year_hr THEN 'max2016' WHEN hr < other_year_hr THEN 'nomax' END AS maxhomerun
FROM homeruns1
RIGHT JOIN homeruns2
USING (playerid)
INNER JOIN people
USING (playerid)
WHERE CAST(debut AS date) <= '2006-12-31'
ORDER BY maxhomerun
LIMIT 7;
-- Query that shows only homeruns, name, and whether they got their career high in 2016 or not.
----------------------------------------------------------------------------------------------------------------------