#!/bin/bash

# Check if database URLs are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <company_db_url> <app_db_url>"
    echo "Example: $0 postgresql://company_user:password@dpg-xxxxx-a.oregon-postgres.render.com:5432/purchase_db postgresql://app_user:password@dpg-yyyyy-a.oregon-postgres.render.com:5432/app_db"
    exit 1
fi

COMPANY_DB_URL=$1
APP_DB_URL=$2

echo "Restoring company database..."
psql "$COMPANY_DB_URL" < company_db_dump.sql

echo "Restoring app database..."
psql "$APP_DB_URL" < app_db_dump.sql

echo "Done!" 