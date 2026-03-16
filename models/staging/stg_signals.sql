with standardized as (
    select
        source_record_id,
        source_system,
        event_type,
        event_timestamp,
        payload:company_name::string as company_name,
        lower(regexp_replace(payload:company_name::string, '[^a-zA-Z0-9]', '')) as normalized_company_name,
        payload:website::string as website,
        split_part(replace(payload:website::string, 'https://', ''), '/', 1) as domain,
        payload:sector::string as sector,
        payload:employee_count::number as employee_count,
        payload:funding_round::string as funding_round,
        payload:funding_amount_usd::number as funding_amount_usd,
        payload:investor_name::string as investor_name,
        loaded_at
    from raw.deal_signals_raw
)
select *
from standardized;
