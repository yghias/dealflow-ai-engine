with source as (
    select
        payload:source::string as source_system,
        payload:title::string as signal_title,
        payload:url::string as signal_url,
        payload:signal_type::string as signal_type,
        payload:summary::string as signal_summary,
        payload:metadata:organization_name::string as organization_name,
        to_timestamp_ntz(payload:detected_at::string) as detected_at,
        loaded_at,
        source_record_id
    from raw.external_signal_event
)
select
    source_system,
    source_record_id,
    signal_title,
    signal_url,
    signal_type,
    signal_summary,
    organization_name,
    detected_at,
    loaded_at
from source;
