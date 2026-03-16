create or replace view ops.backfill_signal_windows as
select
    date_trunc('day', event_timestamp) as backfill_date,
    source_system,
    count(*) as landed_signals
from raw.deal_signals_raw
group by 1,2;

create or replace view ops.backfill_crm_windows as
select
    date_trunc('day', extracted_at) as backfill_date,
    source_system,
    count(*) as landed_accounts
from raw.crm_accounts_raw
group by 1,2;

create or replace view ops.backfill_investor_windows as
select
    date_trunc('day', extracted_at) as backfill_date,
    source_system,
    count(*) as landed_investors
from raw.investor_directory_raw
group by 1,2;
