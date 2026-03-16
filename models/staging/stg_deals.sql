with crm_deals as (
    select
        payload:deal_id::string as deal_id,
        payload:company_name::string as company_name,
        lower(regexp_replace(payload:company_name::string, '[^a-zA-Z0-9]', '')) as normalized_company_name,
        payload:deal_type::string as deal_type,
        payload:target_raise_amount::number as target_raise_amount,
        payload:pipeline_stage::string as pipeline_stage,
        payload:owner_name::string as owner_name,
        to_timestamp_ntz(payload:created_at::string) as created_at,
        to_timestamp_ntz(payload:updated_at::string) as updated_at
    from raw.crm_accounts_raw
    where payload:deal_id is not null
)
select *
from crm_deals;
