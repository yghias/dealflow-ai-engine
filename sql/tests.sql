select company_name, count(*)
from mart.companies
group by 1
having count(*) > 1;

select *
from mart.contacts
where full_name is null
   or title is null;

select *
from mart.deals d
left join mart.companies c on c.company_id = d.company_id
where c.company_id is null;

select *
from mart.scoring_results
where overall_priority_score < 0
   or overall_priority_score > 1;

select
    source_record_id,
    count(*)
from raw.deal_signals_raw
group by 1
having count(*) > 1;

select *
from mart.deals d
left join mart.scoring_results sr
    on sr.deal_id = d.deal_id
where sr.deal_id is null;

select *
from mart.crm_activities
where activity_timestamp > current_timestamp();

select
    deal_id,
    investor_id,
    count(*)
from mart.scoring_results
group by 1,2
having count(*) > 1;

select *
from mart.investor_profiles
where relationship_strength < 0
   or relationship_strength > 1;

select *
from mart.outreach_events
where channel not in ('email', 'linkedin', 'call', 'meeting');

select *
from mart.crm_activities a
left join mart.deals d
    on d.deal_id = a.deal_id
where a.deal_id is not null
  and d.deal_id is null;

select
    normalized_name,
    count(distinct company_id) as distinct_company_ids
from mart.companies
group by 1
having count(distinct company_id) > 1;

select *
from mart.deal_pipeline_mart
where overall_priority_score is null;

select *
from mart.investor_matching_mart
where investor_rank <= 0;

select *
from mart.crm_lifecycle_mart
where active_lifecycle_days < 0;

select *
from mart.deal_velocity_mart
where avg_pipeline_days < 0;

select *
from mart.investor_relationship_graph_mart
where shared_company_count <= 0;

select *
from mart.signal_quality_mart
where distinct_signals > landed_signals;

select *
from mart.semantic_metrics_mart
where outreach_response_rate < 0
   or outreach_response_rate > 1;

select *
from mart.source_performance_mart
where distinct_signals > landed_signals;

select *
from mart.owner_capacity_mart
where open_deals < 0
   or crm_activities_30d < 0;

select *
from mart.pipeline_conversion_mart
where deal_count < qualified_outcomes;

select *
from mart.investor_engagement_mart
where responded_touch_count > outreach_touch_count;
