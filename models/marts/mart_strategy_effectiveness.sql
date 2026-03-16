with outcomes as (
    select
        related_signal_id as signal_id,
        count_if(activity_type = 'task_completed') as completed_tasks,
        count_if(activity_type = 'meeting_booked') as meetings_booked,
        count_if(activity_type = 'stage_advanced') as stage_advances
    from {{ ref('stg_crm_activity') }}
    group by 1
)
select
    q.signal_id,
    q.organization_name,
    q.owner_name,
    q.signal_type,
    q.overall_score,
    coalesce(o.completed_tasks, 0) as completed_tasks,
    coalesce(o.meetings_booked, 0) as meetings_booked,
    coalesce(o.stage_advances, 0) as stage_advances
from {{ ref('mart_ranked_signal_queue') }} q
left join outcomes o
    on o.signal_id = q.signal_id;
