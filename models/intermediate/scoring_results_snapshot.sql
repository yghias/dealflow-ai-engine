with deal_priority as (
    select
        deal_id,
        company_name,
        owner_name,
        round(
            (deal_size_score * 0.22) +
            (recent_signal_density_score * 0.26) +
            (crm_engagement_score * 0.18) +
            (meeting_momentum_score * 0.10) +
            (entity_resolution_confidence * 0.24),
            4
        ) as deal_attractiveness_score
    from {{ ref('deal_priority_features') }}
),
investor_fit as (
    select
        deal_id,
        investor_id,
        investor_name,
        relationship_strength,
        investor_fit_score
    from {{ ref('investor_fit_features') }}
),
assembled as (
    select
        d.deal_id,
        d.deal_attractiveness_score,
        i.investor_id,
        i.investor_name,
        i.investor_fit_score,
        i.relationship_strength,
        round(
            (d.deal_attractiveness_score * 0.48) +
            (i.investor_fit_score * 0.34) +
            (i.relationship_strength * 0.18),
            4
        ) as overall_priority_score
    from deal_priority d
    join investor_fit i
        on i.deal_id = d.deal_id
)
select
    md5(concat(deal_id, '::', coalesce(investor_id, 'no_investor'))) as scoring_result_id,
    deal_id,
    investor_id,
    investor_name,
    deal_attractiveness_score,
    investor_fit_score,
    relationship_strength as relationship_strength_score,
    overall_priority_score,
    'v2_sql_priority_model' as score_version,
    current_timestamp() as created_at
from assembled;
