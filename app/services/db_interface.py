import asyncpg
import os
from typing import List, Optional
from ..models.schema import Supplier, PurchaseHistory

class DatabaseInterface:
    def __init__(self):
        self.pool: Optional[asyncpg.Pool] = None

    async def connect(self):
        """Create a connection pool to the database."""
        if not self.pool:
            self.pool = await asyncpg.create_pool(
                user=os.getenv("POSTGRES_USER"),
                password=os.getenv("POSTGRES_PASSWORD"),
                database=os.getenv("POSTGRES_DB"),
                host=os.getenv("POSTGRES_HOST"),
                port=os.getenv("POSTGRES_PORT")
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

    async def get_purchase_history(self, supplier_id: Optional[int] = None) -> List[PurchaseHistory]:
        """Retrieve purchase history, optionally filtered by supplier."""
        async with self.pool.acquire() as conn:
            if supplier_id:
                rows = await conn.fetch(
                    "SELECT * FROM purchase_history WHERE supplier_id = $1",
                    supplier_id
                )
            else:
                rows = await conn.fetch("SELECT * FROM purchase_history")
            return [PurchaseHistory(**dict(row)) for row in rows]

# Create a singleton instance
db = DatabaseInterface() 