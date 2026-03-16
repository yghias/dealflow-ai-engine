select *
from mart.mart_ranked_signal_queue
where owner_name is null
   or owner_name = '';
