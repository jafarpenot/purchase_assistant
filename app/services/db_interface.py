from typing import List, Optional, AsyncGenerator, AsyncContextManager
from ..models.schema import Supplier
from ..config import settings
from datetime import datetime, timedelta, timezone
from sqlalchemy import func, desc, and_, or_, select
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker
from ..models.company import PurchaseRequest, PurchaseOrder, PurchaseOrderItem, Supplier as CompanySupplier
from ..models.schema import RecentPurchaseHistory

class DatabaseInterface:
    def __init__(self):
        # Create async engine using the full URL from settings
        self.engine = create_async_engine(
            settings.COMPANY_DB_URL,
            echo=False
        )
        # Create async session factory
        self.async_session = async_sessionmaker(
            self.engine,
            class_=AsyncSession,
            expire_on_commit=False
        )

    async def get_session(self) -> AsyncContextManager[AsyncSession]:
        """
        Get an async database session.
        
        Returns:
            AsyncContextManager[AsyncSession]: An async context manager that yields a session
        """
        return self.async_session()

    async def get_suppliers(self, session: AsyncSession) -> List[Supplier]:
        """
        Retrieve all suppliers from the database using SQLAlchemy.
        
        Args:
            session: SQLAlchemy async session
            
        Returns:
            List of Supplier objects
        """
        query = select(CompanySupplier)
        result = await session.execute(query)
        suppliers = result.scalars().all()
        return [Supplier.model_validate(supplier) for supplier in suppliers]

    async def get_supplier_by_id(self, session: AsyncSession, supplier_id: int) -> Optional[Supplier]:
        """
        Retrieve a specific supplier by ID using SQLAlchemy.
        
        Args:
            session: SQLAlchemy async session
            supplier_id: ID of the supplier to retrieve
            
        Returns:
            Optional[Supplier]: Supplier object if found, None otherwise
        """
        query = select(CompanySupplier).where(CompanySupplier.id == supplier_id)
        result = await session.execute(query)
        supplier = result.scalar_one_or_none()
        return Supplier.model_validate(supplier) if supplier else None

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
            session: SQLAlchemy async session
            description: Purchase description to search for
            category: Optional category to filter by
            months: Number of months to look back (default: 3)
            
        Returns:
            List of recent purchase history records
        """
        # Calculate date threshold
        date_threshold = datetime.now(timezone.utc) - timedelta(days=months * 30)

        # Build query using SQLAlchemy
        stmt = select(
            PurchaseRequest.description,
            PurchaseRequest.category,
            PurchaseRequest.quantity,
            PurchaseRequest.unit,
            PurchaseOrderItem.unit_price,
            PurchaseOrderItem.total_price,
            CompanySupplier.name.label("supplier_name"),
            PurchaseOrder.order_date,
            PurchaseOrder.status
        ).join(
            PurchaseOrder,
            PurchaseRequest.id == PurchaseOrder.purchase_request_id
        ).join(
            PurchaseOrderItem,
            PurchaseOrder.id == PurchaseOrderItem.purchase_order_id
        ).join(
            CompanySupplier,
            PurchaseOrder.supplier_id == CompanySupplier.id
        ).where(
            PurchaseOrder.order_date >= date_threshold
        )

        if category:
            stmt = stmt.where(PurchaseRequest.category == category)

        stmt = stmt.where(PurchaseRequest.description.ilike(f"%{description}%"))
        stmt = stmt.order_by(PurchaseOrder.order_date.desc())

        # Execute query
        result = await session.execute(stmt)
        rows = result.all()
        
        # Convert to RecentPurchaseHistory objects
        return [
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

# Create a singleton instance
db = DatabaseInterface() 