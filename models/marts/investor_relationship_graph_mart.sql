with co_signal_pairs as (
    select
        a.investor_name as investor_name_left,
        b.investor_name as investor_name_right,
        count(*) as shared_signal_count
    from {{ ref('stg_signals') }} a
    join {{ ref('stg_signals') }} b
        on a.normalized_company_name = b.normalized_company_name
       and a.investor_name < b.investor_name
       and a.investor_name is not null
       and b.investor_name is not null
    group by 1, 2
)
select
    investor_name_left,
    investor_name_right,
    shared_signal_count,
    case
        when shared_signal_count >= 5 then 'strong'
        when shared_signal_count >= 2 then 'medium'
        else 'weak'
    end as relationship_band
from co_signal_pairs;
