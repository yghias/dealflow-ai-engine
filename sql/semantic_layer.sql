create or replace view mart.semantic_deal_metrics as
select
    deal_id,
    company_name,
    pipeline_stage,
    owner_name,
    overall_priority_score,
    outreach_events,
    latest_signal_at
from mart.deal_pipeline_mart;

create or replace view mart.semantic_investor_metrics as
select
    investor_id,
    investor_name,
    deal_id,
    investor_fit_score,
    investor_rank
from mart.investor_matching_mart;

create or replace view mart.semantic_owner_metrics as
select
    owner_name,
    open_deals,
    avg_priority_score,
    crm_activities_30d,
    meetings_booked_30d
from mart.owner_capacity_mart;

create or replace view mart.semantic_source_metrics as
select
    source_system,
    event_type,
    landed_signals,
    distinct_signals,
    attributed_deals,
    avg_priority_score
from mart.source_performance_mart;
