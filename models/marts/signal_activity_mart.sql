with deduped_signals as (
    select
        normalized_company_name,
        event_type,
        event_timestamp,
        row_number() over (
            partition by normalized_company_name, event_type, date_trunc('day', event_timestamp)
            order by event_timestamp desc, source_record_id desc
        ) as signal_rank
    from {{ ref('stg_signals') }}
),
daily_signal_rollup as (
    select
        normalized_company_name,
        event_type,
        count(*) as signal_count,
        max(event_timestamp) as latest_signal_timestamp
    from deduped_signals
    where signal_rank = 1
    group by 1, 2
)
select
    normalized_company_name,
    event_type,
    signal_count,
    latest_signal_timestamp
from daily_signal_rollup;
