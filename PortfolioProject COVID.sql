select *
from  Portfolio..CovidDeaths
where continent is not null
order by 3,4;

select *
from  Portfolio..[covid vaccinations]
order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from  Portfolio..CovidDeaths
where continent is not null
order by 1,2

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_pecentage
from  Portfolio..CovidDeaths
where location like '%turkey%'
and continent is not null
order by 1,2

select location, date, population, total_cases, (total_cases/population)*100 AS PercentpopulationInfected
from  Portfolio..CovidDeaths
where location like '%turkey%'
and continent is not null
order by 1,2

select location, population, max(total_cases) as highestinfection, max((total_cases/population))*100 AS PercentpopulationInfected
from  Portfolio..CovidDeaths
--where location like '%turkey%'
group by location, population
order by PercentpopulationInfected desc

--select location, max(cast(total_deaths as bigint)) as TotalDeathsCount  
--from  Portfolio..CovidDeaths
----where location like '%turkey%'
--where  continent is not null
--group by location
--order by TotalDeathsCount desc

--select location, max(cast(total_deaths as bigint)) as TotalDeathsCount  
--from  Portfolio..CovidDeaths
----where location like '%turkey%'
--where  continent is null
--group by location
--order by TotalDeathsCount desc

select continent, max(cast(total_deaths as int)) as TotalDeathsCount  
from  Portfolio..CovidDeaths
--where location like '%turkey%'
where  continent is not null
group by continent
order by TotalDeathsCount desc

select date, SUM(new_cases) as GlobalCases, SUM(cast(new_deaths as bigint)) as GlobalDeaths, (SUM(cast(new_deaths as bigint))/SUM(new_cases))*100 as GlobalDeathPercentage
from  Portfolio..CovidDeaths
--where location like '%turkey%'
where continent is not null
group by  date
order by 1,2

select SUM(new_cases) as GlobalCases, SUM(cast(new_deaths as bigint)) as GlobalDeaths, (SUM(cast(new_deaths as bigint))/SUM(new_cases))*100 as GlobalDeathPercentage
from  Portfolio..CovidDeaths
--where location like '%turkey%'
where continent is not null
order by 1,2



with PopvsVac (continent, location, date, population, new_vaccinnations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinnated/population)*100
from Portfolio..CovidDeaths dea
join Portfolio..[covid vaccinations] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac
where location like '%turkey%'




create view PopvsVac as

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinnated/population)*100
from Portfolio..CovidDeaths dea
join Portfolio..[covid vaccinations] vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * 
from PopvsVac

