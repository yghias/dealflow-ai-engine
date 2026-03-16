with deduplicated_signals as (
    select
        normalized_company_name,
        event_type,
        event_timestamp,
        funding_amount_usd,
        employee_count,
        row_number() over (
            partition by normalized_company_name, event_type, date_trunc('day', event_timestamp)
            order by event_timestamp desc, source_record_id desc
        ) as latest_record_rank
    from {{ ref('stg_signals') }}
),
rolled as (
    select
        normalized_company_name,
        count(*) as distinct_signal_days,
        count_if(event_type = 'funding_announcement') as funding_signal_days,
        count_if(event_type = 'hiring_spike') as hiring_signal_days,
        count_if(event_type = 'leadership_change') as leadership_signal_days,
        avg(coalesce(employee_count, 0)) as avg_reported_employee_count,
        max(coalesce(funding_amount_usd, 0)) as max_reported_funding_amount,
        max(event_timestamp) as latest_signal_timestamp
    from deduplicated_signals
    where latest_record_rank = 1
    group by 1
)
select
    normalized_company_name,
    distinct_signal_days,
    funding_signal_days,
    hiring_signal_days,
    leadership_signal_days,
    avg_reported_employee_count,
    max_reported_funding_amount,
    latest_signal_timestamp
from rolled;
