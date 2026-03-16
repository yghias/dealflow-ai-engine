create or replace view intermediate.company_signal_rollup as
with deduplicated_signals as (
    select
        lower(regexp_replace(payload:company_name::string, '[^a-zA-Z0-9]', '')) as normalized_company_name,
        event_type,
        event_timestamp,
        payload:funding_amount_usd::number as funding_amount_usd,
        payload:employee_count::number as employee_count,
        row_number() over (
            partition by lower(regexp_replace(payload:company_name::string, '[^a-zA-Z0-9]', '')), event_type, date_trunc('day', event_timestamp)
            order by event_timestamp desc, source_record_id desc
        ) as latest_record_rank
    from raw.deal_signals_raw
),
rolled as (
    select
        normalized_company_name,
        count(*) as distinct_signal_days,
        count_if(event_type = 'funding_announcement') as funding_signal_days,
        count_if(event_type = 'hiring_spike') as hiring_signal_days,
        count_if(event_type = 'leadership_change') as leadership_signal_days,
        avg(coalesce(employee_count, 0)) as avg_reported_employee_count,
        max(coalesce(funding_amount_usd, 0)) as max_reported_funding_amount,
        max(event_timestamp) as latest_signal_timestamp
    from deduplicated_signals
    where latest_record_rank = 1
    group by 1
)
select * from rolled;

create or replace view intermediate.crm_activity_rollup as
with recent_activity as (
    select
        lower(regexp_replace(company_name, '[^a-zA-Z0-9]', '')) as normalized_company_name,
        deal_id,
        owner_name,
        activity_type,
        activity_status,
        activity_timestamp,
        case when activity_timestamp >= dateadd('day', -30, current_timestamp()) then 1 else 0 end as in_last_30d,
        case when activity_timestamp >= dateadd('day', -90, current_timestamp()) then 1 else 0 end as in_last_90d
    from mart.crm_activities
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
select * from aggregated;

create or replace view intermediate.investor_relationship_edges as
with investor_company_pairs as (
    select distinct
        lower(regexp_replace(payload:company_name::string, '[^a-zA-Z0-9]', '')) as normalized_company_name,
        payload:investor_name::string as investor_name
    from raw.deal_signals_raw
    where payload:investor_name is not null
),
pair_edges as (
    select
        a.investor_name as investor_name_left,
        b.investor_name as investor_name_right,
        count(*) as shared_company_count
    from investor_company_pairs a
    join investor_company_pairs b
        on a.normalized_company_name = b.normalized_company_name
       and a.investor_name < b.investor_name
    group by 1, 2
)
select
    investor_name_left,
    investor_name_right,
    shared_company_count,
    case
        when shared_company_count >= 6 then 0.95
        when shared_company_count >= 3 then 0.75
        when shared_company_count >= 1 then 0.50
        else 0.10
    end as relationship_edge_score
from pair_edges;
