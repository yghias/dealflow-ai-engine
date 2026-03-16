with signal_by_source as (
    select
        source_system,
        date_trunc('week', event_timestamp) as signal_week,
        count(*) as weekly_signal_count,
        count(distinct normalized_company_name) as weekly_company_coverage
    from {{ ref('stg_signals') }}
    group by 1,2
),
baseline as (
    select
        source_system,
        avg(weekly_signal_count) as avg_weekly_signal_count,
        avg(weekly_company_coverage) as avg_weekly_company_coverage,
        max(signal_week) as latest_signal_week
    from signal_by_source
    group by 1
)
select * from baseline;
