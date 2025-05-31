import asyncio
import asyncpg
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker
from app.config import settings
from app.models.company import CompanyBase
from app.models.app import AppBase

async def create_databases():
    """Create the databases if they don't exist."""
    # Connect to default postgres database
    sys_conn = await asyncpg.connect(
        user=settings.DB_USER,
        password=settings.DB_PASSWORD,
        host=settings.DB_HOST,
        port=settings.DB_PORT,
        database='postgres'
    )
    
    try:
        # Create purchase_db if it doesn't exist
        await sys_conn.execute(f'''
            SELECT 'CREATE DATABASE purchase_db'
            WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'purchase_db')
        ''')
        
        # Create app_db if it doesn't exist
        await sys_conn.execute(f'''
            SELECT 'CREATE DATABASE app_db'
            WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'app_db')
        ''')
    finally:
        await sys_conn.close()

async def init_company_db():
    """Initialize the company database with tables."""
    engine = create_async_engine(settings.COMPANY_DB_URL, echo=True)
    async with engine.begin() as conn:
        await conn.run_sync(CompanyBase.metadata.drop_all)
        await conn.run_sync(CompanyBase.metadata.create_all)
    await engine.dispose()

async def init_app_db():
    """Initialize the application database with tables."""
    engine = create_async_engine(settings.APP_DB_URL, echo=True)
    async with engine.begin() as conn:
        await conn.run_sync(AppBase.metadata.drop_all)
        await conn.run_sync(AppBase.metadata.create_all)
    await engine.dispose()

async def init_db():
    """Initialize both databases."""
    print("Creating databases...")
    await create_databases()
    
    print("Initializing company database...")
    await init_company_db()
    
    print("Initializing application database...")
    await init_app_db()
    
    print("Database initialization completed!")

if __name__ == "__main__":
    asyncio.run(init_db()) 