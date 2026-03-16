create or replace view ops.duplicate_company_name_check as
select
    normalized_name,
    count(*) as duplicate_count
from mart.companies
group by 1
having count(*) > 1;

create or replace view ops.missing_contact_fields_check as
select
    contact_id,
    company_id,
    investor_id,
    full_name,
    title,
    email
from mart.contacts
where full_name is null
   or title is null;

create or replace view ops.invalid_score_range_check as
select
    scoring_result_id,
    deal_id,
    investor_id,
    overall_priority_score
from mart.scoring_results
where overall_priority_score < 0
   or overall_priority_score > 1;

create or replace view ops.future_activity_timestamp_check as
select
    crm_activity_id,
    deal_id,
    activity_type,
    activity_timestamp
from mart.crm_activities
where activity_timestamp > current_timestamp();

create or replace view ops.outreach_status_anomaly_check as
select
    outreach_event_id,
    deal_id,
    channel,
    event_status
from mart.outreach_events
where channel not in ('email', 'linkedin', 'call', 'meeting')
   or event_status not in ('queued', 'sent', 'delivered', 'responded', 'completed');
