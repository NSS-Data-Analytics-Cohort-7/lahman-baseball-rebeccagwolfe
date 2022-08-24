-- 1. What range of years for baseball games played does the provided database cover? 
1871 through 2016

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

SELECT p.namefirst, p.namelast, t.teamid, t.name
FROM people AS p
INNER JOIN appearances AS a
USING (playerid)
INNER JOIN teams AS t
ON t.teamid = a.teamid
ORDER BY t.name DESC;

SELECT name
FROM teams
ORDER BY name DESC;

-- Vanderbilt University not listed in teams table. Schools, duh. 

SELECT p.namefirst, p.namelast, s.schoolname, sa.salary
FROM people AS p
INNER JOIN salaries as sa
USING (playerid)
INNER JOIN collegeplaying AS c
USING (playerid)
INNER JOIN schools AS s
USING (schoolid)
WHERE s.schoolname = 'Vanderbilt University'
ORDER BY sa.salary DESC;

-- 4. Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.

SELECT COUNT(playerid) AS players_per_position,
    CASE WHEN pos = 'OF' THEN 'Outfield'
    WHEN pos = 'SS' THEN 'Infield'
    WHEN pos = '1B' THEN 'Outfield'
    WHEN pos = '2B' THEN 'Outfield'
    WHEN pos = '3B' THEN 'Outfield'
    WHEN pos = 'P' THEN 'Battery'
    WHEN pos = 'C' THEN 'Battery'
    ELSE 'NULL' END AS position
FROM fielding
    GROUP BY position
    
    SELECT COUNT(playerid) AS players_per_position, PO
    CASE WHEN pos = 'OF' THEN 'Outfield'
    WHEN pos = 'SS' THEN 'Infield'
    WHEN pos = '1B' THEN 'Outfield'
    WHEN pos = '2B' THEN 'Outfield'
    WHEN pos = '3B' THEN 'Outfield'
    WHEN pos = 'P' THEN 'Battery'
    WHEN pos = 'C' THEN 'Battery'
    ELSE 'NULL' END AS position
FROM fielding
    GROUP BY position, PO
    
    
    

