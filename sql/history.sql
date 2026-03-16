create or replace view mart.company_signal_history as
select
    c.company_id,
    c.company_name,
    cs.signal_type,
    cs.signal_timestamp,
    cs.signal_value,
    cs.is_late_arriving,
    row_number() over (
        partition by c.company_id, cs.signal_type
        order by cs.signal_timestamp desc
    ) as signal_recency_rank
from mart.companies c
join mart.company_signals cs
    on cs.company_id = c.company_id;

create or replace view mart.deal_stage_history as
select
    d.deal_id,
    d.company_id,
    d.pipeline_stage,
    d.created_at,
    d.updated_at,
    datediff('day', d.created_at, coalesce(d.updated_at, current_timestamp())) as days_in_stage
from mart.deals d;

create or replace view mart.investor_engagement_history as
select
    ie.investor_id,
    ie.deal_id,
    ie.outreach_touch_count,
    ie.responded_touch_count,
    ie.latest_outreach_at,
    row_number() over (
        partition by ie.investor_id
        order by ie.latest_outreach_at desc nulls last
    ) as engagement_recency_rank
from mart.investor_engagement_mart ie;
