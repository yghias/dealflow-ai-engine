select company_name, count(*)
from mart.companies
group by 1
having count(*) > 1;

select *
from mart.contacts
where full_name is null
   or title is null;

select *
from mart.deals d
left join mart.companies c on c.company_id = d.company_id
where c.company_id is null;

select *
from mart.scoring_results
where overall_priority_score < 0
   or overall_priority_score > 1;
