select
    signal_id,
    organization_name,
    crm_account_id,
    owner_name,
    signal_type,
    overall_score,
    case
        when overall_score >= 0.85 then 'priority_1'
        when overall_score >= 0.75 then 'priority_2'
        else 'priority_3'
    end as queue_tier,
    current_timestamp() as published_at
from {{ ref('int_signal_scores') }}
qualify row_number() over (
    partition by owner_name
    order by overall_score desc, signal_id
) <= 50;
