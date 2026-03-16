with base as (
    select
        r.signal_id,
        r.organization_name,
        r.crm_account_id,
        coalesce(r.owner_name, 'unassigned_queue') as owner_name,
        r.sector,
        r.region,
        r.signal_type,
        r.match_confidence,
        case when r.signal_type in ('funding', 'expansion', 'leadership_change', 'partnership') then 0.95 else 0.70 end as signal_priority_score,
        case when r.crm_account_id is not null then 0.90 else 0.55 end as crm_context_score,
        case when r.sector in ('Software', 'B2B Software', 'Data Infrastructure') then 0.88 else 0.68 end as sector_fit_score
    from (
        select
            e.signal_id,
            e.organization_name,
            e.crm_account_id,
            e.owner_name,
            e.sector,
            e.region,
            s.signal_type,
            e.match_confidence
        from {{ ref('int_entity_resolution') }} e
        join {{ ref('stg_signal_event') }} s
            on s.source_record_id = e.signal_id
    ) r
)
select
    signal_id,
    organization_name,
    crm_account_id,
    owner_name,
    sector,
    region,
    signal_type,
    signal_priority_score,
    crm_context_score,
    sector_fit_score,
    match_confidence,
    round(
        (signal_priority_score * 0.35) +
        (crm_context_score * 0.25) +
        (sector_fit_score * 0.25) +
        (match_confidence * 0.15),
        4
    ) as overall_score
from base;
