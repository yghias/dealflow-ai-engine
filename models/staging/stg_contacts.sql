with company_contacts as (
    select
        payload:contact_id::string as contact_id,
        payload:company_name::string as company_name,
        lower(regexp_replace(payload:company_name::string, '[^a-zA-Z0-9]', '')) as normalized_company_name,
        payload:full_name::string as full_name,
        payload:title::string as title,
        payload:email::string as email,
        payload:linkedin_url::string as linkedin_url,
        loaded_at
    from raw.crm_accounts_raw
    where payload:contact_id is not null
)
select *
from company_contacts;
