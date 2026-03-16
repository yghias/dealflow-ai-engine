create or replace view intermediate.incremental_signal_candidates as
select
    source_record_id,
    source_system,
    event_type,
    event_timestamp,
    payload,
    loaded_at
from raw.deal_signals_raw
where loaded_at >= dateadd('day', -7, current_timestamp());

create or replace view intermediate.incremental_crm_account_candidates as
select
    source_record_id,
    source_system,
    extracted_at,
    payload,
    loaded_at
from raw.crm_accounts_raw
where loaded_at >= dateadd('day', -7, current_timestamp());

create or replace view intermediate.incremental_crm_activity_candidates as
select
    source_record_id,
    source_system,
    extracted_at,
    payload,
    loaded_at
from raw.crm_activities_raw
where loaded_at >= dateadd('day', -7, current_timestamp());

create or replace view intermediate.incremental_investor_directory_candidates as
select
    source_record_id,
    source_system,
    extracted_at,
    payload,
    loaded_at
from raw.investor_directory_raw
where loaded_at >= dateadd('day', -7, current_timestamp());
