CREATE DATABASE airflowdb WITH OWNER = airflowuser;
GRANT ALL ON DATABASE airflowdb TO airflowuser;


-- Connect to the database
\c airflowdb;

-- Grant necessary permissions
GRANT CONNECT ON DATABASE airflowdb TO airflowuser;

-- Grant usage on public schema
GRANT USAGE ON SCHEMA public TO airflowuser;

-- Grant necessary table permissions
GRANT CREATE, SELECT, INSERT, UPDATE, DELETE, TRIGGER ON ALL TABLES IN SCHEMA public TO airflowuser;

-- Grant necessary sequence permissions
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO airflowuser;

-- Grant the ability to create indexes
GRANT CREATE ON DATABASE airflowdb TO airflowuser;

-- Allow user to create schemas (needed by Superset for metadata)
GRANT CREATE ON DATABASE airflowdb TO airflowuser;

-- Allow user to create tables and modify metadata
GRANT CREATE, SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO airflowuser;

-- Optional: Grant the user the ability to grant these permissions to others
GRANT ALL PRIVILEGES ON DATABASE airflowdb TO airflowuser;
