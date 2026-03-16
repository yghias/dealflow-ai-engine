select
    payload:crm_activity_id::string as crm_activity_id,
    payload:company_name::string as company_name,
    lower(regexp_replace(payload:company_name::string, '[^a-zA-Z0-9]', '')) as normalized_company_name,
    payload:deal_id::string as deal_id,
    payload:activity_type::string as activity_type,
    payload:activity_status::string as activity_status,
    to_timestamp_ntz(payload:activity_timestamp::string) as activity_timestamp,
    payload:owner_name::string as owner_name,
    loaded_at
from raw.crm_activities_raw;
