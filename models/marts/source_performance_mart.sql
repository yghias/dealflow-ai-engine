with signal_quality as (
    select
        source_system,
        event_type,
        count(*) as landed_signals,
        count(distinct source_record_id) as distinct_signals,
        count_if(company_name is null) as missing_company_name_count,
        count_if(website is null) as missing_website_count
    from {{ ref('stg_signals') }}
    group by 1, 2
),
deal_attribution as (
    select
        s.source_system,
        s.event_type,
        count(distinct d.deal_id) as attributed_deals,
        avg(sr.overall_priority_score) as avg_priority_score
    from {{ ref('stg_signals') }} s
    left join mart.companies c
        on c.normalized_name = s.normalized_company_name
    left join mart.deals d
        on d.company_id = c.company_id
    left join mart.scoring_results sr
        on sr.deal_id = d.deal_id
    group by 1, 2
)
select
    q.source_system,
    q.event_type,
    q.landed_signals,
    q.distinct_signals,
    q.missing_company_name_count,
    q.missing_website_count,
    coalesce(a.attributed_deals, 0) as attributed_deals,
    coalesce(a.avg_priority_score, 0) as avg_priority_score
from signal_quality q
left join deal_attribution a
    on a.source_system = q.source_system
   and a.event_type = q.event_type;
