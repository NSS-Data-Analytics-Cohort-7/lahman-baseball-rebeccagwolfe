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

divide by the number 47 teams

measure max wins per year and world series that year? 

SELECT SUM(w), wswin, yearid, teamid
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
GROUP BY 

SELECT WSWin, teamid, yearid
FROM teams
WHERE wswin = 'Y' AND yearid BETWEEN 1970 AND 2016
ORDER BY yearid DESC;


SELECT MAX(W), teamid, yearid, 
FROM teams
WHERE  yearid BETWEEN 1970 AND 2016
GROUP BY yearid,teamid
ORDER BY MAX(w) DESC, yearid;




SELECT WSWin, teamid, yearid
FROM teams
WHERE wswin = 'Y' AND yearid BETWEEN 1970 AND 2016
ORDER BY yearid DESC;

SELECT subquery.wins
FROM subquery
WHERE teamid IN
(SELECT MAX(W) AS wins, teamid, yearid, wswin
FROM teams
WHERE  yearid BETWEEN 1970 AND 2016
GROUP BY yearid,teamid, wswin
ORDER BY wins DESC, yearid) AS subquery
WHERE subquery.wswin = 'Y'

SELECT MAX(W) AS wins, teamid, yearid, wswin
FROM teams
WHERE  yearid BETWEEN 1970 AND 2016
GROUP BY yearid,teamid, wswin
ORDER BY wins DESC, yearid



-- 46 teams won the world series between 1970 and 2016 
-- 1 world series per day. Out of 46 world series winners, how many of those winners also had the most wins that year?

SELECT w, teamid, yearid, wswin
FROM teams
WHERE  yearid BETWEEN 1970 AND 2016 AND wswin = 'Y'
ORDER BY w DESC, yearid
--Returns 46 rows

SELECT MAX(w),yearid
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
GROUP BY yearid
ORDER BY yearid
--Returns the 47 max scores for each year. but when I add in the teams column, it returns 1294 rows.

SELECT w, teamid, yearid
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
ORDER BY yearid


-- CTES joining on two seperate keys OR case when statements to count

WITH wins AS
(SELECT MAX(w) AS max_wins, yearid
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
GROUP BY yearid)

SELECT t.w, t.teamid, t.yearid, t.wswin
FROM teams AS t
INNER JOIN wins cte
ON cte.yearid = t.yearid AND cte.max_wins = t.w
WHERE t.wswin = 'Y'
ORDER BY t.w DESC, t.yearid


--      8. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.

-- park name, team name, average attendance 
-- average attendance = total attendance/number of games
-- only at parks where 10+ games were played
-- in 2016
     
     SELECT team, park, games, attendance
     FROM homegames
     WHERE year = 2016 AND games >= 10
     
     SELECT park
     FROM homegames
     WHERE year = 2016 AND WHERE park IN
    
SELECT park, SUM(attendance)/SUM(games) AS average_attendance
FROM homegames
WHERE park IN
    (SELECT park
     FROM homegames
     WHERE year = 2016
     GROUP BY park
     HAVING SUM(games) >=10)
GROUP BY park
ORDER BY SUM(attendance)/SUM(games) DESC
LIMIT 5;
--    Shows the top 5 parks with highest attendance  
-- "NYC21"	42622
-- "STL10"	41871
-- "SFO03"	39841
-- "PHI13"	36889
-- "DEN02"	35546
     SELECT *
     FROM parks
     
     SELECT p.park_name, SUM(attendance)/SUM(games) AS average_attendance
FROM homegames AS h
INNER JOIN parks AS p
USING (park)
WHERE park IN
    (SELECT park
     FROM homegames
     WHERE year = 2016
     GROUP BY park
     HAVING SUM(games) >=10)
GROUP BY p.park_name
ORDER BY SUM(attendance)/SUM(games) DESC
LIMIT 5;
     
-- "Yankee Stadium II"	42622
-- "Busch Stadium III"	41871
-- "AT&T Park"	        39841
-- "Citizens Bank Park"	36889
-- "Coors Field"	    35546
     
--      Try without a subquery
--      group by and order by are the only two clauses that you can referece the aliases that you give in the select statement. 
     
     SELECT p.park_name, team, SUM(attendance)/SUM(games) AS average_attendance
FROM homegames AS h
INNER JOIN parks AS p
USING (park)
WHERE park IN
    (SELECT park
     FROM homegames
     WHERE year = 2016
     GROUP BY park
     HAVING SUM(games) >=10)
GROUP BY p.park_name, team
ORDER BY SUM(attendance)/SUM(games) DESC
LIMIT 6;     
-- "Citizens Bank Park"	"TOR"	43357
-- "Yankee Stadium II"	"NYA"	42622
-- "AT&T Park"	        "CIN"	42310
-- "Busch Stadium III"	"SLN"	41871
-- "AT&T Park"	        "SFN"	39839
     
     
  SELECT DISTINCT(p.park_name), team, SUM(attendance)/SUM(games) AS average_attendance
FROM homegames AS h
INNER JOIN parks AS p
USING (park)
WHERE park IN
    (SELECT park
     FROM homegames
     WHERE year = 2016
     GROUP BY park
     HAVING SUM(games) >=10)
GROUP BY p.park_name, team
ORDER BY SUM(attendance)/SUM(games)
LIMIT 6;       
-- When I add in teams, it changes the list slightly..hmm. Does this mean there have been some switches of teams between parks?
  
     
--      To join team names to table:
SELECT teams.name, teams.teamid, teams.franchid, homegames.team
     FROM teams
     INNER JOIN homegames
     ON teams.franchid = homegames.team
     
SELECT SUM(attendance)/SUM(games), park
     FROM homegames
     WHERE park = 'LOS03'
     GROUP BY park
     
     SELECT SUM(attendance), park
     FROM homegames
     WHERE park = 'LOS03'
--      GROUP BY park
--      165512326 people attended this park 
     
     SELECT SUM(games), park
     FROM homegames
     WHERE park = 'LOS03'
     GROUP BY park
     
--      4714 games
    
--     165,512,325 attendance/4,714 games = 35,110 people/game at LOS03 park
  

