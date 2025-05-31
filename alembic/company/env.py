from logging.config import fileConfig
import os
from sqlalchemy import engine_from_config
from sqlalchemy import pool

from alembic import context

# Import your models and Base
from app.models.company import CompanyBase
from app.config import settings

# this is the Alembic Config object, which provides
# access to the values within the .ini file in use.
config = context.config

# Get database URL from settings, removing asyncpg driver for SQLAlchemy
company_db_url = settings.COMPANY_DB_URL.replace("+asyncpg", "")

# Override sqlalchemy.url with the database URL
config.set_main_option("sqlalchemy.url", company_db_url)

# Add a comment explaining the database setup
print(f"""
Database Configuration:
----------------------
This Alembic setup is for the company database (purchase_db) migrations.
Using database URL: {company_db_url}

Note: The app database (app_db) has its own separate Alembic setup
in the alembic/app directory.
""")

# Interpret the config file for Python logging.
if config.config_file_name is not None:
    fileConfig(config.config_file_name)

# add your model's MetaData object here
# for 'autogenerate' support
target_metadata = CompanyBase.metadata

def run_migrations_offline() -> None:
    """Run migrations in 'offline' mode."""
    url = config.get_main_option("sqlalchemy.url")
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )

    with context.begin_transaction():
        context.run_migrations()

def run_migrations_online() -> None:
    """Run migrations in 'online' mode."""
    connectable = engine_from_config(
        config.get_section(config.config_ini_section, {}),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )

    with connectable.connect() as connection:
        context.configure(
            connection=connection,
            target_metadata=target_metadata
        )

        with context.begin_transaction():
            context.run_migrations()

if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online() 