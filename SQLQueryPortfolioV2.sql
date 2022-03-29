select * from PortfolioProject. .CovidDeaths
where continent is not null
order by 3,4

--select * from PortfolioProject. .CovidVaccinations
--where continent is not null
---order by 3,4

-- select data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

--looking at total cases vs total deaths
--shows the likelihood of dying if you contract covid in your country
Select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as deathPercentage
from Portfolioproject..CovidDeaths
where location =  'Colombia'
order by 5 desc,2 

--look at total cases vs population

Select location, date, population,  total_cases, (total_cases/population)*100 as casesPercentage
from Portfolioproject..CovidDeaths
--where location =  'Colombia'
order by 5 ASC

--looking at countries with highest infection rate compared to population
Select location, population, max(total_cases) as highestinfectioncount, max((total_cases/population))*100 as Percentagepopulationinfected
from Portfolioproject..CovidDeaths
--where location =  'Colombia '
group by location, population
order by Percentagepopulationinfected DESC

--Showing countries with highest death count per population
Select continent, MAX(cast(total_deaths as int)) as totaldeathcount
from Portfolioproject..CovidDeaths
--where location =  'Colombia '
where continent is NOT null
group by continent
order by totaldeathcount desc

--GLOBAL NUMBERS

Select  SUM(NEW_cases) AS Newcases,sum(cast(new_deaths as int)) as newdeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercent
from Portfolioproject..CovidDeaths
--where location =  'Colombia'
where continent is  not null
--GROUP BY date
order by 1,2

--Population vs Vaccination
Select Dea.continent, Dea.location, dea.date, dea.population, vacc.new_vaccinations
--SUM(convert(int, vacc.new_vaccinations)) over (partition by dea.location)
from PortfolioProject..CovidDeaths Dea
join Portfolioproject..CovidVaccinations Vacc
on Dea.location= vacc.location
AND Dea.date=vacc.date
where DEA.continent is  not null
order by 2,3
go

--Population vs Vaccination

With PopVsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select Dea.continent, Dea.location,Dea.date, dea.population, vacc.new_vaccinations
,SUM(convert(bigint, vacc.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidVaccinations vacc
join Portfolioproject..CovidDeaths Dea
on Dea.location= vacc.location
AND Dea.date=vacc.date
--where DEA.continent is  not null
)
SELECT * , (RollingPeopleVaccinated/Population)*100
from PopVsVac


--Temp Table
Drop table if exists  PercentPopulationVaccinated
Create table PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into PercentPopulationVaccinated
Select Dea.continent, Dea.location,Dea.date, dea.population, vacc.new_vaccinations
,SUM(convert(bigint, vacc.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidVaccinations vacc
join Portfolioproject..CovidDeaths Dea
on Dea.location= vacc.location
AND Dea.date=vacc.date
--where DEA.continent is  not null

SELECT * , (RollingPeopleVaccinated/Population)*100
from PercentPopulationVaccinated


-- Create view to store data for later visualization

cREATE view PercentPopulationVaccinated1 as
Select Dea.continent, Dea.location,Dea.date, dea.population, vacc.new_vaccinations
,SUM(convert(bigint, vacc.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidVaccinations vacc
join Portfolioproject..CovidDeaths Dea
on Dea.location= vacc.location
AND Dea.date=vacc.date
--where DEA.continent is  not null

SELECT * FROM PercentPopulationVaccinated