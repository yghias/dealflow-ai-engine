with investor_company_pairs as (
    select distinct
        normalized_company_name,
        investor_name
    from {{ ref('stg_signals') }}
    where investor_name is not null
),
pair_edges as (
    select
        a.investor_name as investor_name_left,
        b.investor_name as investor_name_right,
        count(*) as shared_company_count
    from investor_company_pairs a
    join investor_company_pairs b
        on a.normalized_company_name = b.normalized_company_name
       and a.investor_name < b.investor_name
    group by 1, 2
)
select
    investor_name_left,
    investor_name_right,
    shared_company_count,
    case
        when shared_company_count >= 6 then 0.95
        when shared_company_count >= 3 then 0.75
        when shared_company_count >= 1 then 0.50
        else 0.10
    end as relationship_edge_score
from pair_edges;
