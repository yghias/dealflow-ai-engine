select
    q.signal_id
from mart.mart_ranked_signal_queue q
left join mart.mart_strategy_effectiveness e
    on e.signal_id = q.signal_id
where e.signal_id is null;
