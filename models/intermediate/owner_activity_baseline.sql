with activity_by_owner as (
    select
        owner_name,
        date_trunc('week', activity_timestamp) as activity_week,
        count(*) as weekly_activity_count,
        count_if(activity_type = 'meeting_booked') as weekly_meeting_count
    from {{ ref('stg_crm_activities') }}
    group by 1,2
),
baseline as (
    select
        owner_name,
        avg(weekly_activity_count) as avg_weekly_activity_count,
        avg(weekly_meeting_count) as avg_weekly_meeting_count,
        max(activity_week) as latest_activity_week
    from activity_by_owner
    group by 1
)
select * from baseline;
