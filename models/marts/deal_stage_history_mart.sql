with base as (
    select
        deal_id,
        company_id,
        pipeline_stage,
        created_at,
        updated_at,
        datediff('day', created_at, coalesce(updated_at, current_timestamp())) as days_in_stage
    from mart.deals
)
select
    deal_id,
    company_id,
    pipeline_stage,
    created_at,
    updated_at,
    days_in_stage,
    row_number() over (
        partition by deal_id
        order by coalesce(updated_at, created_at) desc
    ) as stage_recency_rank
from base;
