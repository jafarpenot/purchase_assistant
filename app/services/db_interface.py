import asyncpg
import os
from typing import List, Optional
from ..models.schema import Supplier
from ..config import settings
from datetime import datetime, timedelta, timezone
from sqlalchemy import func, desc, and_, or_, select
from sqlalchemy.ext.asyncio import AsyncSession
from ..models.company import PurchaseRequest, PurchaseOrder, PurchaseOrderItem, Supplier as CompanySupplier
from ..models.schema import RecentPurchaseHistory

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

    async def get_recent_similar_purchases(
        self,
        session: AsyncSession,
        description: str,
        category: Optional[str] = None,
        months: int = 3
    ) -> List[RecentPurchaseHistory]:
        """
        Search for recent purchases of similar items within the last N months.
        
        Args:
            session: Async database session
            description: Purchase description to search for
            category: Optional category to filter by
            months: Number of months to look back (default: 3)
            
        Returns:
            List of recent purchase history records
        """
        # Calculate a date threshold (e.g. 3 months ago) so that we only fetch recent purchases.
        date_threshold = datetime.now(timezone.utc) - timedelta(days=months * 30)

        # Build an async query (using select) that joins purchase_requests, purchase_orders, purchase_order_items, and suppliers.
        stmt = select(
            PurchaseRequest.description, PurchaseRequest.category, PurchaseRequest.quantity, PurchaseRequest.unit,
            PurchaseOrderItem.unit_price, PurchaseOrderItem.total_price, CompanySupplier.name.label("supplier_name"),
            PurchaseOrder.order_date, PurchaseOrder.status
        ).join(PurchaseOrder, PurchaseRequest.id == PurchaseOrder.purchase_request_id
        ).join(PurchaseOrderItem, PurchaseOrder.id == PurchaseOrderItem.purchase_order_id
        ).join(CompanySupplier, PurchaseOrder.supplier_id == CompanySupplier.id
        ).filter(PurchaseOrder.order_date >= date_threshold)

        if category:
            stmt = stmt.filter(PurchaseRequest.category == category)

        stmt = stmt.filter(PurchaseRequest.description.ilike(f"%{description}%"))
        stmt = stmt.order_by(PurchaseOrder.order_date.desc())

        # Execute the async query and convert results
        result = await session.execute(stmt)
        rows = result.all()
        
        purchases = [
            RecentPurchaseHistory(
                description=row.description,
                category=row.category,
                quantity=row.quantity,
                unit=row.unit,
                unit_price=row.unit_price,
                total_price=row.total_price,
                supplier_name=row.supplier_name,
                order_date=row.order_date,
                status=row.status
            )
            for row in rows
        ]
        return purchases

# Create a singleton instance
db = DatabaseInterface() 