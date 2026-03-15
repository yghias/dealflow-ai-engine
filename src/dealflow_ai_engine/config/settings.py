from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_env: str = "local"
    log_level: str = "INFO"
    postgres_dsn: str = "postgresql://postgres:postgres@localhost:5432/dealflow"
    openai_api_key: str = ""
    crm_provider: str = "mock"
    crm_writeback_enabled: bool = False

    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", case_sensitive=False)


@lru_cache
def get_settings() -> Settings:
    return Settings()
