# postgres\_air
This repo contains components for building the postgres_air database,
which can be used for training and various performance experiments.
The database is created by hDBn  (Hettie Dombrovskaya & Boris Novikov)

The postgres_air is used for example queries in the following book (will be referenced below as just *the book*): 
>    PostgreSQL Query Optimization, by Henrietta Dombrovskaya, Boris Novikov, and Anna Bailliekova. . Apress. DOI:10.1007/978-1-4842-6885-8.

## The db dumps of core data can be found here:

[Download Link](https://drive.google.com/drive/folders/13F7M80Kf_somnjb-mTYAnh1hW1Y_g4kJ?usp=sharing)

This shared directory contains the following editions of the postgres_air database:

| Edition   |  Description             | PostgreSQL |
| --------  | -----------------        | ---------- |
| 2024      |   Latest                 | v. 17      |   
| 2023      | The book, 2nd ed. (2024) | v. 15      |
| Initial   | The book, 1st ed. (2021) | v. 13      |

All files were produced in the PostgreSQL version indicated above but can be restored to other versions. However, you need the same version to reproduce results (e.g., query execution plans) included in the indicated edition of the query optimization book. 

Each edition contains a data dump of the postgres_air schema produced with `pg_dump`  in the following formats:

- the default `pg_dump` format  produced with `--format=custom`flag

- SQL format obtained with `--format=plain`(`zip` compressed).

In addition, the initial edition is also available in the directory format. This format is kept because it is referenced in the first edition of the book.

The total size of each dump file is about 1.2 GB (1.4 GB for the 2024 database edition).
Use the directory format if you prefer to download smaller files (the max file size is 419 MB).

For directory format and default format, use `pg_restore` with `--no-owner` option.(https://www.postgresql.org/docs/current/app-pgrestore.html)
For SQL, unzip the file and use  `psql` for restore.

You can also use the QR code provided in the QR_download file to access this directory.

![QR Download Code](QR_download.png)

## 11/26/2024: IMPORTANT UPDATES

* New passengers and bookings are added in order to fill empty or almost empty flights. 

* Seat assignments are corrected; there are no 0 rows anymore.

* The dates are moved to 2024, "today" is Aug. 13, 2024.

## 04/12/2023: IMPORTANT UPDATES

postgres_air_2023.backup

NOTE: the postgres_air_2022.backup is removed.

In addition to moving the timestamps one more year forward (the new "today" is August 17 2023) there are multiple important fixes based on the feedback received from our amazing followers and book readers:

* Arrival timestamps were corrected to make the flight durations consistent with distances. This change resulted in inconsistent itineraries for some bookings. To address that issue, the inconsistent flights were rebooked.

* Inconsistently named integrity constraints renamed.

* Overlapping bookings for the same passenger are replaced with bookings for other passengers.

* The problem of overbooked flights is addressed in three different ways: (1) additional flights, (2) aircraft change (to larger capacity), and (3) rebooking passengers.

* The backup contains the stored procedure 

```
   postgres_air.advance_air_time (   
      p_weeks int default 52,    
      p_schema_name text default 'postgres_air',   
      p_run boolean default false)

``` 
   This procedure moves all the dates in the schema for the number of weeks specified by the first parameter.

## 09/05/2022: IMPORTANT UPDATES

The version of the postgres_air database, which is used in the PostgreSQL Query optimization book (1st ed.), has "today" set to August 18, 2020. While we want to keep this version available to our readers at least until the book's next edition is out, we wanted to provide a more up-to-date version. 

The postgres_air_2022.backup contains the up-to-date version of the postgres_air database. The following changes were made:

* "today" is August 18, 2022

* to adequately reflect the current situation, all Russian airports are excluded from the bookings. The Postgres Air airline company complies with international sanctions and no longer flies to Russia.

## What are the rest of the files for?

See the db_objects_description.txt file.

## To populate the tables, the following public data sources were used

* The Global Airport Database
   https://www.partow.net/miscellaneous/airportdatabase/index.html#GlobalAirportDatabaseLicens

* Airport, airline and route data
  https://openflights.org/data.html

* Airbus - All Aircraft & Prices, Specs, Photos, Interior, Seating - Aircraft Compare
  https://www.aircraftcompare.com/manufacturers/airbus/
  
*  Frequently Occurring Surnames from the 2010 Census
  https://www.census.gov/topics/population/genealogy/data/2010_surnames.html
  
* Most Common Surnames [Last Names] in the United States (top 1000)
  https://namecensus.com/most_common_surnames.htm

* First names male:
  https://namecensus.com/male_names.htm

* First names female:
  https://namecensus.com/female_names.htm

## Disclaimer

Hettie and Boris do not guarantee the 100% accuracy of the data.
We tried our best and fixed some of the mistakes in the data sources, but it is still possible that some airports ended up in the wrong cities or wrong time zones, 
and some cities ended up in the wrong countries.
No offense intended in any of the above cases!

The aircraft codes and names look similar to real ones, however, they do not correspond to any real models. Their characteristics (namely range, velocity, width, and capacity) do not represent any of the existing aircraft models.

The flights' schedules are 100% imaginary; we guarantee that the flights' durations are realistic and
each airport is reachable from any other airport, but the schedule does not resemble any real airline schedule. 

Use at your own risk.
