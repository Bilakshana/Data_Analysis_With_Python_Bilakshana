# Himalayan Climbing Expeditions - ETL project

This is my ETL capstone. I worked with the Himalayan Climbing Expeditions data (1905-2019) from TidyTuesday, which comes from The Himalayan Database. It has three files: peaks, expeditions and members.

TidyTuesday link: https://github.com/rfordatascience/tidytuesday/tree/main/data/2020/2020-09-22

I did the project in four notebooks, one for each stage. First I loaded the files and explored them, then cleaned the problems I found and added a few new columns. After that I answered six questions with Pandas, and in the last notebook I created a SQLite database with four tables and wrote 10 SQL queries.

## Folders

- `data/raw` has the original csv files and `data/processed` has the cleaned ones
- `notebooks` has the four notebooks, in the order I did them (extract_and_eda, cleaning_and_transformation, analysis_and_insights, database_and_sql_reports)
- `sql` has the create table code, the 10 queries, and `himalayan_db.sql` which has both
- `database` has the SQLite file
- `reports` has the ERD and the results of the SQL queries

## Database

The tables are `peaks`, `agencies`, `expeditions` and `members`. Peaks and agencies are linked to expeditions, and expeditions are linked to members. You can see this in `reports/ER Diagram.png`.

## Running

Run `pip install -r requirements.txt` and then run the notebooks one after the other. The second one makes the cleaned csv files and the last one makes the database.
