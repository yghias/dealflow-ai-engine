with signal_companies as (
    select
        source_record_id,
        company_name,
        normalized_company_name,
        domain,
        website,
        sector,
        employee_count,
        funding_round,
        funding_amount_usd,
        investor_name,
        event_type,
        event_timestamp,
        loaded_at
    from {{ ref('stg_signals') }}
),
crm_candidates as (
    select
        account_id,
        account_name,
        normalized_account_name,
        owner_name,
        sector as crm_sector,
        stage,
        last_activity_at
    from {{ ref('stg_crm_accounts') }}
),
ranked_matches as (
    select
        s.source_record_id,
        s.company_name,
        s.normalized_company_name,
        s.domain,
        s.website,
        s.sector,
        s.employee_count,
        s.funding_round,
        s.funding_amount_usd,
        s.investor_name,
        s.event_type,
        s.event_timestamp,
        c.account_id,
        c.account_name,
        c.owner_name,
        c.crm_sector,
        c.stage,
        c.last_activity_at,
        case
            when s.normalized_company_name = c.normalized_account_name then 'normalized_name_exact'
            when s.domain is not null and split_part(s.domain, '.', 1) = split_part(c.normalized_account_name, '.', 1) then 'domain_to_account_heuristic'
            else 'unmatched'
        end as match_method,
        case
            when s.normalized_company_name = c.normalized_account_name then 0.98
            when s.domain is not null and split_part(s.domain, '.', 1) = split_part(c.normalized_account_name, '.', 1) then 0.76
            else 0.25
        end as match_confidence,
        row_number() over (
            partition by s.source_record_id
            order by
                case
                    when s.normalized_company_name = c.normalized_account_name then 1
                    when s.domain is not null and split_part(s.domain, '.', 1) = split_part(c.normalized_account_name, '.', 1) then 2
                    else 3
                end,
                c.last_activity_at desc nulls last
        ) as match_rank
    from signal_companies s
    left join crm_candidates c
        on s.normalized_company_name = c.normalized_account_name
        or (s.domain is not null and split_part(s.domain, '.', 1) = split_part(c.normalized_account_name, '.', 1))
)
select
    source_record_id,
    company_name,
    normalized_company_name,
    domain,
    website,
    sector,
    employee_count,
    funding_round,
    funding_amount_usd,
    investor_name,
    event_type,
    event_timestamp,
    account_id,
    account_name,
    owner_name,
    crm_sector,
    stage,
    last_activity_at,
    match_method,
    match_confidence
from ranked_matches
where match_rank = 1;
