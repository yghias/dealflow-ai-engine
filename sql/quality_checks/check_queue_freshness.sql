select
    max(published_at) as latest_publication_at,
    datediff('hour', max(published_at), current_timestamp()) as hours_since_publication
from mart.mart_ranked_signal_queue;
