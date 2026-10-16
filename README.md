# Climbing in the Himalaya: an ETL project

I took the Himalayan Climbing Expeditions data (1905-2019), cleaned it up, answered some questions about it with Pandas, and then moved it into a small SQLite database so it can be queried with SQL.

Dataset: [TidyTuesday, 22 Sep 2020](https://github.com/rfordatascience/tidytuesday/tree/main/data/2020/2020-09-22), which comes from [The Himalayan Database](https://www.himalayandatabase.com/).

Bilakshana Neupane, BSCS, King's College

## What is inside

| Folder | What you will find |
|---|---|
| `data/raw` | the three original csv files: peaks, expeditions, members |
| `data/processed` | the cleaned tables (saved by notebook 2) |
| `notebooks` | the four notebooks, one for each stage |
| `sql` | `schema.sql` (tables), `queries.sql` (10 reports), `himalayan_db.sql` (both in one file) |
| `database` | `himalayan.db`, the finished SQLite database |
| `reports` | the ERD, the SQL query results and the project report (pdf) |

## The notebooks

1. `extract_and_eda`: load the files and look at them (shape, types, missing values, duplicates, outliers)
2. `cleaning_and_transformation`: fix the problems found in the EDA and add new columns
3. `analysis_and_insights`: six questions answered with groupby and charts
4. `database_and_sql_reports`: create the tables, load the data and run the SQL reports

## Database

Four tables linked by foreign keys: `peaks` and `agencies` each connect to `expeditions`, and `expeditions` connects to `members`. The full diagram is in `reports/ERD.png`.

## Running it

```
pip install -r requirements.txt
```

Then open the notebooks and run them from 01 to 04. Notebook 2 writes `data/processed` and notebook 4 builds `database/himalayan.db`.
