-- report queries for the himalayan expeditions database

-- Query 1: Number of expeditions and success rate in each season
select season, count(*) as expeditions,
       sum(success) as successful,
       round(avg(success) * 100, 1) as success_rate
from expeditions
where season is not null
group by season
order by expeditions desc;

-- Query 2: The 10 most attempted peaks and their success rate
select p.peak_name, p.height_metres, count(*) as expeditions,
       round(avg(e.success) * 100, 1) as success_rate
from expeditions e
join peaks p on e.peak_id = p.peak_id
group by p.peak_name, p.height_metres
order by expeditions desc
limit 10;

-- Query 3: Expeditions in each decade
select decade, count(*) as expeditions, sum(member_count) as members,
       sum(total_deaths) as deaths
from expeditions
group by decade
order by decade;

-- Query 4: Does using oxygen help on peaks of 8000 m and above?
select case when m.oxygen_used = 1 then 'Used oxygen' else 'No oxygen' end as oxygen,
       count(*) as members,
       round(avg(m.success) * 100, 1) as success_rate,
       round(avg(m.died) * 100, 2) as death_rate
from members m
join expeditions e on m.expedition_id = e.expedition_id
join peaks p on e.peak_id = p.peak_id
where p.height_metres >= 8000
group by m.oxygen_used;

-- Query 5: Deadliest peaks (peaks with at least 500 members), deaths per 1000 members
select p.peak_name, sum(e.member_count) as members, sum(e.member_deaths) as deaths,
       round(sum(e.member_deaths) * 1000.0 / sum(e.member_count), 1) as deaths_per_1000
from expeditions e
join peaks p on e.peak_id = p.peak_id
group by p.peak_name
having sum(e.member_count) >= 500
order by deaths_per_1000 desc
limit 10;

-- Query 6: Citizenships with the most members (at least 500) and their success rate
select citizenship, count(*) as members,
       round(avg(success) * 100, 1) as success_rate
from members
where citizenship is not null
group by citizenship
having count(*) >= 500
order by members desc
limit 10;

-- Query 7: Success rate and average age by age group
select age_group, count(*) as members,
       round(avg(age), 1) as avg_age,
       round(avg(success) * 100, 1) as success_rate
from members
where age_group is not null
group by age_group
order by min(age);

-- Query 8: Unclimbed peaks that are higher than the average peak
select peak_name, height_metres
from peaks
where climbing_status = 'Unclimbed'
  and height_metres > (select avg(height_metres) from peaks)
order by height_metres desc
limit 10;

-- Query 9: Trekking agencies with at least 50 expeditions
select a.agency_name, count(*) as expeditions,
       round(avg(e.success) * 100, 1) as success_rate,
       sum(e.total_deaths) as deaths
from expeditions e
join agencies a on e.agency_id = a.agency_id
group by a.agency_name
having count(*) >= 50
order by expeditions desc
limit 10;

-- Query 10: The 10 expeditions with the most deaths
select e.expedition_id, p.peak_name, e.year, e.member_count,
       e.total_deaths, e.termination_reason
from expeditions e
join peaks p on e.peak_id = p.peak_id
order by e.total_deaths desc, e.year
limit 10;
