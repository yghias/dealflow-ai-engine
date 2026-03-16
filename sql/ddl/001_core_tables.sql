create schema if not exists raw;
create schema if not exists staging;
create schema if not exists intermediate;
create schema if not exists mart;

create or replace table raw.external_signal_event (
    batch_id string,
    source_system string,
    source_record_id string,
    payload variant,
    loaded_at timestamp_ntz default current_timestamp()
);

create or replace table raw.crm_account_snapshot (
    batch_id string,
    source_record_id string,
    payload variant,
    loaded_at timestamp_ntz default current_timestamp()
);

create or replace table raw.crm_activity_snapshot (
    batch_id string,
    source_record_id string,
    payload variant,
    loaded_at timestamp_ntz default current_timestamp()
);

create or replace table mart.strategy_recommendation (
    recommendation_id string,
    signal_id string,
    prompt_version string,
    model_name string,
    recommendation_payload variant,
    created_at timestamp_ntz default current_timestamp()
);
