create schema if not exists core;
create schema if not exists mart;

create table if not exists core.source_system (
    source_system_id uuid primary key,
    source_name text not null unique,
    source_type text not null,
    created_at timestamptz not null default now()
);

create table if not exists core.raw_document (
    raw_document_id uuid primary key,
    source_system_id uuid not null references core.source_system(source_system_id),
    external_id text,
    payload jsonb not null,
    payload_hash text not null,
    ingested_at timestamptz not null default now()
);

create table if not exists core.signal_event (
    signal_id uuid primary key,
    raw_document_id uuid not null references core.raw_document(raw_document_id),
    signal_type text not null,
    title text not null,
    url text not null,
    organization_name text,
    summary text not null,
    detected_at timestamptz not null,
    processed_at timestamptz not null default now()
);

create table if not exists core.organization (
    organization_id uuid primary key,
    canonical_name text not null unique,
    domain text,
    industry text,
    region text,
    created_at timestamptz not null default now()
);

create table if not exists core.crm_account (
    crm_account_id text primary key,
    organization_id uuid references core.organization(organization_id),
    crm_provider text not null,
    account_name text not null,
    owner_name text,
    stage text,
    synced_at timestamptz not null default now()
);

create table if not exists core.feature_snapshot (
    feature_snapshot_id uuid primary key,
    signal_id uuid not null references core.signal_event(signal_id),
    recency_score numeric(8,4) not null,
    crm_match_score numeric(8,4) not null,
    fit_score numeric(8,4) not null,
    evidence_score numeric(8,4) not null,
    created_at timestamptz not null default now()
);

create table if not exists core.score_result (
    score_result_id uuid primary key,
    signal_id uuid not null references core.signal_event(signal_id),
    feature_snapshot_id uuid not null references core.feature_snapshot(feature_snapshot_id),
    overall_score numeric(8,4) not null,
    rationale jsonb not null,
    created_at timestamptz not null default now()
);

create table if not exists core.strategy_recommendation (
    recommendation_id uuid primary key,
    signal_id uuid not null references core.signal_event(signal_id),
    priority text not null,
    recommendation_payload jsonb not null,
    prompt_version text not null,
    model_name text not null,
    created_at timestamptz not null default now()
);

create table if not exists core.task (
    task_id uuid primary key,
    recommendation_id uuid not null references core.strategy_recommendation(recommendation_id),
    destination_system text not null,
    destination_id text,
    task_status text not null,
    created_at timestamptz not null default now()
);
