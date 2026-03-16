# Local Setup

## Requirements
- Python 3.11+
- Docker

## Steps
1. Start local services with `docker compose up -d`.
2. Install dependencies with `pip install -r requirements.txt`.
3. Set environment variables from `.env.example`.
4. Launch the API with `uvicorn dealflow_ai_engine.api.app:app --reload`.
5. Run `pytest` to validate the control plane and fixture-backed warehouse paths.
