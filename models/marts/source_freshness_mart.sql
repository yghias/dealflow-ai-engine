with source_baseline as (
    select
        source_system,
        avg_weekly_signal_count,
        avg_weekly_company_coverage,
        latest_signal_week
    from {{ ref('source_signal_baseline') }}
),
current_state as (
    select
        source_system,
        max(event_timestamp) as latest_signal_at,
        count(*) as landed_signals
    from {{ ref('stg_signals') }}
    group by 1
)
select
    c.source_system,
    c.latest_signal_at,
    c.landed_signals,
    b.avg_weekly_signal_count,
    b.avg_weekly_company_coverage,
    b.latest_signal_week,
    datediff('hour', c.latest_signal_at, current_timestamp()) as hours_since_latest_signal
from current_state c
left join source_baseline b
    on b.source_system = c.source_system;
