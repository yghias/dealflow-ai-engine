select *
from {{ ref('mart_ranked_signal_queue') }}
where owner_name is null;
