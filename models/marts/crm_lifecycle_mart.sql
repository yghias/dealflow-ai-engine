with activity_windows as (
    select
        deal_id,
        owner_name,
        min(activity_timestamp) as first_activity_at,
        max(activity_timestamp) as latest_activity_at,
        count(*) as total_activities,
        count_if(activity_type = 'meeting_booked') as meetings_booked,
        count_if(activity_type = 'email_sent') as outbound_emails
    from {{ ref('stg_crm_activities') }}
    group by 1, 2
)
select
    deal_id,
    owner_name,
    first_activity_at,
    latest_activity_at,
    total_activities,
    meetings_booked,
    outbound_emails,
    datediff('day', first_activity_at, latest_activity_at) as active_lifecycle_days
from activity_windows;
