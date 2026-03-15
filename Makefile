PYTHON ?= python3

.PHONY: install test lint run

install:
	$(PYTHON) -m pip install -e .[dev]

test:
	pytest

lint:
	ruff check src tests

run:
	uvicorn dealflow_ai_engine.api.app:app --reload
