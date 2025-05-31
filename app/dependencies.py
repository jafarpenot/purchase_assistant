from typing import Generator
from sqlalchemy.orm import Session
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
from .config import settings

# Create async engines for both databases
company_engine = create_async_engine(settings.COMPANY_DB_URL)
app_engine = create_async_engine(settings.APP_DB_URL)

# Create async session factories
CompanyAsyncSession = sessionmaker(
    company_engine,
    class_=AsyncSession,
    expire_on_commit=False,
    autocommit=False,
    autoflush=False
)

AppAsyncSession = sessionmaker(
    app_engine,
    class_=AsyncSession,
    expire_on_commit=False,
    autocommit=False,
    autoflush=False
)

async def get_company_db() -> Generator[AsyncSession, None, None]:
    """
    Dependency for getting a company database session.
    Yields an async session and ensures it's closed after use.
    """
    async with CompanyAsyncSession() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
        finally:
            await session.close()

async def get_app_db() -> Generator[AsyncSession, None, None]:
    """
    Dependency for getting an app database session.
    Yields an async session and ensures it's closed after use.
    """
    async with AppAsyncSession() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
        finally:
            await session.close() 