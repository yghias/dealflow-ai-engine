create or replace view mart.report_exec_daily_pipeline as
select
    current_date() as report_date,
    pipeline_size,
    active_pipeline_size,
    avg_priority_score,
    outreach_events,
    responded_events,
    outreach_response_rate,
    outcomes_logged,
    meetings_booked,
    deals_qualified
from mart.semantic_metrics_mart;

create or replace view mart.report_owner_performance as
select
    owner_name,
    open_deals,
    avg_priority_score,
    crm_activities_30d,
    meetings_booked_30d,
    latest_activity_timestamp
from mart.owner_capacity_mart
order by avg_priority_score desc, open_deals desc;

create or replace view mart.report_source_health as
select
    source_system,
    event_type,
    landed_signals,
    distinct_signals,
    attributed_deals,
    avg_priority_score,
    missing_company_name_count,
    missing_website_count
from mart.source_performance_mart
order by avg_priority_score desc, attributed_deals desc;

create or replace view mart.report_investor_targeting as
select
    deal_id,
    company_name,
    investor_name,
    investor_fit_score,
    investor_rank
from mart.investor_matching_mart
where investor_rank <= 20
order by deal_id, investor_rank;
