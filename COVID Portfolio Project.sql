SELECT TOP (1000) [iso_code]
      ,[continent]
      ,[location]
      ,[date]
      ,[new_tests]
      ,[total_tests]
      ,[total_tests_per_thousand]
      ,[new_tests_per_thousand]
      ,[new_tests_smoothed]
      ,[new_tests_smoothed_per_thousand]
      ,[positive_rate]
      ,[tests_per_case]
      ,[tests_units]
      ,[total_vaccinations]
      ,[people_vaccinated]
      ,[people_fully_vaccinated]
      ,[new_vaccinations]
      ,[new_vaccinations_smoothed]
      ,[total_vaccinations_per_hundred]
      ,[people_vaccinated_per_hundred]
      ,[people_fully_vaccinated_per_hundred]
      ,[new_vaccinations_smoothed_per_million]
      ,[stringency_index]
      ,[population_density]
      ,[median_age]
      ,[aged_65_older]
  FROM [PORTFOLIO].[dbo].[CovidVaccinations$]


  SELECT*
  FROM PORTFOLIO.dbo.CovidDeaths$
  WHERE Continent is not Null
  order by 3,4

  --SELECT*
  --FROM PORTFOLIO.dbo.CovidVaccinations$
  --order by 3,4

  --Selecting data that i am going to be using

  SELECT Location, Date, Total_Cases, New_Cases, population
  FROM PORTFOLIO.dbo.CovidDeaths$
  order by 1, 2

  --Looking at the total Cases vs Total Deaths
  --Shows likelihood of dying if you contract covid in your country

   SELECT Location, Date, Total_Cases,total_deaths,(Total_deaths/total_cases)*100 as  deathpercentage
  FROM PORTFOLIO.dbo.CovidDeaths$
  WHERE Location like '%south Africa%'
  order by 1, 2

  --Looking at the total cases vs the population
  --What percentage of population got Covid

   SELECT Location, Date, Total_Cases,population,(total_cases/population)*100 as  deathpercentage
  FROM PORTFOLIO.dbo.CovidDeaths$
  WHERE Location like '%south Africa%'
  order by 1, 2


  --Showing continents with the highest Death count population

  SELECT location, MAX(cast(Total_deaths as int))as HighestDeathCount
  FROM PORTFOLIO.dbo.CovidDeaths$
  --WHERE Location like '%south Africa%'
  Where continent is not Null
  group by continent
  

  --GLOBAL NUMBER
  
  SELECT date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPerfcentage
  From PORTFOLIO.dbo.CovidDeaths$

  --where location like '%south africa%'
  where continent is not null

  SELECT*
  FROM PORTFOLIO.dbo.CovidDeaths$
  WHERE Location like'%south Africa%'
  
  SELECT*
  FROM PORTFOLIO.dbo.CovidVaccinations$
  WHERE location IN ('South africa', 'Nigeria', 'Zambia', 'Zimbabwe', 'Georgia')


  --i am selecting countries that are not African, Returing NOT AFRICAN OR TRY AGAIN 
  --Returning African if Countries are from Africa
  --Returning Total Deaths only when it is not NULL

  SELECT Location, Continent,
  CASE
  WHEN Continent <>'AFRICA'
  THEN 'NOT AFRICA'
  WHEN Location in ('south Africa', 'Nigeria','Zambia',' Namibia', ' Zimbabwe', 'Algeria')
  THEN 'AFRICAN'
  ELSE 'TRY AGAIN'
  END
  FROM PORTFOLIO.dbo.CovidDeaths$
  WHERE Total_Deaths is not null
  
  SELECT Location, Continent,
  CASE
  WHEN Continent <>'AFRICA'
  THEN 'NOT AFRICA'
  WHEN Location in ('south Africa', 'Nigeria','Zambia',' Namibia', ' Zimbabwe', 'Algeria')
  THEN 'AFRICAN'
  ELSE 'TRY AGAIN'
  END
  FROM PORTFOLIO.dbo.CovidVaccinations$
  WHERE total_tests is not null

  SELECT Location, Continent,median_age ,
  CASE
  WHEN median_Age>'18.6'
  THEN 'old'
  WHEN median_age <= '18.6'
  THEN 'young'
  ELSE 'Baby'
  END
  FROM PORTFOLIO.dbo.CovidVaccinations$
  WHERE new_vaccinations is not null

  --Looking at Total Population vs Vaccinations
   --USE CTE
  WITH PopvsVac (continent, location, date, population,new_vaccinations, RollingpeopleVaccinated)
  as
  (
  SELECT dea.continent, dea.location,dea.date, population, vac.new_vaccinations,
  SUM (CONVERT(INT,vac.new_vaccinations)) OVER (Partition by dea.Location,
  dea.Date) as RollingPeopleVccinated
  --,(RollingPeopleVccinated/population)*100


  FROM PORTFOLIO.dbo.CovidDeaths$ dea
  join PORTFOLIO.dbo.CovidVaccinations$ vac
  on dea.Location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
  order by 1, 2, 3
  )
  SELECT* ,(RollingpeopleVaccinated/population)*100
  FROM PopvsVac

 -- TEMP TABLE
 DROP TABLE IF EXISTS #PercrntPopulationVaccinated
 CREATE TABLE #PercrntPopulationVaccinated
 (
 Contintent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_Vaccinations numeric,
 RollingPeopleVaccinated numeric
 )
 INSERT INTO #PercrntPopulationVaccinated
 SELECT dea.continent, dea.location,dea.date, population, vac.new_vaccinations,
  SUM (CONVERT(INT,vac.new_vaccinations)) OVER (Partition by dea.Location,
  dea.Date) as RollingPeopleVccinated
  --,(RollingPeopleVccinated/population)*100


  FROM PORTFOLIO.dbo.CovidDeaths$ dea
  join PORTFOLIO.dbo.CovidVaccinations$ vac
  on dea.Location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
  order by 1, 2, 3
  
  SELECT* ,(RollingpeopleVaccinated/population)*100
  FROM #PercrntPopulationVaccinated

  --CREATING VIEW TO STORE DATA FOR LATER VISUALIZATION

  Create view #PercrntPopulationVaccinated as

  SELECT dea.continent, dea.location,dea.date, population, vac.new_vaccinations
 , SUM (CONVERT(INT,vac.new_vaccinations)) OVER (Partition by dea.Location,
  dea.Date) as RollingPeopleVccinated
  --,(RollingPeopleVccinated/population)*100


  FROM PORTFOLIO.dbo.CovidDeaths$ dea
  join PORTFOLIO.dbo.CovidVaccinations$ vac
  on dea.Location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
  --order by  2, 3

  SELECT*
  FROM #PercrntPopulationVaccinated

 


  
  





































































































































































































































































































































































































































































































































































































































































































































































































































  

