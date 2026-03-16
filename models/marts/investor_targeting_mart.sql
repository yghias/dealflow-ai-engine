select
    s.deal_id,
    d.owner_name,
    c.company_name,
    s.investor_id,
    s.investor_name,
    s.deal_attractiveness_score,
    s.investor_fit_score,
    s.relationship_strength_score,
    s.overall_priority_score,
    row_number() over (
        partition by s.deal_id
        order by s.overall_priority_score desc, s.investor_fit_score desc
    ) as investor_priority_rank
from {{ ref('scoring_results_snapshot') }} s
join mart.deals d
    on d.deal_id = s.deal_id
join mart.companies c
    on c.company_id = d.company_id
qualify investor_priority_rank <= 15;
