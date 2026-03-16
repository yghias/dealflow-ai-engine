with signal_company as (
    select
        source_record_id as signal_id,
        organization_name,
        signal_type,
        signal_summary,
        detected_at
    from {{ ref('stg_signal_event') }}
),
crm_account as (
    select
        crm_account_id,
        account_name,
        owner_name,
        sector,
        region,
        stage
    from {{ ref('stg_crm_account') }}
)
select
    s.signal_id,
    s.organization_name,
    c.crm_account_id,
    c.owner_name,
    c.sector,
    c.region,
    c.stage,
    case
        when upper(s.organization_name) = upper(c.account_name) then 'exact_name'
        when regexp_replace(lower(s.organization_name), '[^a-z0-9]', '') = regexp_replace(lower(c.account_name), '[^a-z0-9]', '') then 'normalized_name'
        else 'unmatched'
    end as match_method,
    case
        when upper(s.organization_name) = upper(c.account_name) then 0.98
        when regexp_replace(lower(s.organization_name), '[^a-z0-9]', '') = regexp_replace(lower(c.account_name), '[^a-z0-9]', '') then 0.85
        else 0.35
    end as match_confidence
from signal_company s
left join crm_account c
    on regexp_replace(lower(s.organization_name), '[^a-z0-9]', '') = regexp_replace(lower(c.account_name), '[^a-z0-9]', '');
