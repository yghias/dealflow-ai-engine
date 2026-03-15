# Local Setup

## Requirements
- Python 3.11+
- Docker

## Steps
1. Start Postgres with `docker compose up -d postgres`.
2. Install the package with `pip install -e .[dev]`.
3. Set environment variables from `.env.example`.
4. Launch the API with `uvicorn dealflow_ai_engine.api.app:app --reload`.
5. Run `pytest` to verify the starter workflow.
