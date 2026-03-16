create or replace view ops.reconciliation_signal_to_company as
select
    ds.source_record_id,
    ds.payload:company_name::string as raw_company_name,
    c.company_id,
    c.company_name,
    case when c.company_id is null then 'unmatched' else 'matched' end as reconciliation_status
from raw.deal_signals_raw ds
left join mart.companies c
    on lower(regexp_replace(ds.payload:company_name::string, '[^a-zA-Z0-9]', '')) = c.normalized_name;

create or replace view ops.reconciliation_deal_to_score as
select
    d.deal_id,
    d.pipeline_stage,
    sr.scoring_result_id,
    sr.overall_priority_score,
    case when sr.scoring_result_id is null then 'missing_score' else 'scored' end as reconciliation_status
from mart.deals d
left join mart.scoring_results sr
    on sr.deal_id = d.deal_id;

create or replace view ops.reconciliation_crm_dispatch as
select
    d.deal_id,
    d.owner_name,
    count(a.crm_activity_id) as crm_activity_count,
    count(o.outreach_event_id) as outreach_count,
    case
        when count(a.crm_activity_id) = 0 and count(o.outreach_event_id) = 0 then 'no_dispatch_activity'
        when count(a.crm_activity_id) > 0 or count(o.outreach_event_id) > 0 then 'dispatch_observed'
        else 'unknown'
    end as reconciliation_status
from mart.deals d
left join mart.crm_activities a
    on a.deal_id = d.deal_id
left join mart.outreach_events o
    on o.deal_id = d.deal_id
group by 1,2;
