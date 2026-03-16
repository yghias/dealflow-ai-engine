select
    signal_id,
    organization_name,
    crm_account_id,
    owner_name,
    signal_type,
    overall_score,
    case
        when overall_score >= 0.85 then 'high'
        when overall_score >= 0.70 then 'medium'
        else 'low'
    end as priority_band,
    object_construct(
        'organization_name', organization_name,
        'signal_type', signal_type,
        'overall_score', overall_score,
        'owner_name', owner_name
    ) as request_payload
from {{ ref('int_signal_scores') }}
where overall_score >= 0.70;
