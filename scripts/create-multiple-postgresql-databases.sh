#!/bin/bash

set -e
set -u

function create_user_and_database() {
    local database=$1
    echo "Creating user and database '$database'"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
        CREATE DATABASE $database;
        GRANT ALL PRIVILEGES ON DATABASE $database TO $POSTGRES_USER;
EOSQL
}

# Create app_db
create_user_and_database app_db

# Create purchase_db (already created by POSTGRES_DB)
echo "Database purchase_db already exists (created by POSTGRES_DB)"

# Grant privileges on purchase_db
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    GRANT ALL PRIVILEGES ON DATABASE purchase_db TO $POSTGRES_USER;
EOSQL 