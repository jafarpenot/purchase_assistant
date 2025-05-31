from fastapi import APIRouter, HTTPException
from ..models.schema import PurchaseRequest, RecommendationResponse
from ..services.agent import agent
from ..services.db_interface import db
from typing import List
from ..models.schema import Supplier, PurchaseHistory

router = APIRouter()

@router.post("/recommend", response_model=RecommendationResponse)
async def get_recommendation(request: PurchaseRequest):
    """
    Get a supplier recommendation based on the purchase request.
    """
    try:
        return await agent.get_recommendation(request)
    except Exception as e:
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

@router.get("/purchase-history", response_model=List[PurchaseHistory])
async def get_purchase_history(supplier_id: int = None):
    """
    Get purchase history, optionally filtered by supplier.
    """
    try:
        return await db.get_purchase_history(supplier_id)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e)) 