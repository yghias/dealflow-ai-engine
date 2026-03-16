REQUIRED_SIGNAL_FIELDS = {
    "source_record_id",
    "event_type",
    "company_name",
    "event_timestamp",
}


def validate_signal_contract(record: dict) -> list[str]:
    missing = sorted(REQUIRED_SIGNAL_FIELDS.difference(record.keys()))
    return [f"missing_field:{field}" for field in missing]
