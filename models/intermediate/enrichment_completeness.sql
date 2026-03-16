with company_completeness as (
    select
        normalized_company_name,
        avg(case when company_name is not null then 1 else 0 end) as has_company_name,
        avg(case when website is not null then 1 else 0 end) as has_website,
        avg(case when domain is not null then 1 else 0 end) as has_domain,
        avg(case when sector is not null then 1 else 0 end) as has_sector,
        avg(case when employee_count is not null then 1 else 0 end) as has_employee_count,
        avg(case when funding_round is not null then 1 else 0 end) as has_funding_round
    from {{ ref('stg_signals') }}
    group by 1
)
select
    normalized_company_name,
    round(
        (has_company_name * 0.20) +
        (has_website * 0.15) +
        (has_domain * 0.15) +
        (has_sector * 0.20) +
        (has_employee_count * 0.15) +
        (has_funding_round * 0.15),
        4
    ) as data_completeness_score
from company_completeness;
