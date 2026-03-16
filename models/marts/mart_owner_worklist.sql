select
    owner_name,
    queue_tier,
    count(*) as queued_accounts,
    avg(overall_score) as average_score,
    max(published_at) as latest_publication_at
from {{ ref('mart_ranked_signal_queue') }}
group by 1, 2;
