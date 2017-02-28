-- What is the population of the US? (starts with 2, ends with 000)
select population
from country
where name = 'United States'

-- What is the area of the US? (starts with 9, ends with million square miles)
select surfacearea
from country
where name = 'United States'

-- List the countries in Africa that have a population smaller than 30,000,000 and a life expectancy of more than 45? (all 37 of them)
select name
from country
where
population < 3e+7
and
lifeexpectancy > 45
and
continent = 'Africa'

-- Which countries are something like a republic? (are there 122 or 143 countries or ?)
select name, governmentform
from country
where governmentform like '%Republic'

-- Which countries are some kind of republic and acheived independence after 1945?
select name, indepyear, governmentform
from country
where governmentform like '%Republic'
and
indepyear > 1945

-- Which countries acheived independence after 1945 and are not some kind of republic?
select name, indepyear, governmentform
from country
where governmentform not like '%Republic'
and
indepyear > 1945

-- ORDER BY
--
-- Which fifteen countries have the lowest life expectancy? highest life expactancy?
select name, lifeexpectancy
from country
where lifeexpectancy is not null
order by lifeexpectancy asc
limit 15;

select name, lifeexpectancy
from country
where lifeexpectancy is not null
order by lifeexpectancy desc
limit 15;

-- Which five countries have the lowest population density? highest population density?
select name,population,surfacearea, country.population / country.surfacearea as populationdensity
from country
where
population is not null
and
surfacearea is not null
order by populationdensity asc
limit 5;

select name,population,surfacearea, country.population / country.surfacearea as populationdensity
from country
where
population is not null
and
surfacearea is not null
order by populationdensity desc
limit 5;

-- Which is the smallest country, by are a and population? the 10 smallest countries, by area and population?
select name,population,surfacearea, country.population * country.surfacearea as total
from country
where
population is not null
and
surfacearea is not null
order by total asc
limit 1;

select name,population,surfacearea, country.population * country.surfacearea as total
from country
where
population is not null
and
surfacearea is not null
order by total asc
limit 10;



-- Which is the biggest country, by area and population? the 10 biggest countries, by area and population?

select name,population,surfacearea, country.population * country.surfacearea as total
from country
where
population is not null
and
surfacearea is not null
order by total desc
limit 1;

select name,population,surfacearea, country.population * country.surfacearea as total
from country
where
population is not null
and
surfacearea is not null
order by total desc
limit 10;

-- Of the smallest 10 countries, which has the biggest gnp?
with smallest as (
	select name,population,surfacearea, gnp, country.population * country.surfacearea as total
	from country
	where
	population is not null
	and
	surfacearea is not null
	order by total asc
	limit 10)

select name, gnp
from smallest
order by gnp desc
limit 1;

-- Of the smallest 10 countries, which has the biggest per capita gnp?
-- Could not divide by 0, removed countries with population 0 from our list

with smallest as (
	select name,population,surfacearea, gnp, country.population * country.surfacearea as total
	from country
	where
	population is not null
	and
	surfacearea is not null
	and
	population != 0
	order by total asc
	limit 10)

select name, population, gnp, gnp/population as perCap
from smallest

order by perCap desc;

-- Of the biggest 10 countries, which has the biggest gnp?

with biggest as (
	select name,population,surfacearea, gnp, country.population * country.surfacearea as total
	from country
	where
	population is not null
	and
	surfacearea is not null
	and
	population != 0
	order by total desc
	limit 10)

select name, population, gnp
from biggest

order by gnp desc;


-- Of the biggest 10 countries, which has the biggest per capita gnp?
with biggest as (
	select name,population,surfacearea, gnp, country.population * country.surfacearea as total
	from country
	where
	population is not null
	and
	surfacearea is not null
	and
	population != 0
	order by total desc
	limit 10)

select name, population, gnp, gnp/population as perCap
from biggest

order by perCap desc;

-- What is the sum of surface area of the 10 biggest countries in the world? The 10 smallest?
with biggest as (
	select name,population,surfacearea, gnp, country.population * country.surfacearea as total
	from country
	where
	population is not null
	and
	surfacearea is not null
	and
	population != 0
	order by total desc
	limit 10)

select SUM(surfacearea) as sum_of_surfacearea
from biggest;

with smallest as (
	select name,population,surfacearea, gnp, country.population * country.surfacearea as total
	from country
	where
	population is not null
	and
	surfacearea is not null
	and
	population != 0
	order by total asc
	limit 10)

select SUM(surfacearea) as sum_of_surfacearea
from smallest;



-- GROUP BY
--
-- How big are the continents in term of area and population?
select continent, sum(country.population*country.surfacearea) as total
from country
group by continent
order by total desc

-- Which region has the highest average gnp?
select continent, avg(country.gnp) as avg_gnp
from country
group by continent
order by avg_gnp desc

-- Who is the most influential head of state measured by population?
select headofstate, sum(population) as sumpop
from country
where headofstate != ''
group by headofstate
order by sumpop desc
limit 1;

-- Who is the most influential head of state measured by surface area?
select headofstate, sum(surfacearea) as sumarea
from country
where headofstate != ''
group by headofstate
order by sumarea desc
limit 1;

-- What are the most common forms of government? (hint: use count(*))
select governmentform, count(governmentform) as govcount
from country
group by governmentform
order by govcount desc

-- What are the forms of government for the top ten countries by surface area?
with topsurface as (
select name, surfacearea, governmentform
from country
order by surfacearea desc
limit 10)

select name, governmentform
from topsurface

-- What are the forms of government for the top ten richest nations? (technically most productive)
with topmoney as (
select name, gnp, governmentform
from country
order by gnp desc
limit 10)

select name, governmentform
from topmoney

-- What are the forms of government for the top ten richest per capita nations?
with topgnp as (
select name, governmentform, population, gnp, gnp/population as perCap
from country
where population !=0
order by perCap desc
limit 10)

select name, governmentform
from topgnp

--Which countries are in the top 5% in terms of area?
select name, surfacearea
from country
order by surfacearea desc
limit (select count(*)*0.05 from country) --Must put it in a select!

--Which is the 3rd most popular language?
select language, count(language) as langCount
from countrylanguage
group by language
order by langCount desc
offset 2 limit 1;

--How many cities are there in Chile?
with chile as (
select code, name
from country
where name = 'Chile')

select chile.name, count(city.name)
from city, chile
where countrycode = chile.code
group by chile.name

-- What is the total population in Asia\
select continent, sum(population)
from country
where continent = 'Asia'
group by continent

-- How many countries are in North America?
select continent, count(name)
from country
where continent = 'North America'
group by continent

-- Which counties gained their independence before 1963
select name, indepyear
from country
where indepyear is not null
and
indepyear < 1963
order by indepyear

-- What is the total population of all continents?
select sum(population) as World_Pop
from country

-- What is the average life expectancy for all continents? /per continent
select continent, avg(lifeexpectancy) as world_exp
from country
where lifeexpectancy is not null
group by continent


-- Which countries have the letter z in the name? How many?
select name
from country
where name like '%z%'

select count(name) as z_names
from country
where name like '%z%'

-- What is the age of Jamaica?
select 2017-indepyear as jamaica_age
from country
where name = 'Jamaica'

--What countries dont have an official language?
select country.name, countrylanguage.isofficial
from countrylanguage, country
where not isofficial
and
country.code = countrylanguage.countrycode
