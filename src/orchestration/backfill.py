def build_backfill_plan(source_name: str, start_date: str, end_date: str) -> dict[str, str]:
    return {
        "source_name": source_name,
        "start_date": start_date,
        "end_date": end_date,
        "mode": "idempotent_replay",
    }
