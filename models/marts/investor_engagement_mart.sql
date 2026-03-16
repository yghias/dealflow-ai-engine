with outreach as (
    select
        contact_id,
        deal_id,
        channel,
        event_status,
        sent_at
    from mart.outreach_events
),
contacts as (
    select
        contact_id,
        investor_id,
        company_id,
        full_name,
        title
    from mart.contacts
),
joined as (
    select
        c.investor_id,
        o.deal_id,
        o.channel,
        o.event_status,
        o.sent_at
    from outreach o
    join contacts c
        on c.contact_id = o.contact_id
    where c.investor_id is not null
)
select
    investor_id,
    deal_id,
    count(*) as outreach_touch_count,
    count_if(event_status = 'responded') as responded_touch_count,
    max(sent_at) as latest_outreach_at
from joined
group by 1, 2;
