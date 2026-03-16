select
    payload:account_id::string as account_id,
    payload:account_name::string as account_name,
    lower(regexp_replace(payload:account_name::string, '[^a-zA-Z0-9]', '')) as normalized_account_name,
    payload:owner_name::string as owner_name,
    payload:sector::string as sector,
    payload:stage::string as stage,
    to_timestamp_ntz(payload:last_activity_at::string) as last_activity_at,
    extracted_at,
    loaded_at
from raw.crm_accounts_raw;
