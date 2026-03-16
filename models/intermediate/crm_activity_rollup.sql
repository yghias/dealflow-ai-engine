with recent_activity as (
    select
        normalized_company_name,
        deal_id,
        owner_name,
        activity_type,
        activity_status,
        activity_timestamp,
        case when activity_timestamp >= dateadd('day', -30, current_timestamp()) then 1 else 0 end as in_last_30d,
        case when activity_timestamp >= dateadd('day', -90, current_timestamp()) then 1 else 0 end as in_last_90d
    from {{ ref('stg_crm_activities') }}
),
aggregated as (
    select
        normalized_company_name,
        owner_name,
        count(*) as crm_activity_count_all_time,
        sum(in_last_30d) as crm_activity_count_30d,
        sum(in_last_90d) as crm_activity_count_90d,
        count_if(activity_type = 'meeting_booked') as meetings_booked_all_time,
        count_if(activity_type = 'meeting_booked' and in_last_90d = 1) as meetings_booked_90d,
        count_if(activity_type = 'email_sent') as outbound_email_count,
        count_if(activity_status = 'completed') as completed_activity_count,
        max(activity_timestamp) as latest_activity_timestamp
    from recent_activity
    group by 1, 2
)
select
    normalized_company_name,
    owner_name,
    crm_activity_count_all_time,
    crm_activity_count_30d,
    crm_activity_count_90d,
    meetings_booked_all_time,
    meetings_booked_90d,
    outbound_email_count,
    completed_activity_count,
    latest_activity_timestamp
from aggregated;
