with investor_edges as (
    select
        investor_name_left,
        investor_name_right,
        shared_company_count,
        relationship_edge_score
    from {{ ref('investor_relationship_edges') }}
),
contact_touchpoints as (
    select
        c.investor_id,
        o.deal_id,
        count(*) as outreach_touch_count,
        max(o.sent_at) as latest_touch_at
    from mart.outreach_events o
    join mart.contacts c
        on c.contact_id = o.contact_id
    where c.investor_id is not null
    group by 1,2
)
select
    e.investor_name_left,
    e.investor_name_right,
    e.shared_company_count,
    e.relationship_edge_score,
    ct.deal_id,
    ct.outreach_touch_count,
    ct.latest_touch_at
from investor_edges e
left join contact_touchpoints ct
    on ct.investor_id in (
        select investor_id
        from mart.investors
        where investor_name in (e.investor_name_left, e.investor_name_right)
    );
