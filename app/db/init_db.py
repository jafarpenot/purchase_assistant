import asyncio
import asyncpg

async def create_company_database():
    """Create purchase_db using company_user credentials."""
    sys_conn = await asyncpg.connect(
        user="company_user",  # matches POSTGRES_USER in docker-compose.yml
        password="company_password",  # matches POSTGRES_PASSWORD in docker-compose.yml
        host="company_postgres",
        port=5432,
        database="postgres"
    )
    try:
        # Create purchase_db if it doesn't exist
        await sys_conn.execute("""
            SELECT 'CREATE DATABASE purchase_db' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'purchase_db')
        """)
    finally:
        await sys_conn.close()

async def create_app_database():
    """Create app_db using app_user credentials."""
    sys_conn = await asyncpg.connect(
        user="app_user",  # matches POSTGRES_USER in docker-compose.yml
        password="app_password",  # matches POSTGRES_PASSWORD in docker-compose.yml
        host="app_postgres",
        port=5432,
        database="postgres"
    )
    try:
        # Create app_db if it doesn't exist
        await sys_conn.execute("""
            SELECT 'CREATE DATABASE app_db' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'app_db')
        """)
    finally:
        await sys_conn.close()

async def init_db():
    print("Creating (minimal) databases (checkpoint: no alchemy, no migrations)…")
    print("Creating company database (purchase_db)...")
    await create_company_database()
    print("Creating app database (app_db)...")
    await create_app_database()
    print("(Minimal) DB init (checkpoint) completed.")

if __name__ == "__main__":
    asyncio.run(init_db()) 