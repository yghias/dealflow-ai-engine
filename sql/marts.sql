create or replace view mart.deal_pipeline_mart as
select
    d.deal_id,
    c.company_name,
    d.pipeline_stage,
    d.owner_name,
    sr.deal_attractiveness_score,
    sr.investor_fit_score,
    sr.relationship_strength_score,
    sr.overall_priority_score,
    count(distinct oe.outreach_event_id) as outreach_events,
    max(cs.signal_timestamp) as latest_signal_at
from mart.deals d
join mart.companies c on c.company_id = d.company_id
left join mart.scoring_results sr on sr.deal_id = d.deal_id
left join mart.outreach_events oe on oe.deal_id = d.deal_id
left join mart.company_signals cs on cs.company_id = d.company_id
group by 1,2,3,4,5,6,7,8;

create or replace view mart.investor_matching_mart as
select
    i.investor_id,
    i.investor_name,
    d.deal_id,
    c.company_name,
    ip.stage_preference,
    ip.relationship_strength,
    sr.investor_fit_score,
    row_number() over (
        partition by d.deal_id
        order by sr.investor_fit_score desc, ip.relationship_strength desc
    ) as investor_rank
from mart.investors i
join mart.investor_profiles ip on ip.investor_id = i.investor_id
join mart.scoring_results sr on sr.investor_id = i.investor_id
join mart.deals d on d.deal_id = sr.deal_id
join mart.companies c on c.company_id = d.company_id;

create or replace view mart.investor_targeting_mart as
select
    im.deal_id,
    im.company_name,
    im.investor_id,
    im.investor_name,
    im.investor_fit_score,
    im.investor_rank,
    ip.average_check_size,
    ip.stage_preference,
    ip.relationship_strength
from mart.investor_matching_mart im
join mart.investor_profiles ip
    on ip.investor_id = im.investor_id
where im.investor_rank <= 15;

create or replace view mart.company_intelligence_mart as
with signal_summary as (
    select
        company_id,
        count(*) as total_signals,
        count_if(signal_type = 'funding_announcement') as funding_signals,
        count_if(signal_type = 'hiring_spike') as hiring_signals,
        count_if(signal_type = 'leadership_change') as leadership_signals,
        max(signal_timestamp) as latest_signal_at
    from mart.company_signals
    group by 1
),
crm_summary as (
    select
        company_id,
        count(*) as crm_activities,
        max(activity_timestamp) as latest_crm_activity_at
    from mart.crm_activities
    group by 1
)
select
    c.company_id,
    c.company_name,
    c.sector,
    c.employee_count,
    c.latest_funding_round,
    c.latest_funding_amount,
    coalesce(s.total_signals, 0) as total_signals,
    coalesce(s.funding_signals, 0) as funding_signals,
    coalesce(s.hiring_signals, 0) as hiring_signals,
    coalesce(s.leadership_signals, 0) as leadership_signals,
    s.latest_signal_at,
    coalesce(crm.crm_activities, 0) as crm_activities,
    crm.latest_crm_activity_at
from mart.companies c
left join signal_summary s
    on s.company_id = c.company_id
left join crm_summary crm
    on crm.company_id = c.company_id;

create or replace view mart.signal_activity_mart as
with deduped as (
    select
        company_id,
        signal_type,
        signal_timestamp,
        is_late_arriving,
        row_number() over (
            partition by company_id, signal_type, date_trunc('day', signal_timestamp)
            order by signal_timestamp desc
        ) as rn
    from mart.company_signals
)
select
    company_id,
    signal_type,
    count(*) as signal_count,
    max(signal_timestamp) as latest_signal_timestamp,
    sum(case when is_late_arriving then 1 else 0 end) as late_arriving_updates
from deduped
where rn = 1
group by 1,2;

create or replace view mart.outreach_performance_mart as
select
    d.owner_name,
    oe.channel,
    count(*) as outreach_sent,
    sum(case when oe.event_status = 'responded' then 1 else 0 end) as responses,
    round(
        sum(case when oe.event_status = 'responded' then 1 else 0 end)::float / nullif(count(*), 0),
        4
    ) as response_rate
from mart.outreach_events oe
join mart.deals d on d.deal_id = oe.deal_id
group by 1,2;

create or replace view mart.crm_lifecycle_mart as
with activity_rollup as (
    select
        deal_id,
        owner_name,
        min(activity_timestamp) as first_activity_at,
        max(activity_timestamp) as latest_activity_at,
        count(*) as total_activities,
        count_if(activity_type = 'meeting_booked') as meetings_booked,
        count_if(activity_type = 'task_created') as tasks_created
    from mart.crm_activities
    group by 1,2
)
select
    a.deal_id,
    d.pipeline_stage,
    a.owner_name,
    a.first_activity_at,
    a.latest_activity_at,
    a.total_activities,
    a.meetings_booked,
    a.tasks_created,
    datediff('day', d.created_at, coalesce(a.latest_activity_at, current_timestamp())) as days_since_deal_created
from activity_rollup a
join mart.deals d
    on d.deal_id = a.deal_id;

create or replace view mart.deal_velocity_mart as
select
    pipeline_stage,
    owner_name,
    count(*) as deal_count,
    avg(datediff('day', created_at, coalesce(updated_at, current_timestamp()))) as avg_pipeline_days,
    max(datediff('day', created_at, coalesce(updated_at, current_timestamp()))) as max_pipeline_days
from mart.deals
group by 1,2;

create or replace view mart.investor_relationship_graph_mart as
with investor_pairs as (
    select
        a.investor_id as investor_id_left,
        b.investor_id as investor_id_right,
        count(distinct a.company_id) as shared_company_count
    from mart.scoring_results a
    join mart.scoring_results b
        on a.company_id = b.company_id
       and a.investor_id < b.investor_id
       and a.investor_id is not null
       and b.investor_id is not null
    group by 1,2
)
select
    investor_id_left,
    investor_id_right,
    shared_company_count,
    case
        when shared_company_count >= 4 then 'strong'
        when shared_company_count >= 2 then 'medium'
        else 'weak'
    end as edge_strength_band
from investor_pairs;

create or replace view mart.signal_quality_mart as
select
    source_system,
    event_type,
    count(*) as landed_signals,
    count(distinct source_record_id) as distinct_signals,
    sum(case when payload:company_name::string is null then 1 else 0 end) as missing_company_name_count,
    sum(case when payload:website::string is null then 1 else 0 end) as missing_website_count
from raw.deal_signals_raw
group by 1,2;

create or replace view mart.semantic_metrics_mart as
with pipeline_rollup as (
    select
        count(distinct deal_id) as pipeline_size,
        count(distinct case when pipeline_stage in ('Qualified', 'Active', 'Negotiation') then deal_id end) as active_pipeline_size,
        avg(overall_priority_score) as avg_priority_score
    from mart.deal_pipeline_mart
),
engagement_rollup as (
    select
        count(*) as outreach_events,
        sum(case when event_status = 'responded' then 1 else 0 end) as responded_events
    from mart.outreach_events
),
outcome_rollup as (
    select
        count(*) as outcomes_logged,
        sum(case when outcome_type = 'meeting' then 1 else 0 end) as meetings_booked,
        sum(case when outcome_type = 'pipeline_stage' and outcome_value = 'qualified' then 1 else 0 end) as deals_qualified
    from mart.deal_outcomes
)
select
    p.pipeline_size,
    p.active_pipeline_size,
    p.avg_priority_score,
    e.outreach_events,
    e.responded_events,
    round(e.responded_events::float / nullif(e.outreach_events, 0), 4) as outreach_response_rate,
    o.outcomes_logged,
    o.meetings_booked,
    o.deals_qualified,
    current_timestamp() as refreshed_at
from pipeline_rollup p
cross join engagement_rollup e
cross join outcome_rollup o;
