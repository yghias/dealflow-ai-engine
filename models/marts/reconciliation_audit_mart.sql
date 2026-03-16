select
    deal_id,
    pipeline_stage,
    overall_priority_score,
    case
        when overall_priority_score is null then 'missing_score'
        when pipeline_stage is null then 'missing_stage'
        else 'reconciled'
    end as audit_status
from mart.deal_pipeline_mart;
