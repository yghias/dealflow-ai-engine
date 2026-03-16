select
    payload:investor_name::string as investor_name,
    payload:investor_type::string as investor_type,
    payload:focus_sectors::string as focus_sectors,
    payload:geography_focus::string as geography_focus,
    source_system,
    source_record_id,
    loaded_at
from raw.deal_signals_raw
where payload:investor_name is not null;
