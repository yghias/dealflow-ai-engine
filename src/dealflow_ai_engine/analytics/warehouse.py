from __future__ import annotations

import json
from pathlib import Path
from typing import Any


class FixtureWarehouse:
    """Local development stand-in for Snowflake-backed marts."""

    def __init__(self, base_path: Path | None = None) -> None:
        self.base_path = base_path or Path.cwd() / "sample_data" / "curated"

    def read_ranked_queue(self) -> list[dict[str, Any]]:
        queue_path = self.base_path / "ranked_signal_queue.json"
        with queue_path.open("r", encoding="utf-8") as handle:
            return json.load(handle)
