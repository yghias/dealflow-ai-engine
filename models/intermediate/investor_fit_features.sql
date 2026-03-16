with company_sector_context as (
    select
        d.deal_id,
        c.company_id,
        c.company_name,
        c.sector,
        c.headquarters_country,
        d.deal_type,
        d.target_raise_amount
    from mart.deals d
    join mart.companies c
        on c.company_id = d.company_id
),
investor_context as (
    select
        i.investor_id,
        i.investor_name,
        i.focus_sectors,
        i.geography_focus,
        i.investor_type,
        ip.average_check_size,
        ip.stage_preference,
        ip.relationship_strength,
        ip.last_engagement_at
    from mart.investors i
    left join mart.investor_profiles ip
        on ip.investor_id = i.investor_id
),
cross_joined as (
    select
        c.deal_id,
        c.company_id,
        c.company_name,
        c.sector,
        c.headquarters_country,
        c.deal_type,
        c.target_raise_amount,
        i.investor_id,
        i.investor_name,
        i.focus_sectors,
        i.geography_focus,
        i.investor_type,
        i.average_check_size,
        i.stage_preference,
        coalesce(i.relationship_strength, 0.35) as relationship_strength,
        i.last_engagement_at
    from company_sector_context c
    cross join investor_context i
),
scored as (
    select
        deal_id,
        company_id,
        company_name,
        investor_id,
        investor_name,
        sector,
        headquarters_country,
        deal_type,
        target_raise_amount,
        focus_sectors,
        geography_focus,
        investor_type,
        average_check_size,
        stage_preference,
        relationship_strength,
        last_engagement_at,
        case
            when focus_sectors ilike '%' || sector || '%' then 1.0
            when focus_sectors ilike '%software%' and sector ilike '%software%' then 0.82
            else 0.45
        end as sector_alignment_score,
        case
            when deal_type ilike '%equity%' and stage_preference ilike '%series%' then 0.85
            when stage_preference is null then 0.50
            else 0.65
        end as stage_alignment_score,
        case
            when geography_focus ilike '%' || headquarters_country || '%' then 0.90
            when geography_focus ilike '%north america%' and headquarters_country in ('United States', 'Canada') then 0.78
            else 0.52
        end as geography_alignment_score,
        case
            when average_check_size is null then 0.50
            when average_check_size >= target_raise_amount * 0.30 then 0.92
            when average_check_size >= target_raise_amount * 0.15 then 0.76
            else 0.48
        end as check_size_alignment_score
    from cross_joined
)
select
    deal_id,
    company_id,
    company_name,
    investor_id,
    investor_name,
    sector_alignment_score,
    stage_alignment_score,
    geography_alignment_score,
    check_size_alignment_score,
    relationship_strength,
    round(
        (sector_alignment_score * 0.32) +
        (stage_alignment_score * 0.20) +
        (geography_alignment_score * 0.14) +
        (check_size_alignment_score * 0.18) +
        (relationship_strength * 0.16),
        4
    ) as investor_fit_score,
    current_timestamp() as computed_at
from scored;
