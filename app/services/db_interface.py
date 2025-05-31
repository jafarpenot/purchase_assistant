import asyncpg
import os
from typing import List, Optional
from ..models.schema import Supplier
from ..config import settings

class DatabaseInterface:
    def __init__(self):
        self.pool: Optional[asyncpg.Pool] = None

    async def connect(self):
        """Create a connection pool to the company database."""
        if not self.pool:
            self.pool = await asyncpg.create_pool(
                user=settings.COMPANY_DB_USER,
                password=settings.COMPANY_DB_PASSWORD,
                database=settings.COMPANY_DB_NAME,
                host=settings.COMPANY_DB_HOST,
                port=settings.COMPANY_DB_PORT
            )

    async def disconnect(self):
        """Close the database connection pool."""
        if self.pool:
            await self.pool.close()
            self.pool = None

    async def get_suppliers(self) -> List[Supplier]:
        """Retrieve all suppliers from the database."""
        async with self.pool.acquire() as conn:
            rows = await conn.fetch("SELECT * FROM suppliers")
            return [Supplier(**dict(row)) for row in rows]

    async def get_supplier_by_id(self, supplier_id: int) -> Optional[Supplier]:
        """Retrieve a specific supplier by ID."""
        async with self.pool.acquire() as conn:
            row = await conn.fetchrow(
                "SELECT * FROM suppliers WHERE id = $1",
                supplier_id
            )
            return Supplier(**dict(row)) if row else None

# Create a singleton instance
db = DatabaseInterface() 