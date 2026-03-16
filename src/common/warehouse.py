from __future__ import annotations

from typing import Any


def build_snowflake_connection_config(settings: Any) -> dict[str, str]:
    return {
        "account": settings.snowflake_account,
        "user": settings.snowflake_user,
        "password": settings.snowflake_password,
        "warehouse": settings.snowflake_warehouse,
        "database": settings.snowflake_database,
        "schema": settings.snowflake_schema,
    }
