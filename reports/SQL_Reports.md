# SQL report results

## Query 1: Number of expeditions and success rate in each season

```sql
select season, count(*) as expeditions,
       sum(success) as successful,
       round(avg(success) * 100, 1) as success_rate
from expeditions
where season is not null
group by season
order by expeditions desc;
```

| season   |   expeditions |   successful |   success_rate |
|:---------|--------------:|-------------:|---------------:|
| Autumn   |          5064 |         2766 |           54.6 |
| Spring   |          4875 |         2776 |           56.9 |
| Winter   |           315 |          143 |           45.4 |
| Summer   |           108 |           41 |           38   |

## Query 2: The 10 most attempted peaks and their success rate

```sql
select p.peak_name, p.height_metres, count(*) as expeditions,
       round(avg(e.success) * 100, 1) as success_rate
from expeditions e
join peaks p on e.peak_id = p.peak_id
group by p.peak_name, p.height_metres
order by expeditions desc
limit 10;
```

| peak_name    |   height_metres |   expeditions |   success_rate |
|:-------------|----------------:|--------------:|---------------:|
| Everest      |            8850 |          2149 |           61.7 |
| Ama Dablam   |            6814 |          1366 |           67.9 |
| Cho Oyu      |            8188 |          1332 |           63.1 |
| Manaslu      |            8163 |           632 |           54.7 |
| Lhotse       |            8516 |           429 |           58.3 |
| Dhaulagiri I |            8167 |           383 |           42.6 |
| Makalu       |            8485 |           356 |           43   |
| Baruntse     |            7152 |           308 |           39.6 |
| Pumori       |            7138 |           265 |           47.9 |
| Annapurna I  |            8091 |           243 |           33.7 |

## Query 3: Expeditions in each decade

```sql
select decade, count(*) as expeditions, sum(member_count) as members,
       sum(total_deaths) as deaths
from expeditions
group by decade
order by decade;
```

|   decade |   expeditions |   members |   deaths |
|---------:|--------------:|----------:|---------:|
|     1900 |             4 |         9 |        5 |
|     1910 |             3 |         3 |        0 |
|     1920 |            10 |        51 |       14 |
|     1930 |            34 |       152 |        6 |
|     1940 |            15 |        53 |        0 |
|     1950 |           168 |       856 |       25 |
|     1960 |           161 |       989 |       32 |
|     1970 |           361 |      3506 |      155 |
|     1980 |          1187 |     10023 |      247 |
|     1990 |          1703 |     12512 |      210 |
|     2000 |          3213 |     16867 |      193 |
|     2010 |          3505 |     16679 |      219 |

## Query 4: Does using oxygen help on peaks of 8000 m and above?

```sql
select case when m.oxygen_used = 1 then 'Used oxygen' else 'No oxygen' end as oxygen,
       count(*) as members,
       round(avg(m.success) * 100, 1) as success_rate,
       round(avg(m.died) * 100, 2) as death_rate
from members m
join expeditions e on m.expedition_id = e.expedition_id
join peaks p on e.peak_id = p.peak_id
where p.height_metres >= 8000
group by m.oxygen_used;
```

| oxygen      |   members |   success_rate |   death_rate |
|:------------|----------:|---------------:|-------------:|
| No oxygen   |     28454 |           15.8 |         1.91 |
| Used oxygen |     17973 |           77.9 |         1.12 |

## Query 5: Deadliest peaks (peaks with at least 500 members), deaths per 1000 members

```sql
select p.peak_name, sum(e.member_count) as members, sum(e.member_deaths) as deaths,
       round(sum(e.member_deaths) * 1000.0 / sum(e.member_count), 1) as deaths_per_1000
from expeditions e
join peaks p on e.peak_id = p.peak_id
group by p.peak_name
having sum(e.member_count) >= 500
order by deaths_per_1000 desc
limit 10;
```

| peak_name     |   members |   deaths |   deaths_per_1000 |
|:--------------|----------:|---------:|------------------:|
| Annapurna I   |      1453 |       54 |              37.2 |
| Kangchenjunga |      1162 |       34 |              29.3 |
| Dhaulagiri I  |      2242 |       63 |              28.1 |
| Pumori        |      1615 |       33 |              20.4 |
| Manaslu       |      3434 |       69 |              20.1 |
| Makalu        |      2026 |       30 |              14.8 |
| Tilicho       |       633 |        9 |              14.2 |
| Everest       |     15281 |      186 |              12.2 |
| Lhotse        |      2070 |       17 |               8.2 |
| Cho Oyu       |      7362 |       42 |               5.7 |

## Query 6: Citizenships with the most members (at least 500) and their success rate

```sql
select citizenship, count(*) as members,
       round(avg(success) * 100, 1) as success_rate
from members
where citizenship is not null
group by citizenship
having count(*) >= 500
order by members desc
limit 10;
```

| citizenship   |   members |   success_rate |
|:--------------|----------:|---------------:|
| Nepal         |     16156 |           62.8 |
| USA           |      6526 |           33   |
| Japan         |      6433 |           29.8 |
| UK            |      5264 |           29.1 |
| France        |      4619 |           27.4 |
| Spain         |      3331 |           23.8 |
| S Korea       |      2913 |           20.3 |
| Italy         |      2765 |           25   |
| Germany       |      2666 |           32.8 |
| Switzerland   |      2469 |           32.6 |

## Query 7: Success rate and average age by age group

```sql
select age_group, count(*) as members,
       round(avg(age), 1) as avg_age,
       round(avg(success) * 100, 1) as success_rate
from members
where age_group is not null
group by age_group
order by min(age);
```

| age_group    |   members |   avg_age |   success_rate |
|:-------------|----------:|----------:|---------------:|
| Under 20     |       558 |      18.1 |           53.9 |
| 20-29        |     18070 |      25.8 |           41.8 |
| 30-39        |     27219 |      34.3 |           40.4 |
| 40-49        |     17201 |      43.9 |           37.4 |
| 50-59        |      7566 |      53.6 |           30.2 |
| 60 and above |      2407 |      64.1 |           21.7 |

## Query 8: Unclimbed peaks that are higher than the average peak

```sql
select peak_name, height_metres
from peaks
where climbing_status = 'Unclimbed'
  and height_metres > (select avg(height_metres) from peaks)
order by height_metres desc
limit 10;
```

| peak_name           |   height_metres |
|:--------------------|----------------:|
| Yalung Kang West    |            8077 |
| Kangchenjunga North |            7938 |
| Kangbachen East     |            7780 |
| Ngojumba Kang III   |            7681 |
| Shartse             |            7591 |
| Jannu East          |            7460 |
| Nangpai Gosum II    |            7287 |
| Chamar              |            7161 |
| Gangapurna West     |            7140 |
| Junction Peak       |            7133 |

## Query 9: Trekking agencies with at least 50 expeditions

```sql
select a.agency_name, count(*) as expeditions,
       round(avg(e.success) * 100, 1) as success_rate,
       sum(e.total_deaths) as deaths
from expeditions e
join agencies a on e.agency_id = a.agency_id
group by a.agency_name
having count(*) >= 50
order by expeditions desc
limit 10;
```

| agency_name           |   expeditions |   success_rate |   deaths |
|:----------------------|--------------:|---------------:|---------:|
| Asian Trekking        |           853 |           53.7 |       90 |
| Thamserku Trekking    |           707 |           52.5 |       28 |
| Himalayan Guides      |           374 |           70.1 |       34 |
| Seven Summit Treks    |           313 |           64.5 |       33 |
| Cosmo Treks           |           293 |           52.2 |       25 |
| Monterosa Treks       |           243 |           46.1 |       11 |
| Cho Oyu Trekking      |           199 |           54.8 |       17 |
| Arun Treks            |           148 |           65.5 |        8 |
| Prestige Adventure    |           147 |           57.1 |        6 |
| Wilderness Experience |           145 |           53.8 |       17 |

## Query 10: The 10 expeditions with the most deaths

```sql
select e.expedition_id, p.peak_name, e.year, e.member_count,
       e.total_deaths, e.termination_reason
from expeditions e
join peaks p on e.peak_id = p.peak_id
order by e.total_deaths desc, e.year
limit 10;
```

| expedition_id   | peak_name     |   year |   member_count |   total_deaths | termination_reason                     |
|:----------------|:--------------|-------:|---------------:|---------------:|:---------------------------------------|
| KGUR05301       | Kang Guru     |   2005 |              7 |             18 | Accident (death or serious injury)     |
| MANA72101       | Manaslu       |   1972 |             12 |             15 | Accident (death or serious injury)     |
| PISA94301       | Pisang        |   1994 |             10 |             11 | Success (main peak)                    |
| GURJ18301       | Gurja Himal   |   2018 |              5 |              9 | Accident (death or serious injury)     |
| GANG71301       | Gangapurna    |   1971 |             10 |              8 | Success (main peak)                    |
| EVER22101       | Everest       |   1922 |             13 |              7 | Illness, AMS, exhaustion, or frostbite |
| DHA169101       | Dhaulagiri I  |   1969 |             10 |              7 | Accident (death or serious injury)     |
| DHA469301       | Dhaulagiri IV |   1969 |              9 |              6 | Accident (death or serious injury)     |
| EVER70101       | Everest       |   1970 |             34 |              6 | Other                                  |
| EVER74301       | Everest       |   1974 |             10 |              6 | Accident (death or serious injury)     |
