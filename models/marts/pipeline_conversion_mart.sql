with pipeline_state as (
    select
        d.deal_id,
        d.owner_name,
        d.pipeline_stage,
        sr.overall_priority_score
    from mart.deals d
    left join mart.scoring_results sr
        on sr.deal_id = d.deal_id
),
outcome_state as (
    select
        deal_id,
        count(*) as outcomes_logged,
        count_if(outcome_type = 'meeting') as meetings_booked,
        count_if(outcome_type = 'pipeline_stage' and outcome_value = 'qualified') as qualified_outcomes
    from mart.deal_outcomes
    group by 1
)
select
    p.owner_name,
    p.pipeline_stage,
    count(*) as deal_count,
    avg(p.overall_priority_score) as avg_priority_score,
    sum(coalesce(o.outcomes_logged, 0)) as outcomes_logged,
    sum(coalesce(o.meetings_booked, 0)) as meetings_booked,
    sum(coalesce(o.qualified_outcomes, 0)) as qualified_outcomes
from pipeline_state p
left join outcome_state o
    on o.deal_id = p.deal_id
group by 1, 2;
