with pipeline_rollup as (
    select
        owner_name,
        count(distinct deal_id) as open_deals,
        avg(overall_priority_score) as avg_priority_score
    from mart.deal_pipeline_mart
    group by 1
),
activity_rollup as (
    select
        owner_name,
        count(*) as crm_activities_30d,
        count_if(activity_type = 'meeting_booked') as meetings_booked_30d,
        max(activity_timestamp) as latest_activity_timestamp
    from mart.crm_activities
    where activity_timestamp >= dateadd('day', -30, current_timestamp())
    group by 1
)
select
    p.owner_name,
    p.open_deals,
    p.avg_priority_score,
    coalesce(a.crm_activities_30d, 0) as crm_activities_30d,
    coalesce(a.meetings_booked_30d, 0) as meetings_booked_30d,
    a.latest_activity_timestamp
from pipeline_rollup p
left join activity_rollup a
    on a.owner_name = p.owner_name;
