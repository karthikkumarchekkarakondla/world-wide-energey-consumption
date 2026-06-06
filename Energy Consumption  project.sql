create database energey_cosumption;
use energey_cosumption;
-- 1. country table
CREATE TABLE country (
    CID VARCHAR(10) PRIMARY KEY,
    Country VARCHAR(100) UNIQUE
);
SELECT * FROM COUNTRY;
-- 2. emission_3 table
CREATE TABLE emission_3 (
    country VARCHAR(100),
    energy_type VARCHAR(50),
    year INT,
    emission INT,
    per_capita_emission DOUBLE,
    FOREIGN KEY (country) REFERENCES country(Country)
);
SELECT * FROM EMISSION_3;
-- 3. population table
CREATE TABLE population (
    countries VARCHAR(100),
    year INT,
    Value DOUBLE,
    FOREIGN KEY (countries) REFERENCES country(Country)
);
SELECT * FROM POPULATION;
-- 4. production table
CREATE TABLE production (
    country VARCHAR(100),
    energy VARCHAR(50),
    year INT,
    production INT,
    FOREIGN KEY (country) REFERENCES country(Country)
);
SELECT * FROM PRODUCTION;
-- 5. gdp_3 table
CREATE TABLE gdp_3 (
    Country VARCHAR(100),
    year INT,
    Value DOUBLE,
    FOREIGN KEY (Country) REFERENCES country(Country)
);
SELECT * FROM GDP_3;
-- 6. consumption table
CREATE TABLE consumption (
    country VARCHAR(100),
    energy VARCHAR(50),
    year INT,
    consumption INT,
    FOREIGN KEY (country) REFERENCES country(Country)
);
SELECT * FROM CONSUMPTION;
SELECT * FROM country_3;
SELECT * FROM emission_3;
sELECT * FROM population_3;
sELECT * FROM production_3;
sELECT * FROM gdp_3;
sELECT * FROM consum_3;
-- 1.What is the total emission per country for the most recent year available?
SELECT 
country,
SUM(emission) AS total_emission
FROM emission_3
WHERE year = (SELECT MAX(year) FROM emission_3)
GROUP BY country
ORDER BY total_emission DESC;
-- 2.What are the top 5 countries by GDP in the most recent year?
SELECT 
country,
Value AS GDP
FROM gdp_3
WHERE year = (
    SELECT MAX(year) FROM gdp_3
)
ORDER BY Value DESC
LIMIT 5;
-- 3. Which energy types contribute most to emissions across all countries?
SELECT energy_type, SUM(emission)
FROM emission_3
GROUP BY energy_type;
-- 4. How have global emissions changed year over year?
SELECT year, SUM(emission)
FROM emission_3
GROUP BY year;
-- 5. What is the trend in GDP for each country over the given years?
SELECT country, year, Value
FROM gdp_3
ORDER BY country, year;
-- 6.How has population growth affected total emissions in each country?
SELECT e.country, e.year, SUM(emission), p.Value
FROM emission_3 e
JOIN population_3 p
ON e.country = p.countries AND e.year = p.year
GROUP BY e.country, e.year, p.Value;
-- 7. Has energy consumption increased or decreased over the years for major economies?
SELECT country,
       year,
       SUM(consumption) AS total_consumption
FROM consum_3
WHERE country IN (
  -- replace with actual top country names from your data
  'United States','China','India','Germany','Japan'
)
GROUP BY country, year
ORDER BY country, year desc;
-- 8.What is the average yearly change in emissions per capita for each country?
SELECT e.country, e.year, emission / p.Value
FROM emission_3 e
JOIN population_3 p
ON e.country = p.countries AND e.year = p.year;
-- 9.What is the emission-to-GDP ratio for each country by year?
sELECT e.country,
       e.year,
       SUM(e.emission) AS total_emission,
       g.Value AS gdp,
       ROUND(SUM(e.emission) / g.Value, 4) AS emission_per_gdp
FROM emission_3 e
JOIN gdp_3 g
  ON e.country = g.Country
  AND e.year = g.year
GROUP BY e.country, e.year, g.Value
ORDER BY e.country, e.year;
-- 10. What is the energy consumption per capita for each country over the last decade?
SELECT c.country, c.year,
       SUM(c.consumption)/p.Value AS consumption_per_capita
FROM consum_3 c
JOIN population_3 p
ON c.country = p.countries AND c.year = p.year
WHERE c.year >= (SELECT MAX(year)-10 FROM consum_3)
GROUP BY c.country, c.year, p.Value;
-- 11.How does energy production per capita vary across countries?
SELECT pr.country,
       pr.year,
       SUM(pr.production) AS total_production,
       p.Value AS population,
       ROUND(SUM(pr.production) / p.Value, 4) AS production_per_capita
FROM production_3 pr
JOIN population_3 p
  ON pr.country = p.countries
  AND pr.year = p.year
GROUP BY pr.country, pr.year, p.Value
ORDER BY production_per_capita DESC;
-- 12. Which countries have the highest energy consumption relative to GDP?
SELECT c.country,
       c.year,
       SUM(c.consumption) AS total_consumption,
       g.Value AS gdp,
       ROUND(SUM(c.consumption) / g.Value, 4) AS consumption_per_gdp
FROM consum_3 c
JOIN gdp_3 g
  ON c.country = g.Country
  AND c.year = g.year
GROUP BY c.country, c.year, g.Value
ORDER BY consumption_per_gdp DESC;
-- 13.What is the correlation between GDP growth and energy production growth?
SELECT g.Country,
       g.year,
       g.Value AS gdp,
       SUM(p.production) AS total_production
FROM gdp_3 g
JOIN production_3 p
  ON g.Country = p.country
  AND g.year = p.year
GROUP BY g.Country, g.year, g.Value
ORDER BY g.Country, g.year;
-- 14.What are the top 10 countries by population and how do their emissions compare?
SELECT p.countries, p.Value, SUM(e.emission)
FROM population_3 p
JOIN emission_3 e
ON p.countries = e.country AND p.year = e.year
GROUP BY p.countries, p.Value
ORDER BY p.Value DESC
LIMIT 10;
-- 15.Which countries have improved (reduced) their per capita emissions the most over the last decade?
SELECT e.country,
MIN(emission / p.Value),
MAX(emission / p.Value)
FROM emission_3 e
JOIN population_3 p
ON e.country = p.countries AND e.year = p.year
GROUP BY e.country;
-- 16.What is the global share (%) of emissions by country?
SELECT country,
SUM(emission) * 100 /
(SELECT SUM(emission) FROM emission_3)
FROM emission_3
GROUP BY country;
-- 17.What is the global average GDP, emission, and population by year?
SELECT g.year,
AVG(g.Value),
AVG(e.emission),
AVG(p.Value)
FROM gdp_3 g
JOIN emission_3 e
ON g.country = e.country AND g.year = e.year
JOIN population_3 p
ON g.country = p.countries AND g.year = p.year
GROUP BY g.year;

