from src.enrichment.entity_matching import company_names_match


def test_company_names_match_with_spacing_variants() -> None:
    assert company_names_match("North Ridge Systems", "NorthRidge Systems")
