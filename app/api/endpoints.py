from fastapi import APIRouter, HTTPException, Query, Depends
from ..models.schema import PurchaseRequestCreate, PurchaseRequest, RecommendationResponse, Supplier, RecentPurchaseResponse
from ..services.agent import agent
from ..services.db_interface import db
from typing import List, Optional
from decimal import Decimal
from sqlalchemy.orm import Session
from ..dependencies import get_company_db
import logging
import traceback

router = APIRouter()

@router.post("/recommend", response_model=RecommendationResponse)
async def get_recommendation(request: PurchaseRequestCreate):
    """
    Get a supplier recommendation based on the purchase request.
    """
    try:
        print(f"Received request: {request.dict()}")  # Debug log
        return await agent.get_recommendation(request)
    except Exception as e:
        print(f"Error in /recommend endpoint: {str(e)}")  # Debug log
        if hasattr(e, 'response') and hasattr(e.response, 'json'):
            print(f"Error details: {e.response.json()}")  # Debug log
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/suppliers", response_model=List[Supplier])
async def get_suppliers():
    """
    Get a list of all available suppliers.
    """
    try:
        return await db.get_suppliers()
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/suppliers/{supplier_id}", response_model=Supplier)
async def get_supplier(supplier_id: int):
    """
    Get details for a specific supplier.
    """
    try:
        supplier = await db.get_supplier_by_id(supplier_id)
        if not supplier:
            raise HTTPException(status_code=404, detail="Supplier not found")
        return supplier
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/recent-purchases", response_model=RecentPurchaseResponse)
async def get_recent_purchases(
    description: str = Query(..., description="Purchase description to search for"),
    category: Optional[str] = Query(None, description="Optional category to filter by"),
    months: int = Query(3, ge=1, le=12, description="Number of months to look back"),
    company_db: Session = Depends(get_company_db)
):
    """
    Get recent purchase history of similar items.
    
    Args:
        description: Purchase description to search for
        category: Optional category to filter by
        months: Number of months to look back (1-12)
        company_db: Database session dependency
        
    Returns:
        RecentPurchaseResponse with similar purchases and statistics
    """
    logger = logging.getLogger(__name__)
    try:
        # Get recent purchases
        purchases = await db.get_recent_similar_purchases(
            session=company_db,
            description=description,
            category=category,
            months=months
        )
        
        # Calculate statistics
        total_count = len(purchases)
        average_price = None
        most_common_supplier = None
        
        if purchases:
            # Calculate average unit price
            total_price = sum(p.unit_price for p in purchases)
            average_price = (total_price / total_count).quantize(Decimal("0.01"))
            
            # Find most common supplier
            supplier_counts = {}
            for purchase in purchases:
                supplier_counts[purchase.supplier_name] = supplier_counts.get(purchase.supplier_name, 0) + 1
            most_common_supplier = max(supplier_counts.items(), key=lambda x: x[1])[0]
        
        return RecentPurchaseResponse(
            similar_purchases=purchases,
            total_count=total_count,
            average_price=average_price,
            most_common_supplier=most_common_supplier
        )
        
    except Exception as e:
        logger.error("Error in /recent-purchases endpoint: %s", e, exc_info=True)
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=str(e)) 