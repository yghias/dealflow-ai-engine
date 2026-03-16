select
    payload:activity_id::string as crm_activity_id,
    payload:account_id::string as crm_account_id,
    payload:activity_type::string as activity_type,
    payload:activity_status::string as activity_status,
    to_timestamp_ntz(payload:activity_at::string) as activity_at,
    payload:related_signal_id::string as related_signal_id,
    loaded_at
from raw.crm_activity_snapshot;
