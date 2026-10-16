-- schema for the himalayan expeditions database (sqlite)

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
