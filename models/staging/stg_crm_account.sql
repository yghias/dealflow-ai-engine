select
    payload:account_id::string as crm_account_id,
    payload:account_name::string as account_name,
    payload:owner_name::string as owner_name,
    payload:sector::string as sector,
    payload:region::string as region,
    payload:stage::string as stage,
    loaded_at,
    source_record_id
from raw.crm_account_snapshot;
