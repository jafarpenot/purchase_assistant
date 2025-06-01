from pydantic_settings import BaseSettings

class TestSettings(BaseSettings):
    OPENAI_API_KEY: str

    class Config:
        env_file = ".env"

try:
    settings = TestSettings()
    print("Successfully loaded OPENAI_API_KEY from .env")
    print(f"Key length: {len(settings.OPENAI_API_KEY)}")
except Exception as e:
    print(f"Error loading .env: {str(e)}") 