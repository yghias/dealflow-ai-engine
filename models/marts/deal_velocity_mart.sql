with stage_windows as (
    select
        d.deal_id,
        d.owner_name,
        d.pipeline_stage,
        d.created_at,
        coalesce(o.outcome_timestamp, current_timestamp()) as comparison_timestamp
    from mart.deals d
    left join mart.deal_outcomes o
        on o.deal_id = d.deal_id
),
velocity as (
    select
        deal_id,
        owner_name,
        pipeline_stage,
        datediff('day', created_at, comparison_timestamp) as days_in_pipeline
    from stage_windows
)
select
    owner_name,
    pipeline_stage,
    count(*) as deal_count,
    avg(days_in_pipeline) as avg_days_in_pipeline,
    max(days_in_pipeline) as max_days_in_pipeline
from velocity
group by 1, 2;
