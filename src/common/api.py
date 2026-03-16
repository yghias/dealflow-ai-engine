from fastapi import FastAPI

app = FastAPI(title="dealflow-ai-engine-control-plane", version="1.0.0")


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}
