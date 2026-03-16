create schema if not exists raw;
create schema if not exists staging;
create schema if not exists intermediate;
create schema if not exists mart;
create schema if not exists ops;

create or replace table raw.deal_signals_raw (
    source_record_id string,
    source_system string,
    event_type string,
    event_timestamp timestamp_ntz,
    payload variant,
    loaded_at timestamp_ntz default current_timestamp()
);

create or replace table raw.crm_accounts_raw (
    source_record_id string,
    source_system string,
    extracted_at timestamp_ntz,
    payload variant,
    loaded_at timestamp_ntz default current_timestamp()
);

create or replace table raw.crm_activities_raw (
    source_record_id string,
    source_system string,
    extracted_at timestamp_ntz,
    payload variant,
    loaded_at timestamp_ntz default current_timestamp()
);

create or replace table raw.investor_directory_raw (
    source_record_id string,
    source_system string,
    extracted_at timestamp_ntz,
    payload variant,
    loaded_at timestamp_ntz default current_timestamp()
);

create or replace table staging.company_signal_events (
    source_record_id string,
    source_system string,
    event_type string,
    event_timestamp timestamp_ntz,
    company_name string,
    normalized_company_name string,
    website string,
    domain string,
    sector string,
    employee_count number,
    funding_round string,
    funding_amount_usd number(18,2),
    investor_name string,
    loaded_at timestamp_ntz
);

create or replace table staging.crm_accounts (
    account_id string,
    account_name string,
    normalized_account_name string,
    owner_name string,
    sector string,
    stage string,
    last_activity_at timestamp_ntz,
    extracted_at timestamp_ntz,
    loaded_at timestamp_ntz
);

create or replace table staging.crm_activities (
    crm_activity_id string,
    company_name string,
    normalized_company_name string,
    deal_id string,
    activity_type string,
    activity_status string,
    activity_timestamp timestamp_ntz,
    owner_name string,
    loaded_at timestamp_ntz
);

create or replace table staging.investor_directory (
    investor_id string,
    investor_name string,
    normalized_investor_name string,
    investor_type string,
    focus_sectors string,
    geography_focus string,
    average_check_size number(18,2),
    extracted_at timestamp_ntz,
    loaded_at timestamp_ntz
);

create or replace table intermediate.company_entity_matches (
    source_record_id string,
    company_name string,
    normalized_company_name string,
    matched_account_id string,
    matched_account_name string,
    match_method string,
    match_confidence number(10,4),
    loaded_at timestamp_ntz
);

create or replace table intermediate.deal_priority_features (
    deal_id string,
    company_id string,
    latest_signal_timestamp timestamp_ntz,
    signal_count_30d number,
    funding_signal_count_90d number,
    hiring_signal_count_30d number,
    crm_activity_count_30d number,
    investor_engagement_count_90d number,
    relationship_strength_score number(10,4),
    data_completeness_score number(10,4),
    computed_at timestamp_ntz
);

create or replace table intermediate.investor_fit_features (
    deal_id string,
    investor_id string,
    sector_alignment_score number(10,4),
    stage_alignment_score number(10,4),
    geography_alignment_score number(10,4),
    historical_participation_score number(10,4),
    relationship_strength_score number(10,4),
    computed_at timestamp_ntz
);

create or replace table mart.companies (
    company_id string primary key,
    company_name string,
    normalized_name string,
    website string,
    domain string,
    headquarters_city string,
    headquarters_country string,
    sector string,
    employee_count number,
    latest_funding_round string,
    latest_funding_amount number(18,2),
    source_system string,
    source_record_id string,
    created_at timestamp_ntz,
    updated_at timestamp_ntz
);

create or replace table mart.investors (
    investor_id string primary key,
    investor_name string,
    investor_type string,
    focus_sectors string,
    geography_focus string,
    source_system string,
    source_record_id string,
    created_at timestamp_ntz,
    updated_at timestamp_ntz
);

create or replace table mart.contacts (
    contact_id string primary key,
    company_id string references mart.companies(company_id),
    investor_id string references mart.investors(investor_id),
    full_name string,
    title string,
    email string,
    linkedin_url string,
    created_at timestamp_ntz,
    updated_at timestamp_ntz
);

create or replace table mart.deals (
    deal_id string primary key,
    company_id string references mart.companies(company_id),
    deal_type string,
    target_raise_amount number(18,2),
    pipeline_stage string,
    owner_name string,
    created_at timestamp_ntz,
    updated_at timestamp_ntz
);

create or replace table mart.deal_signals (
    deal_signal_id string primary key,
    deal_id string references mart.deals(deal_id),
    signal_type string,
    signal_strength number(10,4),
    signal_timestamp timestamp_ntz,
    source_system string,
    source_record_id string,
    created_at timestamp_ntz
);

create or replace table mart.company_signals (
    company_signal_id string primary key,
    company_id string references mart.companies(company_id),
    signal_type string,
    signal_value string,
    signal_timestamp timestamp_ntz,
    is_late_arriving boolean,
    created_at timestamp_ntz
);

create or replace table mart.investor_profiles (
    investor_profile_id string primary key,
    investor_id string references mart.investors(investor_id),
    average_check_size number(18,2),
    stage_preference string,
    relationship_strength number(10,4),
    last_engagement_at timestamp_ntz,
    created_at timestamp_ntz,
    updated_at timestamp_ntz
);

create or replace table mart.outreach_events (
    outreach_event_id string primary key,
    deal_id string references mart.deals(deal_id),
    contact_id string references mart.contacts(contact_id),
    channel string,
    event_status string,
    message_template string,
    sent_at timestamp_ntz,
    created_at timestamp_ntz
);

create or replace table mart.crm_activities (
    crm_activity_id string primary key,
    company_id string references mart.companies(company_id),
    deal_id string references mart.deals(deal_id),
    activity_type string,
    activity_status string,
    activity_timestamp timestamp_ntz,
    owner_name string,
    created_at timestamp_ntz
);

create or replace table mart.deal_outcomes (
    deal_outcome_id string primary key,
    deal_id string references mart.deals(deal_id),
    outcome_type string,
    outcome_value string,
    outcome_timestamp timestamp_ntz,
    created_at timestamp_ntz
);

create or replace table mart.scoring_results (
    scoring_result_id string primary key,
    deal_id string references mart.deals(deal_id),
    company_id string references mart.companies(company_id),
    investor_id string references mart.investors(investor_id),
    deal_attractiveness_score number(10,4),
    investor_fit_score number(10,4),
    relationship_strength_score number(10,4),
    overall_priority_score number(10,4),
    score_version string,
    created_at timestamp_ntz
);

create or replace table ops.pipeline_runs (
    pipeline_run_id string primary key,
    pipeline_name string,
    run_status string,
    started_at timestamp_ntz,
    completed_at timestamp_ntz,
    row_count number,
    error_message string
);
