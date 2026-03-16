create or replace view mart.executive_kpi_metrics as
with pipeline_metrics as (
    select
        count(distinct deal_id) as pipeline_size,
        count(distinct case when pipeline_stage in ('Qualified', 'Active', 'Negotiation') then deal_id end) as active_pipeline_size,
        avg(overall_priority_score) as avg_priority_score
    from mart.deal_pipeline_mart
),
engagement_metrics as (
    select
        count(*) as outreach_events,
        sum(case when event_status = 'responded' then 1 else 0 end) as responded_events
    from mart.outreach_events
),
outcome_metrics as (
    select
        count(*) as outcomes_logged,
        sum(case when outcome_type = 'meeting' then 1 else 0 end) as meetings_booked,
        sum(case when outcome_type = 'pipeline_stage' and outcome_value = 'qualified' then 1 else 0 end) as deals_qualified
    from mart.deal_outcomes
)
select
    p.pipeline_size,
    p.active_pipeline_size,
    p.avg_priority_score,
    e.outreach_events,
    e.responded_events,
    round(e.responded_events::float / nullif(e.outreach_events, 0), 4) as outreach_response_rate,
    o.outcomes_logged,
    o.meetings_booked,
    o.deals_qualified,
    current_timestamp() as refreshed_at
from pipeline_metrics p
cross join engagement_metrics e
cross join outcome_metrics o;

create or replace view mart.owner_kpi_metrics as
select
    owner_name,
    count(distinct deal_id) as owned_deals,
    avg(overall_priority_score) as avg_priority_score,
    sum(outreach_events) as outreach_events,
    max(latest_signal_at) as latest_signal_at
from mart.deal_pipeline_mart
group by 1;

create or replace view mart.source_kpi_metrics as
select
    source_system,
    event_type,
    landed_signals,
    distinct_signals,
    attributed_deals,
    avg_priority_score
from mart.source_performance_mart;
