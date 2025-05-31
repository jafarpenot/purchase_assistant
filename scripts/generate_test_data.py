import asyncio
import random
from datetime import datetime, timedelta, timezone
from decimal import Decimal
import json
from typing import List, Dict, Any
import asyncpg
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
from app.models.company import CompanyBase, Supplier, PurchaseRequest, PurchaseOrder, PurchaseOrderItem, SupplierPerformance
from app.models.app import AppBase, PurchaseApproval, UserFeedback
from app.config import settings

# Database URLs (without asyncpg driver for SQLAlchemy)
COMPANY_DB_URL = settings.COMPANY_DB_URL.replace("+asyncpg", "")
APP_DB_URL = settings.APP_DB_URL.replace("+asyncpg", "")

# Create database engines
company_engine = create_engine(COMPANY_DB_URL)
app_engine = create_engine(APP_DB_URL)

# Create session factories
CompanySession = sessionmaker(bind=company_engine)
AppSession = sessionmaker(bind=app_engine)

# Test data constants
DEPARTMENTS = ["IT", "HR", "Finance", "Operations", "Marketing"]
CATEGORIES = ["Electronics", "Office Supplies", "Furniture", "Software", "Services"]
URGENCY_LEVELS = ["Low", "Medium", "High"]
APPROVERS = ["John Smith", "Sarah Johnson", "Michael Brown", "Emily Davis", "David Wilson"]
FEEDBACK_TYPES = ["Satisfaction", "Issue", "Suggestion"]

# Product catalog with price ranges
PRODUCTS = {
    "Electronics": [
        {"name": "Laptop", "min_price": 400, "max_price": 800, "unit": "pcs"},
        {"name": "Monitor", "min_price": 150, "max_price": 300, "unit": "pcs"},
        {"name": "Keyboard", "min_price": 50, "max_price": 100, "unit": "pcs"},
        {"name": "Mouse", "min_price": 20, "max_price": 50, "unit": "pcs"},
        {"name": "Headset", "min_price": 30, "max_price": 150, "unit": "pcs"}
    ],
    "Office Supplies": [
        {"name": "Printing Paper", "min_price": 5, "max_price": 15, "unit": "box"},
        {"name": "Stapler", "min_price": 10, "max_price": 25, "unit": "pcs"},
        {"name": "Pen Set", "min_price": 8, "max_price": 20, "unit": "set"},
        {"name": "Notebook", "min_price": 3, "max_price": 10, "unit": "pcs"},
        {"name": "Sticky Notes", "min_price": 2, "max_price": 8, "unit": "pack"}
    ],
    "Furniture": [
        {"name": "Office Chair", "min_price": 100, "max_price": 300, "unit": "pcs"},
        {"name": "Desk", "min_price": 200, "max_price": 500, "unit": "pcs"},
        {"name": "Filing Cabinet", "min_price": 150, "max_price": 400, "unit": "pcs"},
        {"name": "Bookshelf", "min_price": 80, "max_price": 250, "unit": "pcs"},
        {"name": "Conference Table", "min_price": 500, "max_price": 2000, "unit": "pcs"}
    ]
}

# Supplier data
SUPPLIERS = [
    {
        "name": "Office Supplies Co",
        "category": "Office Supplies",
        "rating": 4.5,
        "contact_email": "contact@officesupplies.com",
        "contact_phone": "+1-555-0101",
        "payment_terms": "Net 30",
        "delivery_lead_time": 3,
        "is_active": True
    },
    {
        "name": "Tech Solutions Inc",
        "category": "Electronics",
        "rating": 4.8,
        "contact_email": "sales@techsolutions.com",
        "contact_phone": "+1-555-0102",
        "payment_terms": "Net 45",
        "delivery_lead_time": 5,
        "is_active": True
    },
    {
        "name": "Furniture World",
        "category": "Furniture",
        "rating": 4.2,
        "contact_email": "orders@furnitureworld.com",
        "contact_phone": "+1-555-0103",
        "payment_terms": "Net 60",
        "delivery_lead_time": 7,
        "is_active": True
    },
    {
        "name": "Digital Solutions",
        "category": "Electronics",
        "rating": 4.6,
        "contact_email": "support@digitalsolutions.com",
        "contact_phone": "+1-555-0104",
        "payment_terms": "Net 30",
        "delivery_lead_time": 4,
        "is_active": True
    },
    {
        "name": "Office Essentials",
        "category": "Office Supplies",
        "rating": 4.3,
        "contact_email": "info@officeessentials.com",
        "contact_phone": "+1-555-0105",
        "payment_terms": "Net 30",
        "delivery_lead_time": 2,
        "is_active": True
    }
]

def random_date(start_date: datetime, end_date: datetime) -> datetime:
    """Generate a random date between start_date and end_date."""
    # Ensure both dates are timezone-aware
    if start_date.tzinfo is None:
        start_date = start_date.replace(tzinfo=timezone.utc)
    if end_date.tzinfo is None:
        end_date = end_date.replace(tzinfo=timezone.utc)
    
    time_between_dates = end_date - start_date
    days_between_dates = time_between_dates.days
    random_days = random.randrange(days_between_dates)
    return start_date + timedelta(days=random_days)

def generate_purchase_requests(num_requests: int, start_date: datetime, end_date: datetime) -> List[Dict[str, Any]]:
    """Generate purchase requests."""
    requests = []
    for _ in range(num_requests):
        category = random.choice(CATEGORIES)
        product = random.choice(PRODUCTS.get(category, PRODUCTS["Office Supplies"]))
        
        request = {
            "requester_name": f"Employee {random.randint(1, 100)}",
            "department": random.choice(DEPARTMENTS),
            "description": f"Request for {product['name']}",
            "category": category,
            "quantity": random.randint(1, 10),
            "unit": product["unit"],
            "budget": Decimal(str(random.uniform(product["min_price"], product["max_price"]))),
            "urgency_level": random.choice(URGENCY_LEVELS),
            "status": "Pending",
            "created_at": random_date(start_date, end_date)
        }
        requests.append(request)
    return requests

def generate_order_number(date: datetime, sequence: int) -> str:
    """Generate a unique order number."""
    return f"PO-{date.year}-{sequence:03d}"

def generate_purchase_orders(
    requests: List[PurchaseRequest],
    suppliers: List[Supplier],
    start_date: datetime,
    end_date: datetime
) -> List[Dict[str, Any]]:
    """Generate purchase orders for the requests."""
    orders = []
    sequence = 1
    
    for request in requests:
        # 80% chance to create an order for each request
        if random.random() < 0.8:
            supplier = random.choice(suppliers)
            order_date = random_date(request.created_at, end_date)
            
            # Calculate expected delivery date based on supplier's lead time
            expected_delivery = order_date + timedelta(days=supplier.delivery_lead_time)
            
            # 70% chance the order is completed
            is_completed = random.random() < 0.7
            actual_delivery = expected_delivery + timedelta(days=random.randint(-2, 2)) if is_completed else None
            
            # Determine status based on completion
            if is_completed:
                status = "Delivered"
                payment_status = random.choice(["Paid", "Pending"])
            else:
                status = random.choice(["Ordered", "Shipped", "Cancelled"])
                payment_status = "Pending" if status != "Cancelled" else "Cancelled"
            
            order = {
                "purchase_request_id": request.id,
                "supplier_id": supplier.id,
                "order_number": generate_order_number(order_date, sequence),
                "order_date": order_date,
                "expected_delivery_date": expected_delivery,
                "actual_delivery_date": actual_delivery,
                "total_amount": Decimal("0"),  # Will be updated with items
                "currency": "USD",
                "status": status,
                "payment_status": payment_status,
                "notes": f"Order for {request.description}",
                "created_at": order_date
            }
            orders.append(order)
            sequence += 1
    
    return orders

def generate_order_items(
    orders: List[PurchaseOrder],
    requests: List[PurchaseRequest]
) -> List[Dict[str, Any]]:
    """Generate items for each purchase order."""
    items = []
    
    for order in orders:
        request = next(r for r in requests if r.id == order.purchase_request_id)
        category = request.category
        product = random.choice(PRODUCTS.get(category, PRODUCTS["Office Supplies"]))
        
        # Generate 1-3 items per order
        num_items = random.randint(1, 3)
        order_total = Decimal("0")
        
        for _ in range(num_items):
            quantity = random.randint(1, 5)
            # Add small random variation to base price
            base_price = Decimal(str(random.uniform(product["min_price"], product["max_price"])))
            variation = Decimal(str(random.uniform(0.95, 1.05)))
            unit_price = (base_price * variation).quantize(Decimal("0.01"))
            total_price = (unit_price * quantity).quantize(Decimal("0.01"))
            
            item = {
                "purchase_order_id": order.id,
                "item_description": f"{product['name']} - {random.choice(['Standard', 'Premium', 'Basic'])}",
                "quantity": quantity,
                "unit_price": unit_price,
                "unit": product["unit"],
                "total_price": total_price,
                "created_at": order.order_date
            }
            items.append(item)
            order_total += total_price
        
        # Update order total
        order.total_amount = order_total
    
    return items

def generate_supplier_performance(orders: List[PurchaseOrder]) -> List[Dict[str, Any]]:
    """Generate performance records for completed orders."""
    performance_records = []
    
    for order in orders:
        if order.status == "Delivered":
            performance = {
                "supplier_id": order.supplier_id,
                "purchase_order_id": order.id,
                "delivery_rating": random.randint(3, 5),  # Bias towards good ratings
                "quality_rating": random.randint(3, 5),
                "communication_rating": random.randint(3, 5),
                "notes": random.choice([
                    "Good service",
                    "On-time delivery",
                    "Excellent communication",
                    "Quality as expected",
                    "Would order again"
                ]),
                "created_at": order.actual_delivery_date or order.expected_delivery_date
            }
            performance_records.append(performance)
    
    return performance_records

def generate_purchase_approvals(requests: List[PurchaseRequest]) -> List[Dict[str, Any]]:
    """Generate approval records for purchase requests."""
    approvals = []
    
    for request in requests:
        # 90% chance of approval
        is_approved = random.random() < 0.9
        approval_date = request.created_at + timedelta(days=random.randint(1, 3))
        
        approval = {
            "purchase_request_id": request.id,
            "approver_name": random.choice(APPROVERS),
            "approval_status": "Approved" if is_approved else "Rejected",
            "approval_date": approval_date,
            "comments": random.choice([
                "Approved as requested",
                "Budget within limits",
                "Urgent requirement",
                "Need more information",
                "Outside budget"
            ]) if not is_approved else None,
            "created_at": approval_date
        }
        approvals.append(approval)
    
    return approvals

def generate_user_feedback(requests: List[PurchaseRequest]) -> List[Dict[str, Any]]:
    """Generate user feedback for some purchase requests."""
    feedback_records = []
    
    for request in requests:
        # 30% chance of feedback
        if random.random() < 0.3:
            feedback_date = request.created_at + timedelta(days=random.randint(1, 10))
            feedback_type = random.choice(FEEDBACK_TYPES)
            
            feedback = {
                "purchase_request_id": request.id,
                "feedback_type": feedback_type,
                "feedback_text": random.choice([
                    "Very satisfied with the process",
                    "Could be faster",
                    "Good communication",
                    "Need better tracking",
                    "Smooth approval process"
                ]),
                "feedback_metadata": json.dumps({
                    "satisfaction_level": random.randint(1, 5),
                    "response_time": random.randint(1, 5),
                    "process_rating": random.randint(1, 5)
                }),
                "created_at": feedback_date
            }
            feedback_records.append(feedback)
    
    return feedback_records

async def generate_test_data():
    """Main function to generate and insert test data."""
    # Create database sessions
    company_session = CompanySession()
    app_session = AppSession()
    
    try:
        # 1. Check and create suppliers if needed
        print("Checking suppliers...")
        existing_suppliers = company_session.query(Supplier).all()
        if existing_suppliers:
            print(f"Found {len(existing_suppliers)} existing suppliers")
            suppliers = existing_suppliers
        else:
            print("Creating suppliers...")
            suppliers = []
            for supplier_data in SUPPLIERS:
                supplier = Supplier(**supplier_data)
                company_session.add(supplier)
                suppliers.append(supplier)
            company_session.commit()
            print(f"Created {len(suppliers)} suppliers")

        # 2. Check and create purchase requests if needed
        print("Checking purchase requests...")
        existing_requests = company_session.query(PurchaseRequest).all()
        if existing_requests:
            print(f"Found {len(existing_requests)} existing purchase requests")
            requests = existing_requests
        else:
            print("Generating purchase requests...")
            start_date = datetime.now(timezone.utc) - timedelta(days=5*365)  # 5 years ago
            end_date = datetime.now(timezone.utc)
            request_data = generate_purchase_requests(1000, start_date, end_date)
            
            requests = []
            for data in request_data:
                request = PurchaseRequest(**data)
                company_session.add(request)
                requests.append(request)
            company_session.commit()
            print(f"Created {len(requests)} purchase requests")

        # 3. Check existing orders
        print("Checking existing orders...")
        existing_orders = company_session.query(PurchaseOrder).all()
        if existing_orders:
            print(f"Found {len(existing_orders)} existing orders")
            print("Skipping order generation as orders already exist")
            return

        # 4. Generate purchase orders (only if none exist)
        print("Generating purchase orders...")
        start_date = datetime.now(timezone.utc) - timedelta(days=5*365)
        end_date = datetime.now(timezone.utc)
        order_data = generate_purchase_orders(requests, suppliers, start_date, end_date)
        
        orders = []
        for data in order_data:
            order = PurchaseOrder(**data)
            company_session.add(order)
            orders.append(order)
        company_session.commit()
        print(f"Created {len(orders)} purchase orders")

        # 5. Generate order items
        print("Generating order items...")
        item_data = generate_order_items(orders, requests)
        
        for data in item_data:
            item = PurchaseOrderItem(**data)
            company_session.add(item)
        company_session.commit()
        print(f"Created {len(item_data)} order items")

        # 6. Generate supplier performance records
        print("Generating supplier performance records...")
        performance_data = generate_supplier_performance(orders)
        
        for data in performance_data:
            performance = SupplierPerformance(**data)
            company_session.add(performance)
        company_session.commit()
        print(f"Created {len(performance_data)} performance records")

        # 7. Check and create purchase approvals if needed
        print("Checking purchase approvals...")
        existing_approvals = app_session.query(PurchaseApproval).all()
        if existing_approvals:
            print(f"Found {len(existing_approvals)} existing approvals")
        else:
            print("Generating purchase approvals...")
            approval_data = generate_purchase_approvals(requests)
            
            for data in approval_data:
                approval = PurchaseApproval(**data)
                app_session.add(approval)
            app_session.commit()
            print(f"Created {len(approval_data)} purchase approvals")

        # 8. Check and create user feedback if needed
        print("Checking user feedback...")
        existing_feedback = app_session.query(UserFeedback).all()
        if existing_feedback:
            print(f"Found {len(existing_feedback)} existing feedback records")
        else:
            print("Generating user feedback...")
            feedback_data = generate_user_feedback(requests)
            
            for data in feedback_data:
                feedback = UserFeedback(**data)
                app_session.add(feedback)
            app_session.commit()
            print(f"Created {len(feedback_data)} feedback records")

        print("Test data generation completed successfully!")

    except Exception as e:
        print(f"Error generating test data: {e}")
        company_session.rollback()
        app_session.rollback()
        raise
    finally:
        company_session.close()
        app_session.close()

if __name__ == "__main__":
    asyncio.run(generate_test_data()) 