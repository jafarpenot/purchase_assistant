#!/usr/bin/env python3
import os
import sys
from pathlib import Path

# Add the project root to Python path
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))

from alembic.config import Config
from alembic import command
from app.config import settings

def run_migrations():
    print("Running database migrations...")
    
    # Run company database migrations
    print("\nRunning company database migrations...")
    company_alembic_cfg = Config(str(project_root / "alembic" / "company" / "alembic.ini"))
    command.upgrade(company_alembic_cfg, "head")
    
    # Run app database migrations
    print("\nRunning app database migrations...")
    app_alembic_cfg = Config(str(project_root / "alembic" / "app" / "alembic.ini"))
    command.upgrade(app_alembic_cfg, "head")
    
    print("\nAll migrations completed successfully!")

if __name__ == "__main__":
    run_migrations() 