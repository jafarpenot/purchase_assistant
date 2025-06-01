from pydantic_settings import BaseSettings

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
    # Default URL for local development, will be overridden by environment variable in Render
    COMPANY_DB_URL: str | None = None

    # App DB (app_db) connection settings
    # Used by both init_db.py and the backend service
    # Note: Inside Docker network, this connects to app_postgres:5432
    APP_DB_USER: str = "app_user"
    APP_DB_PASSWORD: str = "app_password"
    APP_DB_HOST: str = "app_postgres"
    APP_DB_PORT: int = 5432  # Container port (not host port)
    APP_DB_NAME: str = "app_db"
    # Default URL for local development, will be overridden by environment variable in Render
    APP_DB_URL: str | None = None

    # OpenAI API Key - must be set in environment variables or .env file
    OPENAI_API_KEY: str  # No default value, must be provided

    class Config:
        env_file = ".env"

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        # Set default URLs only if not provided by environment
        if not self.COMPANY_DB_URL:
            self.COMPANY_DB_URL = f"postgresql+asyncpg://{self.COMPANY_DB_USER}:{self.COMPANY_DB_PASSWORD}@{self.COMPANY_DB_HOST}:{self.COMPANY_DB_PORT}/{self.COMPANY_DB_NAME}"
        if not self.APP_DB_URL:
            self.APP_DB_URL = f"postgresql+asyncpg://{self.APP_DB_USER}:{self.APP_DB_PASSWORD}@{self.APP_DB_HOST}:{self.APP_DB_PORT}/{self.APP_DB_NAME}"

settings = Settings() 