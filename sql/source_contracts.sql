create or replace view ops.contract_deal_signal_required_fields as
select
    source_record_id,
    source_system,
    event_type,
    event_timestamp,
    payload:company_name::string as company_name,
    payload:website::string as website,
    payload:sector::string as sector,
    case
        when source_record_id is null then 'missing_source_record_id'
        when event_type is null then 'missing_event_type'
        when event_timestamp is null then 'missing_event_timestamp'
        when payload:company_name::string is null then 'missing_company_name'
        else 'valid'
    end as contract_status
from raw.deal_signals_raw;

create or replace view ops.contract_crm_account_required_fields as
select
    source_record_id,
    source_system,
    payload:account_id::string as account_id,
    payload:account_name::string as account_name,
    payload:owner_name::string as owner_name,
    case
        when payload:account_id::string is null then 'missing_account_id'
        when payload:account_name::string is null then 'missing_account_name'
        else 'valid'
    end as contract_status
from raw.crm_accounts_raw;

create or replace view ops.contract_investor_directory_required_fields as
select
    source_record_id,
    source_system,
    payload:investor_id::string as investor_id,
    payload:investor_name::string as investor_name,
    payload:focus_sectors::string as focus_sectors,
    case
        when payload:investor_id::string is null then 'missing_investor_id'
        when payload:investor_name::string is null then 'missing_investor_name'
        else 'valid'
    end as contract_status
from raw.investor_directory_raw;
