Select*
From [Portfolio Project]..CovidDeaths
Order by 3,4

Select*
From [Portfolio Project]..CovidVaccinations
Order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project]..CovidDeaths
order by 1,2

Select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
where location like 'Kenya'
order by 1,2

Select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
where location like '%States%'
order by 1,2

Select location, date, total_cases, population,(total_cases/population)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
where location like 'Kenya'
order by 1,2

Select location, date, total_cases, population,(total_cases/population)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
where location like '%States%'
order by 1,2

Select location, population, MAX(total_cases) as HighestInfectionCount,max((total_cases/population))*100 as PercentpopulationInfected
From [Portfolio Project]..CovidDeaths
Group by location, population
order by PercentpopulationInfected desc

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
where continent is not null
Group by location
order by TotalDeathCount desc

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
where continent is  null
Group by location
order by TotalDeathCount desc

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc

Select  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Deathpercentage
From [Portfolio Project]..CovidDeaths
where continent is not null
--Group by date
order by 1,2

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
order by 2,3

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
order by 2,3

with PopvsVac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated) as
 (
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select*,(RollingPeopleVaccinated/population)*100
from PopvsVac

create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select*,(RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated

Create View  PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select*
from PercentPopulationVaccinated