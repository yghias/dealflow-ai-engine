create or replace view mart.signal_pipeline_summary as
select
    se.signal_type,
    count(*) as signal_count,
    avg(sr.overall_score) as avg_score,
    count(distinct t.task_id) as tasks_created
from core.signal_event se
left join core.score_result sr on sr.signal_id = se.signal_id
left join core.strategy_recommendation rec on rec.signal_id = se.signal_id
left join core.task t on t.recommendation_id = rec.recommendation_id
group by 1;
