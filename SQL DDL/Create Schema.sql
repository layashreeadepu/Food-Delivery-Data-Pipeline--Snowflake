
--use sysadmin role
use role sysadmin;

-- create development sadbox datbse/ schema if not exists

create database if not exists sandbox;
use database sandbox;

create schema if not exists staging_area;
create schema if not exists cleaning_area;
create schema if not exists consumption_area;
create schema if not exists master_area;

use schema staging_area;

 -- create file format to process the CSV file
  create file format if not exists staging_area.csv_file_format 
        type = 'csv' 
        compression = 'auto' 
        field_delimiter = ',' 
        record_delimiter = '\n' 
        skip_header = 1 
        field_optionally_enclosed_by = '\042' 
        null_if = ('\\N');


create stage staging_area.csv_stg
    directory = ( enable = true )
    comment = 'this is the snowflake internal stage';


create or replace tag 
    master_area.pii_policy_tag 
    allowed_values 'PII','PRICE','SENSITIVE','EMAIL'
    comment = 'This is PII policy tag object';SANDBOX.STAGING_AREA.CSV_STG

    -- loading data and validating the data
    -- root location
    list @staging_area.csv_stg/initial;

select 
        t.$1::text as locationid,
        t.$2::text as city,
        t.$3::text as state,
        t.$4::text as zipcode,
        t.$5::text as activeflag,
        t.$6::text as createddate,
        t.$7::text as modifieddate
    from @staging_area.csv_stg/initial/location 
    (file_format => 'staging_area.csv_file_format') t;





        
