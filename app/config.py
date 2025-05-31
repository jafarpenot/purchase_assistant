from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    # (Optional) Common DB settings (for example, used by init_db to create databases)
    DB_USER: str = "postgres"
    DB_PASSWORD: str = "postgres"
    DB_HOST: str = "localhost"
    DB_PORT: int = 5432

    # (Optional) (If you use a common DB user (e.g. postgres) to create databases, you can leave DB_USER, DB_PASSWORD, DB_HOST, DB_PORT as above.)
    # (Otherwise, you can remove or adjust them.)

    # Company DB (purchase_db) connection settings (used by init_company_db and your backend)
    COMPANY_DB_USER: str = "purchase_user"
    COMPANY_DB_PASSWORD: str = "purchase_password"
    COMPANY_DB_HOST: str = "company_postgres"
    COMPANY_DB_PORT: int = 5432
    COMPANY_DB_NAME: str = "purchase_db"
    COMPANY_DB_URL: str = "postgresql+asyncpg://purchase_user:purchase_password@company_postgres:5432/purchase_db"

    # App DB (app_db) connection settings (used by init_app_db and your backend)
    APP_DB_USER: str = "app_user"
    APP_DB_PASSWORD: str = "app_password"
    APP_DB_HOST: str = "app_postgres"
    APP_DB_PORT: int = 5432
    APP_DB_NAME: str = "app_db"
    APP_DB_URL: str = "postgresql+asyncpg://app_user:app_password@app_postgres:5432/app_db"

    class Config:
         env_file = ".env"

settings = Settings() 