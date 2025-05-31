/*
Reference SQL Schema
-------------------
This file contains the raw SQL schema definitions for reference purposes.
For actual database initialization, use app/db/init_db.py
Last updated: 2024-03-18
*/

-- Create both databases
-- CREATE DATABASE purchase_db;
-- CREATE DATABASE app_db;

-- Connect to purchase_db for company data
\c purchase_db

-- Company Database Schema (purchase_db)
-- This database stores all business-related data

-- Suppliers: Core information about suppliers
CREATE TABLE IF NOT EXISTS suppliers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    rating DECIMAL(3,2) CHECK (rating >= 0 AND rating <= 5),
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20),
    payment_terms VARCHAR(50),  -- e.g., "Net 30", "Net 60"
    delivery_lead_time INTEGER, -- average days for delivery
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Purchase Requests: Initial requests for purchases
CREATE TABLE IF NOT EXISTS purchase_requests (
    id SERIAL PRIMARY KEY,
    requester_name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    description TEXT NOT NULL,
    category VARCHAR(50),
    quantity INTEGER NOT NULL,
    unit VARCHAR(20),  -- e.g., "pcs", "kg", "box"
    budget DECIMAL(10,2),
    urgency_level VARCHAR(20) CHECK (urgency_level IN ('Low', 'Medium', 'High')),
    status VARCHAR(20) DEFAULT 'Pending',  -- e.g., "Pending", "Approved", "Rejected", "Completed"
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Purchase Orders: Actual orders placed with suppliers
CREATE TABLE IF NOT EXISTS purchase_orders (
    id SERIAL PRIMARY KEY,
    purchase_request_id INTEGER REFERENCES purchase_requests(id),
    supplier_id INTEGER REFERENCES suppliers(id),
    order_number VARCHAR(50) UNIQUE NOT NULL,
    order_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    expected_delivery_date TIMESTAMP WITH TIME ZONE,
    actual_delivery_date TIMESTAMP WITH TIME ZONE,
    total_amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    status VARCHAR(20) DEFAULT 'Ordered',  -- e.g., "Ordered", "Shipped", "Delivered", "Cancelled"
    payment_status VARCHAR(20) DEFAULT 'Pending',  -- e.g., "Pending", "Paid", "Overdue"
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Purchase Order Items: Individual items within an order
CREATE TABLE IF NOT EXISTS purchase_order_items (
    id SERIAL PRIMARY KEY,
    purchase_order_id INTEGER REFERENCES purchase_orders(id),
    item_description TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    unit VARCHAR(20),
    total_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Supplier Performance: Historical performance metrics
CREATE TABLE IF NOT EXISTS supplier_performance (
    id SERIAL PRIMARY KEY,
    supplier_id INTEGER REFERENCES suppliers(id),
    purchase_order_id INTEGER REFERENCES purchase_orders(id),
    delivery_rating INTEGER CHECK (delivery_rating >= 1 AND delivery_rating <= 5),
    quality_rating INTEGER CHECK (quality_rating >= 1 AND quality_rating <= 5),
    communication_rating INTEGER CHECK (communication_rating >= 1 AND communication_rating <= 5),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Switch to app database for application-specific tables
\c app_db

-- Application Logs: System and user activity logs
CREATE TABLE IF NOT EXISTS application_logs (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    level VARCHAR(20) NOT NULL,  -- e.g., "INFO", "WARNING", "ERROR"
    message TEXT NOT NULL,
    context JSONB  -- Flexible storage for additional log data
);

-- Purchase Approvals: Approval workflow tracking
CREATE TABLE IF NOT EXISTS purchase_approvals (
    id SERIAL PRIMARY KEY,
    purchase_request_id INTEGER NOT NULL,  -- References purchase_requests in purchase_db
    approver_name VARCHAR(100) NOT NULL,
    approval_status VARCHAR(20) NOT NULL,  -- e.g., "Pending", "Approved", "Rejected"
    approval_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    comments TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- User Feedback: User feedback and suggestions
CREATE TABLE IF NOT EXISTS user_feedback (
    id SERIAL PRIMARY KEY,
    purchase_request_id INTEGER NOT NULL,  -- References purchase_requests in purchase_db
    feedback_type VARCHAR(50) NOT NULL,  -- e.g., "Supplier Selection", "Process", "UI"
    feedback_text TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    metadata JSONB  -- Flexible storage for additional feedback data
); 