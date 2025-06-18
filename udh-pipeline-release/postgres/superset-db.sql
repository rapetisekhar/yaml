-- Database: supersetdb, Role: supersetuser, Schema: supsersetsc

CREATE ROLE supersetuser WITH LOGIN PASSWORD 'superpass';
CREATE DATABASE supersetdb WITH OWNER = supersetuser;
GRANT ALL ON DATABASE supersetdb TO supersetuser;

\c supersetdb           -- connecting to database supersetdb

CREATE SCHEMA IF NOT EXISTS supsersetsc AUTHORIZATION supersetuser;
GRANT ALL ON SCHEMA supsersetsc TO supersetuser;

CREATE SCHEMA IF NOT EXISTS supsersetsc AUTHORIZATION supersetuser;
CREATE SCHEMA IF NOT EXISTS supsersetsc;
CREATE SCHEMA IF NOT EXISTS supsersetsc AUTHORIZATION supersetuser;
CREATE TABLE IF NOT EXISTS supsersetsc.testtable ( no integer NOT NULL, code character(4), PRIMARY KEY (no));

ALTER TABLE IF EXISTS supsersetsc.testtable OWNER to supersetuser;
