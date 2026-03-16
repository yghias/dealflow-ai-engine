create or replace view mart.signal_source_quality as
select
    source_system,
    signal_type,
    count(*) as signal_count,
    avg(case when organization_name is not null then 1 else 0 end) as named_entity_coverage
from staging.stg_signal_event
group by 1, 2;
