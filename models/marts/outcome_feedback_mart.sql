with outcome_rollup as (
    select
        deal_id,
        count(*) as outcomes_logged,
        count_if(outcome_type = 'meeting') as meetings_booked,
        count_if(outcome_type = 'pipeline_stage' and outcome_value = 'qualified') as qualified_transitions,
        max(outcome_timestamp) as latest_outcome_timestamp
    from mart.deal_outcomes
    group by 1
),
score_rollup as (
    select
        deal_id,
        avg(overall_priority_score) as avg_priority_score,
        avg(deal_attractiveness_score) as avg_deal_attractiveness_score,
        avg(investor_fit_score) as avg_investor_fit_score
    from mart.scoring_results
    group by 1
)
select
    o.deal_id,
    o.outcomes_logged,
    o.meetings_booked,
    o.qualified_transitions,
    o.latest_outcome_timestamp,
    s.avg_priority_score,
    s.avg_deal_attractiveness_score,
    s.avg_investor_fit_score
from outcome_rollup o
left join score_rollup s
    on s.deal_id = o.deal_id;
