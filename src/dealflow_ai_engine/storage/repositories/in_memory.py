from collections.abc import Iterable

from dealflow_ai_engine.storage.models.domain import SignalEventRecord


class InMemorySignalRepository:
    def __init__(self) -> None:
        self._items: list[SignalEventRecord] = []

    def add(self, record: SignalEventRecord) -> None:
        self._items.append(record)

    def list(self) -> Iterable[SignalEventRecord]:
        return tuple(self._items)
