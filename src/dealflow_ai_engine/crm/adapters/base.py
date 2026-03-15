from abc import ABC, abstractmethod
from dataclasses import dataclass


@dataclass(slots=True)
class CRMTaskPayload:
    account_name: str
    priority: str
    summary: str
    owner_hint: str


class CRMAdapter(ABC):
    @abstractmethod
    def create_task(self, payload: CRMTaskPayload) -> str:
        raise NotImplementedError
