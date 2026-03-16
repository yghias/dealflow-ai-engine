from src.scoring.company_scoring import score_companies


def test_score_companies_outputs_priority_score() -> None:
    scores = score_companies()
    assert scores[0]["overall_priority_score"] <= 1
