-- himalayan expeditions database: table creation + report queries in one file

pragma foreign_keys = on;

drop table if exists members;
drop table if exists expeditions;
drop table if exists agencies;
drop table if exists peaks;

create table peaks (
    peak_id             text primary key,
    peak_name           text not null,
    height_metres       integer,
    height_category     text,
    climbing_status     text check (climbing_status in ('Climbed', 'Unclimbed', 'Unknown')),
    first_ascent_year   integer,
    first_ascent_country text
);

create table agencies (
    agency_id    integer primary key,
    agency_name  text not null unique
);

create table expeditions (
    expedition_id       text primary key,
    peak_id             text not null,
    agency_id           integer,
    year                integer not null,
    decade              integer not null,
    season              text,
    basecamp_date       text,
    highpoint_date      text,
    termination_date    text,
    duration_days       integer,
    termination_reason  text,
    highpoint_metres    integer,
    member_count        integer not null,
    member_deaths       integer not null,
    hired_staff         integer not null,
    hired_staff_deaths  integer not null,
    total_deaths        integer not null,
    oxygen_used         integer not null,
    success             integer not null check (success in (0, 1)),
    foreign key (peak_id) references peaks (peak_id),
    foreign key (agency_id) references agencies (agency_id)
);

create table members (
    member_id         text primary key,
    expedition_id     text not null,
    sex               text check (sex in ('M', 'F')),
    age               integer check (age between 10 and 100),
    age_group         text,
    citizenship       text,
    expedition_role   text,
    hired             integer not null,
    success           integer not null,
    solo              integer not null,
    oxygen_used       integer not null,
    died              integer not null,
    death_cause       text,
    injured           integer not null,
    injury_type       text,
    highpoint_metres  integer,
    foreign key (expedition_id) references expeditions (expedition_id)
);


-- ----------------------------------------
-- report queries
-- ----------------------------------------

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
