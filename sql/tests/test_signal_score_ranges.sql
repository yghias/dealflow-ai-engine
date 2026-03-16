select *
from intermediate.int_signal_scores
where overall_score < 0
   or overall_score > 1;
