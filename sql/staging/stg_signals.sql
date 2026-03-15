create schema if not exists staging;

create table if not exists staging.signal_event_raw (
    source_name text not null,
    external_id text,
    title text not null,
    url text not null,
    payload jsonb not null,
    detected_at timestamptz not null,
    loaded_at timestamptz not null default now()
);
