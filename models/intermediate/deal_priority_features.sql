deal_base as (
    select
        d.deal_id,
        d.company_name,
        d.normalized_company_name,
        d.deal_type,
        d.target_raise_amount,
        d.pipeline_stage,
        d.owner_name,
        d.created_at,
        d.updated_at,
        r.account_id,
        r.match_confidence,
        r.stage as crm_stage,
        r.last_activity_at
    from {{ ref('stg_deals') }} d
    left join {{ ref('company_entity_resolution') }} r
        on r.normalized_company_name = d.normalized_company_name
),
assembled as (
    select
        b.deal_id,
        b.company_name,
        b.normalized_company_name,
        b.deal_type,
        b.target_raise_amount,
        b.pipeline_stage,
        b.owner_name,
        b.created_at,
        b.updated_at,
        b.account_id,
        coalesce(b.match_confidence, 0.25) as entity_resolution_confidence,
        coalesce(s.distinct_signal_days, 0) as signal_count_all_time,
        least(coalesce(s.distinct_signal_days, 0), 30) as signal_count_30d,
        coalesce(s.funding_signal_days, 0) as funding_signal_count_90d,
        coalesce(s.hiring_signal_days, 0) as hiring_signal_count_30d,
        coalesce(s.leadership_signal_days, 0) as leadership_signal_count_60d,
        coalesce(a.crm_activity_count_all_time, 0) as crm_activity_count_all_time,
        coalesce(a.crm_activity_count_30d, 0) as crm_activity_count_30d,
        coalesce(a.meetings_booked_90d, 0) as meeting_booked_count_90d,
        coalesce(ec.data_completeness_score, 0.35) as data_completeness_score,
        s.latest_signal_timestamp,
        a.latest_crm_activity_timestamp
    from deal_base b
    left join {{ ref('company_signal_rollup') }} s
        on s.normalized_company_name = b.normalized_company_name
    left join {{ ref('crm_activity_rollup') }} a
        on a.normalized_company_name = b.normalized_company_name
    left join {{ ref('enrichment_completeness') }} ec
        on ec.normalized_company_name = b.normalized_company_name
)
select
    deal_id,
    company_name,
    normalized_company_name,
    deal_type,
    target_raise_amount,
    pipeline_stage,
    owner_name,
    account_id,
    entity_resolution_confidence,
    signal_count_all_time,
    signal_count_30d,
    funding_signal_count_90d,
    hiring_signal_count_30d,
    leadership_signal_count_60d,
    crm_activity_count_all_time,
    crm_activity_count_30d,
    meeting_booked_count_90d,
    data_completeness_score,
    latest_signal_timestamp,
    latest_crm_activity_timestamp,
    case
        when target_raise_amount >= 50000000 then 1.00
        when target_raise_amount >= 25000000 then 0.82
        when target_raise_amount >= 10000000 then 0.64
        else 0.45
    end as deal_size_score,
    least(1.0, signal_count_30d / 6.0) as recent_signal_density_score,
    least(1.0, crm_activity_count_30d / 8.0) as crm_engagement_score,
    least(1.0, meeting_booked_count_90d / 3.0) as meeting_momentum_score,
    current_timestamp() as computed_at
from assembled;
