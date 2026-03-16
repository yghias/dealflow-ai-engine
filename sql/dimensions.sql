create or replace view mart.dim_company as
select
    company_id,
    company_name,
    normalized_name,
    website,
    domain,
    headquarters_city,
    headquarters_country,
    sector,
    employee_count,
    latest_funding_round,
    latest_funding_amount,
    created_at,
    updated_at
from mart.companies;

create or replace view mart.dim_investor as
select
    investor_id,
    investor_name,
    investor_type,
    focus_sectors,
    geography_focus,
    created_at,
    updated_at
from mart.investors;

create or replace view mart.dim_contact as
select
    contact_id,
    company_id,
    investor_id,
    full_name,
    title,
    email,
    linkedin_url,
    created_at,
    updated_at
from mart.contacts;

create or replace view mart.dim_deal as
select
    deal_id,
    company_id,
    deal_type,
    target_raise_amount,
    pipeline_stage,
    owner_name,
    created_at,
    updated_at
from mart.deals;

create or replace view mart.dim_signal_type as
select distinct
    signal_type
from mart.company_signals
union
select distinct
    signal_type
from mart.deal_signals;
