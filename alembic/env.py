from logging.config import fileConfig
import os
from sqlalchemy import engine_from_config
from sqlalchemy import pool

from alembic import context

# Import your models and Base
from app.models.app import AppBase
from app.config import settings

# this is the Alembic Config object, which provides
# access to the values within the .ini file in use.
config = context.config

# Get database URL from environment variable or fall back to settings
# Note: This is specifically for the app database migrations
# The company database migrations would need a separate alembic setup
app_db_url = os.getenv("APP_DATABASE_URL")  # More specific name
if not app_db_url:
    # Fall back to settings, removing asyncpg driver for SQLAlchemy
    app_db_url = settings.APP_DB_URL.replace("+asyncpg", "")

# Override sqlalchemy.url with the database URL
config.set_main_option("sqlalchemy.url", app_db_url)

# Add a comment explaining the database setup
print("""
Database Configuration:
----------------------
This Alembic setup is for the app database (app_db) migrations.
The company database (purchase_db) would need a separate Alembic setup.

Current database URL is set from:
1. APP_DATABASE_URL environment variable (if set)
2. Falling back to settings.APP_DB_URL (from .env or defaults)

To set the database URL via environment variable:
export APP_DATABASE_URL="postgresql://app_user:app_password@localhost:5432/app_db"
""")

# Interpret the config file for Python logging.
# This line sets up loggers basically.
if config.config_file_name is not None:
    fileConfig(config.config_file_name)

# add your model's MetaData object here
# for 'autogenerate' support
target_metadata = AppBase.metadata

# other values from the config, defined by the needs of env.py,
# can be acquired:
# my_important_option = config.get_main_option("my_important_option")
# ... etc.


def run_migrations_offline() -> None:
    """Run migrations in 'offline' mode.

    This configures the context with just a URL
    and not an Engine, though an Engine is acceptable
    here as well.  By skipping the Engine creation
    we don't even need a DBAPI to be available.

    Calls to context.execute() here emit the given string to the
    script output.

    """
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
    """Run migrations in 'online' mode.

    In this scenario we need to create an Engine
    and associate a connection with the context.

    """
    connectable = engine_from_config(
        config.get_section(config.config_ini_section, {}),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )

    with connectable.connect() as connection:
        context.configure(
            connection=connection, target_metadata=target_metadata
        )

        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
