-- 1. What range of years for baseball games played does the provided database cover? 
1871 through 2016

SELECT debut
FROM people;


FROM teams;


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

SELECT p.namefirst, p.namelast, CAST(height AS NUMERIC), a.g_all, t.teamid, t.name
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

-- David Price at $245,553,888

SELECT p.namefirst, p.namelast, s.schoolname, CAST(CAST(salary AS NUMERIC)AS MONEY) AS total_salary
FROM people AS p
INNER JOIN salaries as sa
USING (playerid)
INNER JOIN collegeplaying AS c
USING (playerid)
INNER JOIN schools AS s
USING (schoolid)
WHERE s.schoolname = 'Vanderbilt University' AND namefirst = 'David'
ORDER BY total_salary DESC;

--Shows all the salaries that David earned. I noticed that each salary is listed three times...so then added distinc.

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

SELECT *
FROM teams;

SELECT *
FROM batting;
