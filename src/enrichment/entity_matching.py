def normalize_company_name(company_name: str) -> str:
    return "".join(ch.lower() for ch in company_name if ch.isalnum())


def company_names_match(left: str, right: str) -> bool:
    return normalize_company_name(left) == normalize_company_name(right)
