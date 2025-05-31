from datetime import datetime
from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey, JSON
from sqlalchemy.orm import declarative_base, relationship
from sqlalchemy.sql import func

AppBase = declarative_base()

class ApplicationLog(AppBase):
    __tablename__ = 'application_logs'

    id = Column(Integer, primary_key=True)
    timestamp = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    level = Column(String(20), nullable=False)
    message = Column(Text, nullable=False)
    context = Column(JSON, nullable=True)

class PurchaseApproval(AppBase):
    __tablename__ = 'purchase_approvals'

    id = Column(Integer, primary_key=True)
    purchase_request_id = Column(Integer, nullable=False)  # References purchase_requests in company_db
    approver_name = Column(String(100), nullable=False)
    approval_status = Column(String(20), nullable=False)
    approval_date = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    comments = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

class UserFeedback(AppBase):
    __tablename__ = 'user_feedback'

    id = Column(Integer, primary_key=True)
    purchase_request_id = Column(Integer, nullable=False)  # References purchase_requests in company_db
    feedback_type = Column(String(50), nullable=False)
    feedback_text = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    feedback_metadata = Column(JSON, nullable=True) 