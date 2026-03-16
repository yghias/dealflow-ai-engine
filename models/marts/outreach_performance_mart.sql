with activity_rollup as (
    select
        owner_name,
        activity_type,
        count(*) as activity_count,
        sum(case when activity_status = 'completed' then 1 else 0 end) as completed_count
    from {{ ref('stg_crm_activities') }}
    group by 1, 2
)
select
    owner_name,
    activity_type,
    activity_count,
    completed_count,
    round(completed_count::float / nullif(activity_count, 0), 4) as completion_rate
from activity_rollup;
