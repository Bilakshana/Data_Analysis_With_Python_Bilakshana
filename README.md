<h1 align="center">Climbing in the Himalaya</h1>
<p align="center"><b>An end-to-end ETL and data analysis project</b><br>Python · Pandas · SQL (SQLite)</p>

<p align="center">
  <img src="https://img.shields.io/badge/Python-3-blue" alt="Python">
  <img src="https://img.shields.io/badge/Pandas-data%20cleaning-informational" alt="Pandas">
  <img src="https://img.shields.io/badge/SQLite-4%20tables-green" alt="SQLite">
  <img src="https://img.shields.io/badge/SQL%20reports-10-orange" alt="SQL reports">
</p>

---

## About the project

For my capstone I picked the Himalayan Climbing Expeditions dataset, which records expeditions to the major peaks of Nepal from 1905 to 2019. The data is real and a bit messy, which made it a good fit for an ETL project: some ids repeat, one peak is missing from the peaks table, there are impossible ages and altitudes, and dates are stored as text.

I took the three raw csv files through the whole pipeline. I explored and cleaned them with Pandas, answered six questions about climbing in the Himalaya, designed a small relational database, loaded the cleaned data into it with Python, and wrote ten SQL queries to report on it.

## Quick facts

| | |
|---|---|
| **Dataset** | Himalayan Climbing Expeditions (1905-2019) |
| **Source** | [TidyTuesday, 22 Sep 2020](https://github.com/rfordatascience/tidytuesday/tree/main/data/2020/2020-09-22), originally from [The Himalayan Database](https://www.himalayandatabase.com/) |
| **Size** | 468 peaks, 10,364 expeditions, 76,519 members |
| **Tools** | Python, Pandas, Matplotlib, SQLAlchemy, SQLite |
| **Output** | 4 notebooks, a SQLite database with 4 related tables, 10 SQL reports |

## How the pipeline works

**1. Extract and EDA** - The three csv files are read with Pandas. I checked the shape, column types, missing values, duplicates, invalid values, unexpected categories and outliers before changing anything.

**2. Clean and transform** - The problems from the EDA are fixed one by one. A duplicate expedition id is corrected, the missing peak is added, dates become real datetimes, `Unknown` is turned into missing values, and impossible ages and altitudes are removed. New columns are then created (decade, success, total deaths, duration, height category) and the trekking agencies are moved to their own table.

**3. Analyse** - Six questions are answered with groupby, aggregation and charts.

**4. Load and report** - The tables are created from the schema, the cleaned data is loaded with SQLAlchemy, and ten SQL queries are run against the database.

## What I found

- **Everest is the most attempted peak** with 2,149 expeditions, and about 62% of them succeeded.
- **Oxygen makes a big difference** on peaks of 8000 m and above: roughly 78% of members using it reached the top, against about 16% without it.
- **Spring is the best season to climb**, with the highest success rate at about 57%.
- **Annapurna I is the deadliest peak** among peaks with at least 500 members, with around 37 deaths for every 1,000 members.
- **More women are climbing**: they made up about 2.4% of members in the 1960s and 11.1% in the 2010s.

## Database design

The data is split into four tables. A peak has many expeditions, an agency has many expeditions, and an expedition has many members.

<p align="center">
  <img src="reports/ER%20Diagram.png" alt="Entity relationship diagram" width="800">
</p>

Every table has a primary key, the links between them are foreign keys, and there are `CHECK` constraints on columns like `sex` and `success`.

## Repository structure

```
.
├── data
│   ├── raw/                    original csv files
│   └── processed/              cleaned tables
├── notebooks
│   ├── extract_and_eda.ipynb
│   ├── cleaning_and_transformation.ipynb
│   ├── analysis_and_insights.ipynb
│   └── database_and_sql_reports.ipynb
├── sql
│   ├── schema.sql              create tables
│   ├── queries.sql             the 10 reports
│   └── himalayan_db.sql        both in one file
├── database
│   └── himalayan.db
└── reports
    ├── ER Diagram.png
    └── SQL_Reports.md          output of every query
```

## Running the project

```bash
pip install -r requirements.txt
```

Then open the notebooks and run them in this order: extract_and_eda, cleaning_and_transformation, analysis_and_insights, database_and_sql_reports. The second notebook creates `data/processed` and the last one builds `database/himalayan.db` and the SQL report.

## About me

**Bilakshana Neupane** - BSCS student, King's College, Nepal
