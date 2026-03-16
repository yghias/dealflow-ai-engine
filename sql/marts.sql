create or replace view mart.deal_pipeline_mart as
select
    d.deal_id,
    c.company_name,
    d.pipeline_stage,
    d.owner_name,
    sr.deal_attractiveness_score,
    sr.investor_fit_score,
    sr.relationship_strength_score,
    sr.overall_priority_score,
    count(distinct oe.outreach_event_id) as outreach_events,
    max(cs.signal_timestamp) as latest_signal_at
from mart.deals d
join mart.companies c on c.company_id = d.company_id
left join mart.scoring_results sr on sr.deal_id = d.deal_id
left join mart.outreach_events oe on oe.deal_id = d.deal_id
left join mart.company_signals cs on cs.company_id = d.company_id
group by 1,2,3,4,5,6,7,8;

create or replace view mart.investor_matching_mart as
select
    i.investor_id,
    i.investor_name,
    d.deal_id,
    c.company_name,
    ip.stage_preference,
    ip.relationship_strength,
    sr.investor_fit_score,
    row_number() over (
        partition by d.deal_id
        order by sr.investor_fit_score desc, ip.relationship_strength desc
    ) as investor_rank
from mart.investors i
join mart.investor_profiles ip on ip.investor_id = i.investor_id
join mart.scoring_results sr on sr.investor_id = i.investor_id
join mart.deals d on d.deal_id = sr.deal_id
join mart.companies c on c.company_id = d.company_id;

create or replace view mart.signal_activity_mart as
with deduped as (
    select
        company_id,
        signal_type,
        signal_timestamp,
        is_late_arriving,
        row_number() over (
            partition by company_id, signal_type, date_trunc('day', signal_timestamp)
            order by signal_timestamp desc
        ) as rn
    from mart.company_signals
)
select
    company_id,
    signal_type,
    count(*) as signal_count,
    max(signal_timestamp) as latest_signal_timestamp,
    sum(case when is_late_arriving then 1 else 0 end) as late_arriving_updates
from deduped
where rn = 1
group by 1,2;

create or replace view mart.outreach_performance_mart as
select
    d.owner_name,
    oe.channel,
    count(*) as outreach_sent,
    sum(case when oe.event_status = 'responded' then 1 else 0 end) as responses,
    round(
        sum(case when oe.event_status = 'responded' then 1 else 0 end)::float / nullif(count(*), 0),
        4
    ) as response_rate
from mart.outreach_events oe
join mart.deals d on d.deal_id = oe.deal_id
group by 1,2;
