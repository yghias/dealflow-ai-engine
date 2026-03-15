from dealflow_ai_engine.api.schemas.common import SignalPayload


def extract_organization_name(signal: SignalPayload) -> str:
    return str(signal.metadata.get("organization_name") or signal.title.split(" announces")[0]).strip()
