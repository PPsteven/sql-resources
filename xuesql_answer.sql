-- SQL Lesson 1: select 查询 101
SELECT title
FROM movies;

SELECT director
FROM movies;

SELECT title, director
FROM movies;

SELECT title, year
FROM movies;

SELECT *
FROM movies;

SELECT title, id, Length_minutes
FROM movies;

-- SQL Lesson 2: 条件查询 (constraints) (Pt. 1)
SELECT *
FROM movies
WHERE id = 6;

SELECT *
FROM movies
WHERE Year BETWEEN 2000 AND 2010;

SELECT *
FROM movies
WHERE NOT Year BETWEEN 2000 AND 2010;

SELECT *
FROM movies
LIMIT 5;

SELECT *
FROM movies
WHERE Year >= 2010
	AND Length_minutes < 120;

-- SQL Lesson 3: 条件查询(constraints) (Pt. 2)
SELECT *
FROM movies
WHERE Title LIKE '%Toy Story%';

SELECT *
FROM movies
WHERE Director = 'John Lasseter';

SELECT *
FROM movies
WHERE Director != 'John Lasseter';

SELECT *
FROM movies
WHERE Title LIKE 'WALL%';

SELECT *
FROM movies
WHERE Year = 1998;

-- SQL Lesson 4: 查询结果Filtering过滤 和 sorting排序
SELECT DISTINCT Director
FROM movies
ORDER BY Director;

SELECT *
FROM movies
ORDER BY Year DESC
LIMIT 4;

SELECT *
FROM movies
ORDER BY Title
LIMIT 5;

SELECT *
FROM movies
ORDER BY Title
LIMIT 5, 5;

SELECT Title
FROM movies
WHERE Director = 'John Lasseter'
ORDER BY Length_minutes DESC
LIMIT 2, 1;

-- SQL Review: 复习 select 查询
-- 1
SELECT *
FROM north_american_cities
WHERE Country = 'Canada';

-- 2
SELECT *
FROM north_american_cities
WHERE Longitude < (
	SELECT Longitude
	FROM north_american_cities
	WHERE CITY = 'Chicago'
)
ORDER BY Longitude;

-- 3
SELECT *
FROM north_american_cities
WHERE Country = 'Mexico'
ORDER BY Population DESC
LIMIT 2;

-- 4
SELECT *
FROM north_american_cities
WHERE Country = 'United States'
ORDER BY Population DESC
LIMIT 2, 2;

-- SQL Lesson 6: 用joins进行多表联合查询
SELECT *
FROM movies
	INNER JOIN Boxoffice ON id = Movie_id;

SELECT *
FROM movies a
	INNER JOIN Boxoffice b ON a.Id = b.Movie_id
WHERE b.International_sales > b.Domestic_sales;

SELECT *
FROM movies a
	INNER JOIN Boxoffice b ON a.Id = b.Movie_id
ORDER BY b.rating DESC;

SELECT a.Director, b.International_sales
FROM movies a
	INNER JOIN Boxoffice b ON a.Id = b.Movie_id
ORDER BY b.International_sales DESC
LIMIT 1;

-- SQL Lesson 7: 外连接（OUTER joins）
SELECT DISTINCT building
FROM employees
WHERE building IS NOT NULL;

SELECT DISTINCT Building_name, ROLE
FROM Buildings
	LEFT JOIN employees ON building = building_name;

SELECT DISTINCT a.Building_name, a.Capacity
FROM Buildings a
	INNER JOIN employees b ON a.Building_name = b.building;

SELECT DISTINCT building, Capacity
FROM employees
	LEFT JOIN Buildings ON building = building_name
WHERE building IS NOT NULL;

-- SQL Lesson 8: 关于特殊关键字 NULLs
SELECT Name, Role
FROM employees
WHERE building IS NULL;

SELECT Building_name
FROM Buildings
	LEFT JOIN Employees ON building = building_name
WHERE name IS NULL;

-- SQL Lesson 9: 在查询中使用表达式
-- 1. 【计算】列出所有的电影ID,名字和销售总额(以百万美元为单位计算)
SELECT id, title, (Domestic_sales + International_sales) / 1000000 AS sales
FROM movies a
	LEFT JOIN boxoffice b ON a.id = b.movie_id;

-- 2.【计算】列出所有的电影ID,名字和市场指数(Rating的10倍为市场指数) ✓
SELECT id, title, Rating * 10
FROM movies a
	LEFT JOIN boxoffice b ON a.id = b.movie_id;

-- 3. 【计算】列出所有偶数年份的电影，需要电影ID,名字和年份 ✓
SELECT id, title, year
FROM movies
WHERE year % 2 = 0;

-- 4.【难题】John Lasseter导演的每部电影每分钟值多少钱,告诉我最高的3个电影名和价值就可以 ✓
SELECT a.title, (b.Domestic_sales + b.International_sales) / a.Length_minutes AS value
FROM movies a
	LEFT JOIN boxoffice b ON a.id = b.movie_id
WHERE director = 'John Lasseter'
ORDER BY value DESC
LIMIT 3;

-- SQL Lesson 10: 在查询中进行统计I (Pt. 1)
-- 1. 【统计】找出就职年份最高的雇员(列出雇员名字+年份） ✓
SELECT name, years_employed
FROM employees
ORDER BY years_employed DESC
LIMIT 1;

-- 2.【分组】按角色(Role)统计一下每个角色的平均就职年份 ✓
SELECT role, avg(years_employed) AS avg_years
FROM employees
GROUP BY role;

-- 3.【分组】按办公室名字总计一下就职年份总和 ✓
SELECT Building, sum(years_employed) AS avg_years
FROM employees
GROUP BY Building;

-- 4.【难题】每栋办公室按人数排名,不要统计无办公室的雇员
SELECT building, count(Role) AS people
FROM employees
WHERE building IS NOT NULL
GROUP BY building
ORDER BY people DESC;

-- SQL Lesson 11: 在查询中进行统计II (Pt. 2)
-- 1.【统计】统计一下Artist角色的雇员数量 ✓
SELECT count(Role)
FROM employees
WHERE role = 'Artist';

-- 2.【分组】按角色统计一下每个角色的雇员数量 ✓
SELECT role, count(Role)
FROM employees
GROUP BY role;

-- 3.【分组】算出Engineer角色的就职年份总计 ✓
SELECT sum(Years_employed)
FROM employees
WHERE role = 'Engineer';

-- 4.【难题】按角色分组算出每个角色按有办公室和没办公室的统计人数
--    列出角色，数量，有无办公室,注意一个角色如果部分有办公室，部分没有需分开统计 ✓
SELECT role
	, CASE 
		WHEN building IS NULL THEN '0'
		ELSE '1'
	END AS office_status, count(role)
FROM Employees
GROUP BY role, office_status;

-- SQL Lesson 12: 查询执行顺序
-- 1.【复习】统计出每一个导演的电影数量（列出导演名字和数量） ✓
SELECT director, count(*)
FROM movies
GROUP BY director;

-- 2.【复习】统计一下每个导演的销售总额(列出导演名字和销售总额)
SELECT a.director, sum(b.Domestic_sales + b.International_sales) AS sales_total
FROM movies a
	LEFT JOIN boxoffice b ON a.id = b.movie_id
GROUP BY director;

-- 3.【难题】按导演分组计算销售总额,求出平均销售额冠军（统计结果过滤掉只有单部电影的导演，
--    列出导演名，总销量，电影数量，平均销量)
SELECT a.director, sum(b.Domestic_sales + b.International_sales) AS sales_total
	, count(a.title)
	, avg(b.Domestic_sales + b.International_sales) AS avg_total
FROM movies a
	LEFT JOIN boxoffice b ON a.id = b.movie_id
GROUP BY director
HAVING count(a.title) > 1
ORDER BY avg_total DESC
LIMIT 1;

-- 4.【变态难】找出每部电影和单部电影销售冠军之间的销售差，列出电影名，销售额差额
WITH sales_info AS (
		SELECT a.title, b.Domestic_sales + b.International_sales AS sales
		FROM movies a
			LEFT JOIN boxoffice b ON a.id = b.movie_id
	)
SELECT title, (
		SELECT max(sales)
		FROM sales_info
	) - sales
FROM sales_info;