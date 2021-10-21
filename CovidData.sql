
select location, date, total_cases, new_cases, total_deaths, population
from CovidDeathsCleaned
order by 1,2

--Looking at Total Cases vs Total Deaths
--Likelehood of sying if you contract covid in your country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeathsCleaned
Where location like '%states%'
order by 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got covid
select location, date, total_cases, population, (total_cases/population)*100 as InfectionRate
from CovidDeathsCleaned
--Where location like '%states%'
order by 1,2

--Looking at countries with highest infection rate compared to population
select location, max(total_cases) as HighestInfectionCount, population, Max((total_cases/population))*100 as PercentPopulationInfected
from CovidDeathsCleaned
--Where location like '%states%'
Group by location, population
order by PercentPopulationInfected desc

--Showing countries with highest death count per population
select location, max(total_deaths) as TotalDeathCount
from CovidDeathsCleaned
Where continent is not null
Group by location
order by TotalDeathCount desc


--LET'S NREAL TJOMHS DOWN BY CONTINENT
select continent, max(total_deaths) as TotalDeathCount
from CovidDeathsCleaned
Where continent is not null
Group by continent
order by TotalDeathCount desc

--Showing continents with the highest death count
select continent, max(total_deaths) as TotalDeathCount
from CovidDeathsCleaned
Where continent is not null
Group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS

select sum(new_cases) as total_cases, sum(new_deaths) as total_death, sum(new_deaths)/sum(new_cases) *100 as deathPercentage--, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeathsCleaned
--Where location like '%states%'
where continent is not null
--group by date
order by 1,2

select dea.continent, dea.location, dea.date, population, vac.new_vaccinations, 
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeathsCleaned dea
join CovidVaccinationsCleaned vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as (
select dea.continent, dea.location, dea.date, population, vac.new_vaccinations, 
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeathsCleaned dea
join CovidVaccinationsCleaned vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
)
select *, RollingPeopleVaccinated/Population*100
from popvsvac
where location like 'Albania'

--TEMP TABLE

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, population, vac.new_vaccinations, 
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeathsCleaned dea
join CovidVaccinationsCleaned vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3
select *
from #PercentPopulationVaccinated


----Creating View to store data for later visualizations
--Create View #PercentPopulationVaccinated as
--select dea.continent, dea.location, dea.date, population, vac.new_vaccinations, 
--sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--from CovidDeathsCleaned dea
--join CovidVaccinationsCleaned vac
--on dea.location = vac.location and dea.date = vac.date
--where dea.continent is not null
----order by 2,3