select
    investor_id,
    investor_name,
    deal_id,
    company_name,
    investor_fit_score,
    investor_rank
from mart.investor_matching_mart
where investor_rank <= 10;
