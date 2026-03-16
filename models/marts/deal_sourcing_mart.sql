with latest_signal as (
    select
        normalized_company_name,
        max(event_timestamp) as latest_signal_timestamp
    from {{ ref('stg_signals') }}
    group by 1
),
priority as (
    select
        d.deal_id,
        d.owner_name,
        d.pipeline_stage,
        s.overall_priority_score
    from mart.deals d
    join mart.scoring_results s
        on s.deal_id = d.deal_id
)
select
    d.deal_id,
    c.company_name,
    d.owner_name,
    d.pipeline_stage,
    p.overall_priority_score,
    l.latest_signal_timestamp
from mart.deals d
join mart.companies c
    on c.company_id = d.company_id
join priority p
    on p.deal_id = d.deal_id
left join latest_signal l
    on l.normalized_company_name = c.normalized_name;
