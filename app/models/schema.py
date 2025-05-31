from pydantic import BaseModel, Field, ConfigDict
from typing import List, Optional, Dict, Any
from datetime import datetime
from decimal import Decimal

# Base schemas for common fields
class TimestampMixin(BaseModel):
    created_at: datetime
    updated_at: Optional[datetime] = None

# Supplier schemas
class SupplierBase(BaseModel):
    name: str = Field(..., min_length=1, max_length=100)
    category: str = Field(..., min_length=1, max_length=50)
    contact_email: Optional[str] = Field(None, max_length=100)
    contact_phone: Optional[str] = Field(None, max_length=20)
    payment_terms: Optional[str] = Field(None, max_length=50)
    delivery_lead_time: Optional[int] = Field(None, ge=0)
    is_active: bool = True

class SupplierCreate(SupplierBase):
    pass

class SupplierUpdate(BaseModel):
    name: Optional[str] = Field(None, min_length=1, max_length=100)
    category: Optional[str] = Field(None, min_length=1, max_length=50)
    rating: Optional[float] = Field(None, ge=0, le=5)
    contact_email: Optional[str] = Field(None, max_length=100)
    contact_phone: Optional[str] = Field(None, max_length=20)
    payment_terms: Optional[str] = Field(None, max_length=50)
    delivery_lead_time: Optional[int] = Field(None, ge=0)
    is_active: Optional[bool] = None

class Supplier(SupplierBase, TimestampMixin):
    id: int
    rating: Optional[float] = Field(None, ge=0, le=5)
    model_config = ConfigDict(from_attributes=True)

# Purchase Request schemas
class PurchaseRequestBase(BaseModel):
    requester_name: str = Field(..., min_length=1, max_length=100)
    department: Optional[str] = Field(None, max_length=50)
    description: str = Field(..., min_length=1)
    category: Optional[str] = Field(None, max_length=50)
    quantity: int = Field(..., gt=0)
    unit: Optional[str] = Field(None, max_length=20)
    budget: Optional[Decimal] = Field(None, ge=0)
    urgency_level: Optional[str] = Field(None, pattern='^(Low|Medium|High)$')

class PurchaseRequestCreate(PurchaseRequestBase):
    pass

class PurchaseRequestUpdate(BaseModel):
    description: Optional[str] = Field(None, min_length=1)
    category: Optional[str] = Field(None, max_length=50)
    quantity: Optional[int] = Field(None, gt=0)
    unit: Optional[str] = Field(None, max_length=20)
    budget: Optional[Decimal] = Field(None, ge=0)
    urgency_level: Optional[str] = Field(None, pattern='^(Low|Medium|High)$')
    status: Optional[str] = None

class PurchaseRequest(PurchaseRequestBase, TimestampMixin):
    id: int
    status: str
    model_config = ConfigDict(from_attributes=True)

# Purchase Order schemas
class PurchaseOrderItemBase(BaseModel):
    item_description: str = Field(..., min_length=1)
    quantity: int = Field(..., gt=0)
    unit_price: Decimal = Field(..., ge=0)
    unit: Optional[str] = Field(None, max_length=20)

class PurchaseOrderItemCreate(PurchaseOrderItemBase):
    pass

class PurchaseOrderItem(PurchaseOrderItemBase):
    id: int
    purchase_order_id: int
    total_price: Decimal
    created_at: datetime
    model_config = ConfigDict(from_attributes=True)

class PurchaseOrderBase(BaseModel):
    purchase_request_id: int
    supplier_id: int
    order_number: str = Field(..., min_length=1, max_length=50)
    expected_delivery_date: Optional[datetime] = None
    total_amount: Decimal = Field(..., ge=0)
    currency: str = Field(..., min_length=3, max_length=3)
    notes: Optional[str] = None

class PurchaseOrderCreate(PurchaseOrderBase):
    items: List[PurchaseOrderItemCreate]

class PurchaseOrderUpdate(BaseModel):
    expected_delivery_date: Optional[datetime] = None
    actual_delivery_date: Optional[datetime] = None
    status: Optional[str] = None
    payment_status: Optional[str] = None
    notes: Optional[str] = None

class PurchaseOrder(PurchaseOrderBase, TimestampMixin):
    id: int
    order_date: datetime
    actual_delivery_date: Optional[datetime]
    status: str
    payment_status: str
    items: List[PurchaseOrderItem]
    model_config = ConfigDict(from_attributes=True)

# Supplier Performance schemas
class SupplierPerformanceBase(BaseModel):
    supplier_id: int
    purchase_order_id: int
    delivery_rating: int = Field(..., ge=1, le=5)
    quality_rating: int = Field(..., ge=1, le=5)
    communication_rating: int = Field(..., ge=1, le=5)
    notes: Optional[str] = None

class SupplierPerformanceCreate(SupplierPerformanceBase):
    pass

class SupplierPerformance(SupplierPerformanceBase):
    id: int
    created_at: datetime
    model_config = ConfigDict(from_attributes=True)

# Application schemas
class ApplicationLogBase(BaseModel):
    level: str = Field(..., min_length=1, max_length=20)
    message: str = Field(..., min_length=1)
    context: Optional[Dict[str, Any]] = None

class ApplicationLogCreate(ApplicationLogBase):
    pass

class ApplicationLog(ApplicationLogBase):
    id: int
    timestamp: datetime
    model_config = ConfigDict(from_attributes=True)

class PurchaseApprovalBase(BaseModel):
    purchase_request_id: int
    approver_name: str = Field(..., min_length=1, max_length=100)
    approval_status: str = Field(..., min_length=1, max_length=20)
    comments: Optional[str] = None

class PurchaseApprovalCreate(PurchaseApprovalBase):
    pass

class PurchaseApproval(PurchaseApprovalBase):
    id: int
    approval_date: datetime
    created_at: datetime
    model_config = ConfigDict(from_attributes=True)

class UserFeedbackBase(BaseModel):
    purchase_request_id: int
    feedback_type: str = Field(..., min_length=1, max_length=50)
    feedback_text: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None

class UserFeedbackCreate(UserFeedbackBase):
    pass

class UserFeedback(UserFeedbackBase):
    id: int
    created_at: datetime
    model_config = ConfigDict(from_attributes=True)

# Response schemas
class RecommendationResponse(BaseModel):
    supplier: Supplier
    confidence_score: float = Field(..., ge=0, le=1)
    reasoning: str
    alternative_suppliers: List[Supplier] = [] 