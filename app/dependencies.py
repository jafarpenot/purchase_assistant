from typing import Generator
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
from .config import settings

# Create async engine for app database
app_engine = create_async_engine(settings.APP_DB_URL)

# Create async session factory for app database
AppAsyncSession = sessionmaker(
    app_engine,
    class_=AsyncSession,
    expire_on_commit=False,
    autocommit=False,
    autoflush=False
)

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