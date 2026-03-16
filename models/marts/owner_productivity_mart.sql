with owner_baseline as (
    select
        owner_name,
        avg_weekly_activity_count,
        avg_weekly_meeting_count,
        latest_activity_week
    from {{ ref('owner_activity_baseline') }}
),
capacity as (
    select
        owner_name,
        open_deals,
        avg_priority_score,
        crm_activities_30d,
        meetings_booked_30d
    from {{ ref('owner_capacity_mart') }}
)
select
    c.owner_name,
    c.open_deals,
    c.avg_priority_score,
    c.crm_activities_30d,
    c.meetings_booked_30d,
    b.avg_weekly_activity_count,
    b.avg_weekly_meeting_count,
    b.latest_activity_week
from capacity c
left join owner_baseline b
    on b.owner_name = c.owner_name;
