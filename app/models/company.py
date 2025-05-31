from datetime import datetime
from sqlalchemy import Column, Integer, String, Text, Numeric, Boolean, DateTime, ForeignKey, CheckConstraint
from sqlalchemy.orm import declarative_base, relationship
from sqlalchemy.sql import func

CompanyBase = declarative_base()

class Supplier(CompanyBase):
    __tablename__ = 'suppliers'

    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)
    category = Column(String(50), nullable=False)
    rating = Column(Numeric(3, 2), nullable=True)
    contact_email = Column(String(100), nullable=True)
    contact_phone = Column(String(20), nullable=True)
    payment_terms = Column(String(50), nullable=True)
    delivery_lead_time = Column(Integer, nullable=True)
    is_active = Column(Boolean, server_default='true', nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    # Relationships
    purchase_orders = relationship("PurchaseOrder", back_populates="supplier")
    performance_records = relationship("SupplierPerformance", back_populates="supplier")

    __table_args__ = (
        CheckConstraint('rating >= 0 AND rating <= 5', name='check_rating_range'),
    )

class PurchaseRequest(CompanyBase):
    __tablename__ = 'purchase_requests'

    id = Column(Integer, primary_key=True)
    requester_name = Column(String(100), nullable=False)
    department = Column(String(50), nullable=True)
    description = Column(Text, nullable=False)
    category = Column(String(50), nullable=True)
    quantity = Column(Integer, nullable=False)
    unit = Column(String(20), nullable=True)
    budget = Column(Numeric(10, 2), nullable=True)
    urgency_level = Column(String(20), nullable=True)
    status = Column(String(20), server_default='Pending', nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    # Relationships
    purchase_orders = relationship("PurchaseOrder", back_populates="purchase_request")

    __table_args__ = (
        CheckConstraint("urgency_level IN ('Low', 'Medium', 'High')", name='check_urgency_level'),
    )

class PurchaseOrder(CompanyBase):
    __tablename__ = 'purchase_orders'

    id = Column(Integer, primary_key=True)
    purchase_request_id = Column(Integer, ForeignKey('purchase_requests.id'), nullable=False)
    supplier_id = Column(Integer, ForeignKey('suppliers.id'), nullable=False)
    order_number = Column(String(50), nullable=False, unique=True)
    order_date = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    expected_delivery_date = Column(DateTime(timezone=True), nullable=True)
    actual_delivery_date = Column(DateTime(timezone=True), nullable=True)
    total_amount = Column(Numeric(10, 2), nullable=False)
    currency = Column(String(3), server_default='USD', nullable=False)
    status = Column(String(20), server_default='Ordered', nullable=False)
    payment_status = Column(String(20), server_default='Pending', nullable=False)
    notes = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    # Relationships
    purchase_request = relationship("PurchaseRequest", back_populates="purchase_orders")
    supplier = relationship("Supplier", back_populates="purchase_orders")
    items = relationship("PurchaseOrderItem", back_populates="purchase_order")
    performance_record = relationship("SupplierPerformance", back_populates="purchase_order", uselist=False)

class PurchaseOrderItem(CompanyBase):
    __tablename__ = 'purchase_order_items'

    id = Column(Integer, primary_key=True)
    purchase_order_id = Column(Integer, ForeignKey('purchase_orders.id'), nullable=False)
    item_description = Column(Text, nullable=False)
    quantity = Column(Integer, nullable=False)
    unit_price = Column(Numeric(10, 2), nullable=False)
    unit = Column(String(20), nullable=True)
    total_price = Column(Numeric(10, 2), nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    # Relationships
    purchase_order = relationship("PurchaseOrder", back_populates="items")

class SupplierPerformance(CompanyBase):
    __tablename__ = 'supplier_performance'

    id = Column(Integer, primary_key=True)
    supplier_id = Column(Integer, ForeignKey('suppliers.id'), nullable=False)
    purchase_order_id = Column(Integer, ForeignKey('purchase_orders.id'), nullable=False)
    delivery_rating = Column(Integer, nullable=False)
    quality_rating = Column(Integer, nullable=False)
    communication_rating = Column(Integer, nullable=False)
    notes = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    # Relationships
    supplier = relationship("Supplier", back_populates="performance_records")
    purchase_order = relationship("PurchaseOrder", back_populates="performance_record")

    __table_args__ = (
        CheckConstraint('delivery_rating >= 1 AND delivery_rating <= 5', name='check_delivery_rating'),
        CheckConstraint('quality_rating >= 1 AND quality_rating <= 5', name='check_quality_rating'),
        CheckConstraint('communication_rating >= 1 AND communication_rating <= 5', name='check_communication_rating'),
    ) 