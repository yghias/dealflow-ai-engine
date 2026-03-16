with funding_context as (
    select
        normalized_company_name,
        count_if(event_type = 'funding_announcement') as funding_signal_count,
        max(coalesce(funding_amount_usd, 0)) as max_funding_amount,
        max(event_timestamp) as latest_funding_timestamp
    from {{ ref('stg_signals') }}
    group by 1
),
investor_context as (
    select
        s.deal_id,
        s.investor_id,
        s.investor_name,
        s.investor_fit_score,
        s.overall_priority_score
    from {{ ref('scoring_results_snapshot') }} s
)
select
    d.deal_id,
    c.company_name,
    c.latest_funding_round,
    coalesce(f.funding_signal_count, 0) as funding_signal_count,
    coalesce(f.max_funding_amount, 0) as max_funding_amount,
    f.latest_funding_timestamp,
    i.investor_id,
    i.investor_name,
    i.investor_fit_score,
    i.overall_priority_score
from mart.deals d
join mart.companies c
    on c.company_id = d.company_id
left join funding_context f
    on f.normalized_company_name = c.normalized_name
left join investor_context i
    on i.deal_id = d.deal_id;
