create or replace view mart.fact_company_signal as
select
    company_signal_id,
    company_id,
    signal_type,
    signal_value,
    signal_timestamp,
    is_late_arriving,
    created_at
from mart.company_signals;

create or replace view mart.fact_deal_signal as
select
    deal_signal_id,
    deal_id,
    signal_type,
    signal_strength,
    signal_timestamp,
    source_system,
    source_record_id,
    created_at
from mart.deal_signals;

create or replace view mart.fact_outreach_event as
select
    outreach_event_id,
    deal_id,
    contact_id,
    channel,
    event_status,
    message_template,
    sent_at,
    created_at
from mart.outreach_events;

create or replace view mart.fact_crm_activity as
select
    crm_activity_id,
    company_id,
    deal_id,
    activity_type,
    activity_status,
    activity_timestamp,
    owner_name,
    created_at
from mart.crm_activities;

create or replace view mart.fact_deal_outcome as
select
    deal_outcome_id,
    deal_id,
    outcome_type,
    outcome_value,
    outcome_timestamp,
    created_at
from mart.deal_outcomes;

create or replace view mart.fact_scoring_result as
select
    scoring_result_id,
    deal_id,
    company_id,
    investor_id,
    deal_attractiveness_score,
    investor_fit_score,
    relationship_strength_score,
    overall_priority_score,
    score_version,
    created_at
from mart.scoring_results;
