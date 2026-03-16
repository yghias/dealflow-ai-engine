create or replace view mart.pipeline_conversion as
select
    q.owner_name,
    q.signal_type,
    count(*) as ranked_signals,
    sum(case when e.stage_advances > 0 then 1 else 0 end) as converted_signals,
    avg(q.overall_score) as average_score
from mart.mart_ranked_signal_queue q
left join mart.mart_strategy_effectiveness e
    on e.signal_id = q.signal_id
group by 1, 2;
