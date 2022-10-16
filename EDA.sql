SELECT * 
FROM portfolioProject..CovidDeaths

-- Select the data that we are going to be using
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM portfolioProject..CovidDeaths
ORDER BY 1,2

-- Looking at total cases VS total deaths in Egypt
SELECT Location, date, total_cases,total_deaths, ROUND((total_deaths/total_cases),4) *100 AS DeathPercentage
FROM portfolioProject..CovidDeaths
WHERE Location like '%pt'
ORDER BY 5 DESC


-- Looking at total cases compared with population
-- what percentage of population got covid
SELECT Location, date,population, total_cases, ROUND((total_cases/population),4) *100 AS totalCases_populations
FROM portfolioProject..CovidDeaths

--Which countries has highest infection rate compared with population?
SELECT Location ,population, MAX(total_cases) AS Highest_infection_count,MAX((total_cases/population)) *100 AS PercentPopulationInfected
FROM portfolioProject..CovidDeaths
GROUP BY population, location
ORDER BY PercentPopulationInfected DESC

--Countries highest death count per population 
SELECT Location , MAX(CAST(total_deaths as INT)) AS Highest_death_count
FROM portfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Highest_death_count DESC


--highest deaths by contentient
SELECT continent, MAX(CAST(total_deaths as INT)) AS Highest_death_count
FROM portfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Highest_death_count DESC

--Total cases VS total deaths 
SELECT SUM(new_cases) total_cases, SUM(CAST(new_deaths AS INT)) total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases) *100 DeathsPecentage
FROM portfolioProject..CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date




--How many people in the world vaccinated 
WITH PopVsVac(continent, Location, Date, Population, new_vaccinations ,RollingPeopleVaccinated)
AS(
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(CONVERT(INT, v.new_vaccinations)) OVER (PARTITION BY d.location ORDER BY d.location,d.date)
AS RollingPeopleVaccinated
FROM portfolioProject..CovidDeaths d
JOIN portfolioProject..CovidVaccinations v
ON d.date = v.date AND d.location = v.location
WHERE d.continent IS NOT NULL 
)
SELECT * ,(RollingPeopleVaccinated/Population) * 100
FROM PopVsVac


