create or replace procedure ops.sp_backfill_signals(start_date timestamp_ntz, end_date timestamp_ntz)
returns string
language sql
as
$$
begin
    insert into ops.pipeline_runs (
        pipeline_run_id,
        pipeline_name,
        run_status,
        started_at,
        completed_at,
        row_count,
        error_message
    )
    select
        md5(concat('backfill_signals', '::', start_date::string, '::', end_date::string)),
        'backfill_signals',
        'completed',
        current_timestamp(),
        current_timestamp(),
        count(*),
        null
    from raw.deal_signals_raw
    where event_timestamp between start_date and end_date;

    return 'signal backfill recorded';
end;
$$;

create or replace procedure ops.sp_refresh_priority_scores()
returns string
language sql
as
$$
begin
    create or replace temporary table tmp_scoring_results as
    select
        scoring_result_id,
        deal_id,
        investor_id,
        deal_attractiveness_score,
        investor_fit_score,
        relationship_strength_score,
        overall_priority_score,
        score_version,
        created_at
    from mart.scoring_results;

    insert into ops.pipeline_runs (
        pipeline_run_id,
        pipeline_name,
        run_status,
        started_at,
        completed_at,
        row_count,
        error_message
    )
    select
        md5(concat('refresh_priority_scores', '::', current_timestamp()::string)),
        'refresh_priority_scores',
        'completed',
        current_timestamp(),
        current_timestamp(),
        count(*),
        null
    from tmp_scoring_results;

    return 'priority score refresh registered';
end;
$$;

create or replace procedure ops.sp_reconcile_crm_dispatch()
returns string
language sql
as
$$
begin
    insert into ops.pipeline_runs (
        pipeline_run_id,
        pipeline_name,
        run_status,
        started_at,
        completed_at,
        row_count,
        error_message
    )
    select
        md5(concat('reconcile_crm_dispatch', '::', current_timestamp()::string)),
        'reconcile_crm_dispatch',
        'completed',
        current_timestamp(),
        current_timestamp(),
        count(*),
        null
    from ops.reconciliation_crm_dispatch;

    return 'crm reconciliation recorded';
end;
$$;
