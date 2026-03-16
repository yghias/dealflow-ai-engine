with pipeline_rollup as (
    select
        count(distinct deal_id) as pipeline_size,
        count(distinct case when pipeline_stage in ('Qualified', 'Active', 'Negotiation') then deal_id end) as active_pipeline_size,
        avg(overall_priority_score) as avg_priority_score
    from mart.deal_pipeline_mart
),
engagement_rollup as (
    select
        count(*) as outreach_events,
        count_if(event_status = 'responded') as responded_events
    from mart.outreach_events
),
outcome_rollup as (
    select
        count(*) as outcomes_logged,
        count_if(outcome_type = 'meeting') as meetings_booked,
        count_if(outcome_type = 'pipeline_stage' and outcome_value = 'qualified') as deals_qualified
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
from pipeline_rollup p
cross join engagement_rollup e
cross join outcome_rollup o;
