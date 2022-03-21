select *from Portfolioproject. .CovidDeaths
where continent is not null
order by 3,4


--select *from Portfolioproject. .CovidVaccination
--order by 3,4

-- select data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
from Portfolioproject..CovidDeaths
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
order by 5 desc

--looking at countries with highest infection rate compared to population
Select location, population, max(total_cases) as highestinfectioncount, max((total_cases/population))*100 as Percentagepopulationinfected
from Portfolioproject..CovidDeaths
where location =  'Colombia '
group by location, population
order by Percentagepopulationinfected desc

--Showing countries with highest death count per population
Select continent, MAX(cast(total_deaths as int)) as totaldeathcount
from Portfolioproject..CovidDeaths
--where location =  'Colombia '
where continent is  not null
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
Select Dea.continent, Dea.location,Dea.date, dea.population, vacc.new_vaccinations,
SUM(convert(int, vacc.new_vaccinations)) over (partition by dea.location)
from Portfolioproject..CovidVaccination vacc
join Portfolioproject..CovidDeaths Dea
on Dea.location= vacc.location
AND Dea.date=vacc.date
where DEA.continent is  not null
order by 2,3
go

Alter table dbo.CovidVaccination
alter column new_vaccinations varchar (30)

