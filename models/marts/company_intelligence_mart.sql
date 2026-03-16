with signal_summary as (
    select
        normalized_company_name,
        count(*) as total_signals,
        count_if(event_type = 'funding_announcement') as funding_signals,
        count_if(event_type = 'hiring_spike') as hiring_signals,
        count_if(event_type = 'leadership_change') as leadership_signals,
        max(event_timestamp) as latest_signal_at
    from {{ ref('stg_signals') }}
    group by 1
),
crm_summary as (
    select
        normalized_company_name,
        count(*) as crm_activities,
        max(activity_timestamp) as latest_crm_activity_at
    from {{ ref('stg_crm_activities') }}
    group by 1
)
select
    c.company_id,
    c.company_name,
    c.sector,
    c.employee_count,
    c.latest_funding_round,
    c.latest_funding_amount,
    coalesce(s.total_signals, 0) as total_signals,
    coalesce(s.funding_signals, 0) as funding_signals,
    coalesce(s.hiring_signals, 0) as hiring_signals,
    coalesce(s.leadership_signals, 0) as leadership_signals,
    s.latest_signal_at,
    coalesce(crm.crm_activities, 0) as crm_activities,
    crm.latest_crm_activity_at
from mart.companies c
left join signal_summary s
    on s.normalized_company_name = c.normalized_name
left join crm_summary crm
    on crm.normalized_company_name = c.normalized_name;
