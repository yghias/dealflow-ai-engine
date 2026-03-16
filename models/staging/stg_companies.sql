with raw_source as (
    select
        payload:company_name::string as company_name,
        lower(regexp_replace(payload:company_name::string, '[^a-zA-Z0-9]', '')) as normalized_name,
        payload:website::string as website,
        split_part(replace(payload:website::string, 'https://', ''), '/', 1) as domain,
        payload:sector::string as sector,
        payload:employee_count::number as employee_count,
        payload:funding_round::string as latest_funding_round,
        payload:funding_amount_usd::number as latest_funding_amount,
        source_system,
        source_record_id,
        event_timestamp as source_event_timestamp,
        loaded_at
    from raw.deal_signals_raw
)
select *
from raw_source;
