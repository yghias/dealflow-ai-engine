select
    signal_type,
    count(*) as row_count,
    count(*) filter (where url is null or url = '') as missing_url_count,
    count(*) filter (where summary is null or summary = '') as missing_summary_count
from core.signal_event
group by 1;
