from pydantic_settings import BaseSettings
import os
from urllib.parse import urlparse

class Settings(BaseSettings):
    # Note: These common DB settings are not used in the current setup
    # as we have separate COMPANY_DB_* and APP_DB_* settings.
    # They are kept for reference or future use.
    DB_USER: str | None = None
    DB_PASSWORD: str | None = None
    DB_HOST: str | None = None
    DB_PORT: int | None = None

    # Company DB (purchase_db) connection settings
    # Used by both init_db.py and the backend service
    # Note: Inside Docker network, this connects to company_postgres:5432
    COMPANY_DB_USER: str = "company_user"
    COMPANY_DB_PASSWORD: str = "company_password"
    COMPANY_DB_HOST: str = "company_postgres"
    COMPANY_DB_PORT: int = 5432  # Container port (not host port)
    COMPANY_DB_NAME: str = "purchase_db"
    # In Render, this will be set by the fromDatabase configuration
    COMPANY_DB_URL: str | None = None

    # App DB (app_db) connection settings
    # Used by both init_db.py and the backend service
    # Note: Inside Docker network, this connects to app_postgres:5432
    APP_DB_USER: str = "app_user"
    APP_DB_PASSWORD: str = "app_password"
    APP_DB_HOST: str = "app_postgres"
    APP_DB_PORT: int = 5432  # Container port (not host port)
    APP_DB_NAME: str = "app_db"
    # In Render, this will be set by the fromDatabase configuration
    APP_DB_URL: str | None = None

    # OpenAI API Key - must be set in environment variables or .env file
    OPENAI_API_KEY: str  # No default value, must be provided

    class Config:
        env_file = ".env"

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        
        # Debug logging for initial database URLs
        print(f"""
Initial Database Configuration:
-----------------------------
Environment: {'Render' if 'RENDER' in os.environ else 'Local'}
COMPANY_DB_URL: {self.COMPANY_DB_URL}
APP_DB_URL: {self.APP_DB_URL}
""")
        
        # If we're in Render (indicated by RENDER environment variable)
        if 'RENDER' in os.environ:
            # In Render, we expect COMPANY_DB_URL and APP_DB_URL to be set by fromDatabase
            if not self.COMPANY_DB_URL or not self.APP_DB_URL:
                raise ValueError(
                    "In Render environment, COMPANY_DB_URL and APP_DB_URL must be set by fromDatabase configuration. "
                    "Please check your render.yaml file."
                )
            
            # Just ensure we're using the asyncpg driver
            if not self.COMPANY_DB_URL.startswith('postgresql+asyncpg://'):
                self.COMPANY_DB_URL = self.COMPANY_DB_URL.replace('postgresql://', 'postgresql+asyncpg://')
            if not self.APP_DB_URL.startswith('postgresql+asyncpg://'):
                self.APP_DB_URL = self.APP_DB_URL.replace('postgresql://', 'postgresql+asyncpg://')
        else:
            # For local development, construct URLs from individual settings
            if not self.COMPANY_DB_URL:
                self.COMPANY_DB_URL = f"postgresql+asyncpg://{self.COMPANY_DB_USER}:{self.COMPANY_DB_PASSWORD}@{self.COMPANY_DB_HOST}:{self.COMPANY_DB_PORT}/{self.COMPANY_DB_NAME}"
            if not self.APP_DB_URL:
                self.APP_DB_URL = f"postgresql+asyncpg://{self.APP_DB_USER}:{self.APP_DB_PASSWORD}@{self.APP_DB_HOST}:{self.APP_DB_PORT}/{self.APP_DB_NAME}"
        
        # Debug logging after URL modification
        print(f"""
Final Database Configuration:
---------------------------
Environment: {'Render' if 'RENDER' in os.environ else 'Local'}
COMPANY_DB_URL: {self.COMPANY_DB_URL}
APP_DB_URL: {self.APP_DB_URL}
""")

settings = Settings() 