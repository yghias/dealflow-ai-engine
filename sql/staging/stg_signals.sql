create or replace view staging.stg_signal_event as
select
    payload:source::string as source_system,
    source_record_id,
    payload:title::string as signal_title,
    payload:url::string as signal_url,
    payload:signal_type::string as signal_type,
    payload:summary::string as signal_summary,
    payload:metadata:organization_name::string as organization_name,
    to_timestamp_ntz(payload:detected_at::string) as detected_at,
    loaded_at
from raw.external_signal_event;
