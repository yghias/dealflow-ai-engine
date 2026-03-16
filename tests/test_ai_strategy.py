from src.ai.deal_strategy import generate_deal_strategy


def test_generate_deal_strategy_returns_plan() -> None:
    strategy = generate_deal_strategy()
    assert strategy["priority"] == "high"
    assert strategy["outreach_plan"]
